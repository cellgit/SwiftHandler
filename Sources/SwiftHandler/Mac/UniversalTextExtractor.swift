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
import QuickLook

struct UniversalTextExtractor: View {
    let url: URL
    @Binding var extractedText: String
    
    var body: some View {
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
        case .rtf, .plainText, .utf8PlainText, .utf16PlainText:
            extractTextFromRTFOrText(url: url)
        case .png, .jpeg, .tiff:
            extractTextFromImage(url: url)
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
    
    func extractTextFromRTFOrText(url: URL) {
        do {
            let attributedString = try NSAttributedString(url: url, options: [:], documentAttributes: nil)
            extractedText = attributedString.string
        } catch {
            print("Failed to extract text from RTF or Text: \(error)")
        }
    }
    
//    func extractTextFromWord(url: URL) {
//        // Implementation for extracting text from a Word document (DOCX)
//        do {
//            let attributedString = try NSAttributedString(url: url, options: [.documentType: NSAttributedString.DocumentType.docx], documentAttributes: nil)
//            extractedText = attributedString.string
//        } catch {
//            print("Failed to extract text from Word: \(error)")
//        }
//    }
    
    func extractTextFromImage(url: URL) {
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
    
    func extractTextFromWord(url: URL) {
        do {
            let attributedString = try NSAttributedString(url: url, options: [.documentType: NSAttributedString.DocumentType.officeOpenXML], documentAttributes: nil)
            extractedText = attributedString.string
        } catch {
            extractedText = "Failed to extract text from Word document: \(error)"
        }
    }
    
    
}


#endif

