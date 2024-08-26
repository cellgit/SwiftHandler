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

import QuickLook


import UniformTypeIdentifiers
let markdownUTI = UTType("net.daringfireball.markdown")!
let wordDocType = UTType("com.microsoft.word.doc")!
let wordDocxType = UTType("org.openxmlformats.wordprocessingml.document")!

public class SupportedUrlType {
    
    public static let shared = SupportedUrlType()
    
    private init() {}
    
    public var allTypes: [UTType] {
    
        [.pdf,
         .plainText,
         .utf8PlainText,
         .utf16PlainText,
         .utf16ExternalPlainText,
         
         .commaSeparatedText,
         .tabSeparatedText,
         .utf8TabSeparatedText,
         
         .rtf,
         
         .html,
         
         .xml,
         .yaml,
         .json,
         
         .sourceCode,
         .cSource,
         .objectiveCSource,
         .swiftSource,
         .cPlusPlusSource,
         .cHeader,
         .cPlusPlusHeader,
         .script,
         
         .log,
         
         .vCard,
         
         .m3uPlaylist,
         
         .png,
         .jpeg,
         .tiff,
         .heic,
         .heif,
         
         markdownUTI,
         wordDocType,
         wordDocxType,
         
        ]
        
        
    }
    
    
}


public struct UniversalTextExtractor: View {
    
    public let url: URL
    
    @Binding public var extractedText: String
    
    public var body: some View {
        VStack {
            ScrollView {
                Text(extractedText)
                    .padding()
            }
        }
        .onAppear {
            extractText(from: url)
        }
    }
    
    func extractText(from url: URL) {
        guard let fileType = UTType(filenameExtension: url.pathExtension) else {
            extractedText = "Unsupported file type."
            return
        }
        
        switch fileType {
        case .pdf:
            extractTextFromPDF(url: url)
            //        case .rtf, .plainText, .utf8PlainText, .utf16PlainText:
        case .plainText, .utf8PlainText, .utf16PlainText, .utf16ExternalPlainText:
            getTextFromPlainText(url: url)
        case .commaSeparatedText, .tabSeparatedText, .utf8TabSeparatedText:
            getTextFromDelimitedText(url: url)
        case .rtf:
            getTextFromRTF(url: url)
        case .html:
            getTextFromHTML(url: url)
        case .xml, .yaml, .json:
            getTextFromXMLOrYAMLOrJSON(url: url)
        case .sourceCode, .cSource, .objectiveCSource, .swiftSource, .cPlusPlusSource, .cHeader, .cPlusPlusHeader, .script:
            getTextFromSourceCode(url: url)
        case .log:
            getTextFromLog(url: url)
        case .vCard:
            getTextFromVCard(url: url)
        case .m3uPlaylist:
            getTextFromM3UPlaylist(url: url)
        case .png, .jpeg, .tiff, .heic, .heif:
            getTextFromImage(url: url)
        default:
            let lowercased = url.pathExtension.lowercased()
            if lowercased == "md" {
                extractTextFromMarkdown(url: url)
            }
            else if lowercased == "doc" || lowercased == "docx" {
                extractTextFromWord(url: url)
            }
            else {
                extractedText = "Unsupported file type."
            }
        }
    }
    
    func extractTextFromTXT(url: URL) {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            extractedText = text
        } catch {
            print("Failed to extract text from TXT: \(error)")
        }
    }
    func extractTextFromMarkdown(url: URL) {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            extractedText = text
        } catch {
            print("Failed to extract text from Markdown: \(error)")
        }
    }
    
    func extractTextFromPDF(url: URL) {
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
    
    
    
    func extractTextFromWord(url: URL) {
        do {
            let attributedString = try NSAttributedString(url: url, options: [.documentType: NSAttributedString.DocumentType.officeOpenXML], documentAttributes: nil)
            extractedText = attributedString.string
        } catch {
            extractedText = "Failed to extract text from Word document: \(error)"
        }
    }
    
    
}


extension UniversalTextExtractor {
    func getTextFromPlainText(url: URL) {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            extractedText = text.isEmpty ? "No text found in plain text." : text
        } catch {
            extractedText = "Failed to extract text from plain text: \(error)"
        }
    }
    func getTextFromDelimitedText(url: URL) {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            extractedText = text.isEmpty ? "No text found in delimited text." : text
        } catch {
            extractedText = "Failed to extract text from delimited text: \(error)"
        }
    }
    
    func getTextFromRTF(url: URL) {
        do {
            let attributedString = try NSAttributedString(url: url, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
            extractedText = attributedString.string
        } catch {
            extractedText = "Failed to extract text from RTF: \(error)"
        }
    }
    func getTextFromHTML(url: URL) {
        do {
            let attributedString = try NSAttributedString(url: url, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            extractedText = attributedString.string
        } catch {
            extractedText = "Failed to extract text from HTML: \(error)"
        }
    }
    func getTextFromXMLOrYAMLOrJSON(url: URL) {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            extractedText = text.isEmpty ? "No text found in XML/YAML/JSON." : text
        } catch {
            extractedText = "Failed to extract text from XML/YAML/JSON: \(error)"
        }
    }
    func getTextFromSourceCode(url: URL) {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            extractedText = text.isEmpty ? "No text found in source code." : text
        } catch {
            extractedText = "Failed to extract text from source code: \(error)"
        }
    }
    func getTextFromLog(url: URL) {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            extractedText = text.isEmpty ? "No text found in log file." : text
        } catch {
            extractedText = "Failed to extract text from log file: \(error)"
        }
    }
    func getTextFromVCard(url: URL) {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            extractedText = text.isEmpty ? "No text found in vCard." : text
        } catch {
            extractedText = "Failed to extract text from vCard: \(error)"
        }
    }
    func getTextFromM3UPlaylist(url: URL) {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            extractedText = text.isEmpty ? "No text found in M3U playlist." : text
        } catch {
            extractedText = "Failed to extract text from M3U playlist: \(error)"
        }
    }
    
}

extension UniversalTextExtractor {
    
    func getTextFromImage(url: URL) {
        guard let image = NSImage(contentsOf: url) else {
            print("Failed to load image.")
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            guard error == nil else {
                print("Failed to recognize text: \(error!.localizedDescription)")
                return
            }
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                extractedText = text
            }
        }
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error)")
        }
    }
    
}


#endif






//    func extractText(from url: URL) {
//        let fileExtension = url.pathExtension.lowercased()
//
//        switch fileExtension {
//        case "pdf":
//            extractTextFromPDF(url: url)
//        case "rtf", "docx":
//            extractTextFromRTFOrText(url: url)
//        case "txt":
//            extractTextFromTXT(url: url)
////        case "docx", "doc":
////            extractTextFromWord(url: url)
//        case "png", "jpg", "jpeg", "tiff":
//            extractTextFromImage(url: url)
//        case "md":
//            extractTextFromMarkdown(url: url)
//        default:
//            extractedText = "Unsupported file type."
//        }
//    }
