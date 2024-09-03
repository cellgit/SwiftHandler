//
//  UniversalTextExtractor.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/26.
//

#if os(macOS)

import SwiftUI
import PDFKit
import Vision
import UniformTypeIdentifiers
//import QuickLook

public struct UniversalTextExtractor: View {
    
    let url: URL
    
    @Binding var extractedText: String
    
    // 自定义 public 初始化方法
    public init(url: URL, extractedText: Binding<String>) {
        self.url = url
        self._extractedText = extractedText
    }
    
    public var body: some View {
        VStack {
            ScrollView {
                Text(extractedText)
                    .lineSpacing(3)
                    .padding()
            }
        }
        .onAppear {
            extractText(from: url)
        }
    }
    
    var attributedStringType: NSAttributedString.DocumentType? {
        guard let fileType = UTType(filenameExtension: url.pathExtension) else {
            extractedText = "Unsupported file type."
            return nil
        }
        switch fileType {
        case .plainText, .utf8PlainText, .utf16PlainText, .utf16ExternalPlainText:
            return .plain
        case .rtf:
            return .rtf
        case .rtfd:
            return .rtfd
        case .html:
            return .html
        case .commaSeparatedText, .tabSeparatedText, .utf8TabSeparatedText:
            return nil
        case .xml, .yaml, .json:
            return nil
        case .sourceCode, .cSource, .objectiveCSource, .swiftSource, .cPlusPlusSource, .cHeader, .cPlusPlusHeader, .script:
            return nil
        case .log:
            return nil
        case .vCard:
            return nil
        case .m3uPlaylist:
            return nil
        case .png, .jpeg, .tiff, .heic, .heif:
            return nil
        default:
            let lowercased = url.pathExtension.lowercased()
            switch lowercased {
            case "doc":
                return .docFormat
            case "docx":
                return .officeOpenXML
            case "odt":
                return .openDocument
            case "md":
                return nil
            case "webarchive":
                return .webArchive
            default:
                // 不支持的类型
                return nil
            }
            
        }
    }
    
    
    func extractText(from url: URL) {
        guard let fileType = UTType(filenameExtension: url.pathExtension) else {
            extractedText = "Unsupported file type."
            return
        }
        
        if let attributedType = attributedStringType {
            getAttributedText(with: attributedType)
        }
        else {
            
            switch fileType {
            case .pdf:
                getTextFromPDF(with: url)
            case .png, .jpeg, .tiff, .heic, .heif:
                getTextFromImage(url: url)
            case .commaSeparatedText, .tabSeparatedText, .utf8TabSeparatedText,
                    .xml, .yaml, .json,
                    .sourceCode, .cSource, .objectiveCSource, .swiftSource, .cPlusPlusSource, .cHeader, .cPlusPlusHeader, .script,
                    .log,
                    .vCard,
                    .m3uPlaylist:
                getTextFromUrl(with: url)
            default:
                getTextFromUrl(with: url)
            }
        }
    }
    
}


extension UniversalTextExtractor {
    func getAttributedText(with type: NSAttributedString.DocumentType) {
        do {
            let attributedString = try NSAttributedString(url: url, options: [.documentType: type], documentAttributes: nil)
            extractedText = attributedString.string
        } catch {
            extractedText = "Failed to extract text from RTF: \(error)"
        }
    }
    
    
    func getTextFromUrl(with url: URL) {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            extractedText = text
        } catch {
            print("Failed to extract text from TXT: \(error)")
        }
    }
    
    func getTextFromPDF(with url: URL) {
        guard let pdfDocument = PDFDocument(url: url) else {
            print("Failed to open PDF document.")
            return
        }
        
        var fullText = ""
        for pageIndex in 0..<pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: pageIndex) else { continue }
            if let pageText = page.string {
                fullText += pageText
            }
        }
        extractedText = fullText
    }
    
    func getTextFromImage(url: URL) {
        let visionTextManager = VisionTextManager()
        visionTextManager.getTextFromImage(url: url) { result in
            switch result {
            case .success(let text):
                extractedText = text
            case .failure(let error):
                extractedText = "Failed to extract text from image: \(error.localizedDescription)"
            }
        }
    }
    
}


#endif
