//
//  File.swift
//  
//
//  Created by admin on 2024/9/2.
//

import SwiftUI
import Vision
import PDFKit
import SwiftHandler

public struct PDFKitView: View {
    
    let url: URL
    
    @Binding var extractedText: String
    
    public init(url: URL, extractedText: Binding<String>) {
        self.url = url
        self._extractedText = extractedText
    }
    
    
    public var body: some View {
        
        PDFKitRepresentedView(url)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                extractTextFromPDF(with: url)
//                extractTextUsingOCR(from: url)
//                extractRichTextFromPDF(url: url)
//                extractTextFromPDF(url: url)
//                extractRichTextFromPDF(url: url)
            }
            .onChange(of: url) { oldValue, newValue in
                extractTextFromPDF(with: newValue)
//                extractTextUsingOCR(from: newValue)
//                extractRichTextFromPDF(url: newValue)
//                extractTextFromPDF(url: url)
//                extractRichTextFromPDF(url: newValue)
            }
            .onChange(of: extractedText) { oldValue, newValue in
                if oldValue != newValue {
                    extractedText = newValue
                }
            }
            
    }
    
    private func extractTextFromPDF(with url: URL) {
        debugPrint("extractTextFromPDF")
        guard let pdfDocument = PDFDocument(url: url) else {
            debugPrint("Failed to load PDF document")
            return
        }
        debugPrint("extractTextFromPDF 22222")
        var text = ""
        for pageIndex in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex) {
                text += page.string ?? ""
            }
        }
        
        extractedText = text
    }
    
}

#Preview {
    PDFKitView(url: URL(filePath: "/Users/admin/Downloads/hello_test.pdf"), extractedText: .constant("source text"))
}


extension PDFKitView {

    func extractTextFromPDF(url: URL) {
        do {
            // 使用 NSAttributedString 从 PDF 文档中提取文本
            let attributedString = try NSAttributedString(url: url, options: [.documentType: NSAttributedString.DocumentType.officeOpenXML], documentAttributes: nil)
            extractedText = attributedString.string
        } catch {
            extractedText = "Failed to extract text from PDF document: \(error)"
        }
    }

    private func extractTextUsingOCR(from pdfUrl: URL) -> String {
        guard let pdfDocument = PDFDocument(url: pdfUrl) else {
            return ""
        }
        
        for pageIndex in 0..<pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: pageIndex) else { continue }
            
            let pageBounds = page.bounds(for: .mediaBox)
            let pageImage = page.thumbnail(of: pageBounds.size, for: .mediaBox)
            
            // 将NSImage转换为CGImage
            guard let cgImage = pageImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else { continue }
            
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    return
                }
                let pageText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
                extractedText += pageText + "\n"
                debugPrint("extractedText === \(extractedText)")
            }
            
            do {
                try requestHandler.perform([request])
            } catch {
                print("Error performing OCR: \(error)")
            }
        }
        
        debugPrint("extractedText2 === \(extractedText)")
        return extractedText
    }
    
    private func performTextRecognition(on cgImage: CGImage, completion: @escaping (Result<String, Error>) -> Void) {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                DispatchQueue.main.async {
                    completion(.success(text))
                }
            }
        }
        
        // 自动检测语言
        request.automaticallyDetectsLanguage = true
        request.usesLanguageCorrection = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }
}



//private func extractTextFromPDFImage(with url: URL) {
//    let visionTextManager = VisionTextManager()
//    visionTextManager.getTextFromImage(url: url) { result in
//        switch result {
//        case .success(let text):
//            extractedText = text
//        case .failure(let error):
//            extractedText = "Failed to extract text from image: \(error.localizedDescription)"
//        }
//    }
//}
