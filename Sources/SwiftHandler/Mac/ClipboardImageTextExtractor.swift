//
//  File.swift
//  
//
//  Created by admin on 2024/8/27.
//

#if os(macOS)

import SwiftUI
import PDFKit
import Vision
import QuickLook
import UniformTypeIdentifiers

public struct ClipboardImageTextExtractor: View {
    
    @Binding var extractedText: String
    
    // 自定义 public 初始化方法
    public init(extractedText: Binding<String>) {
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
        .onChange(of: extractedText) { oldValue, newValue in
            extractedText = newValue
        }
        .onAppear {
            getTextFromImage() // 视图加载时调用方法提取文本
        }
    }
    
    
    
    
    
}

extension ClipboardImageTextExtractor {
    
    public func getTextFromImage() {
        let visionTextManager = VisionTextManager()
        visionTextManager.getTextFromClipboard { result in
            switch result {
            case .success(let text):
                extractedText = text//.improvedPostProcessText()
            case .failure(let error):
                extractedText = "Failed to extract text from image: \(error.localizedDescription)"
            }
        }
    }
    
}


#endif
