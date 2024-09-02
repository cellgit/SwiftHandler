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

public struct WebKitView: View {
    
    let url: URL
    
    @Binding var extractedText: String
    
    public init(url: URL, extractedText: Binding<String>) {
        self.url = url
        self._extractedText = extractedText
    }
    
    
    public var body: some View {
        
        WebViewRepresentedView(url: url)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                extractTextFromWebView(url: url)
            }
            .onChange(of: url) { oldValue, newValue in
                extractTextFromWebView(url: newValue)
            }
            .onChange(of: extractedText) { oldValue, newValue in
                if oldValue != newValue {
                    extractedText = newValue
                }
            }
            
    }
    
    func extractTextFromWebView(url: URL) {
        do {
            // 使用 NSAttributedString 从 PDF 文档中提取文本
            let attributedString = try NSAttributedString(url: url, options: [.documentType: NSAttributedString.DocumentType.webArchive], documentAttributes: nil)
            extractedText = attributedString.string
        } catch {
            extractedText = "Failed to extract text from PDF document: \(error)"
        }
    }
    
}

#Preview {
    PDFKitView(url: URL(filePath: "/Users/admin/Downloads/hello_test.pdf"), extractedText: .constant("source text"))
}
