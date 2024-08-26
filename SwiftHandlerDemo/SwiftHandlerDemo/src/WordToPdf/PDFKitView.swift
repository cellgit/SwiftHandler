//
//  PDFKitView.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/26.
//

#if os(macOS)

import SwiftUI
import PDFKit

struct PDFKitView: View {
    
    let url: URL
    
    @Binding var extractedText: String
    
    var body: some View {
        
        PDFKitRepresentedView(url)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                extractTextFromPDF(with: url)
            }
            .onChange(of: url) { oldValue, newValue in
                extractTextFromPDF(with: newValue)
                
            }
            .onChange(of: extractedText) { oldValue, newValue in
                if oldValue != newValue {
                    extractedText = newValue
                }
            }
            
    }
    
    func extractTextFromPDF(with url: URL) {
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

#endif

