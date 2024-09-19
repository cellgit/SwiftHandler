//
//  File.swift
//  
//
//  Created by admin on 2024/9/4.
//

#if os(iOS)

import SwiftUI
import UIKit

public struct AutoSizingTextEditor: View {
    
    @Binding var text: String
    @Binding var textViewHeight: CGFloat
    
    var placeholder: String
    
    public init(text: Binding<String>, textViewHeight: Binding<CGFloat>, placeholder: String) {
        self._text = text
        self._textViewHeight = textViewHeight
        self.placeholder = placeholder
        
        // 初始化时计算文字高度并设置textViewHeight
        if text.wrappedValue.isEmpty {
            // 如果文本为空，设置为默认高度 52
            self._textViewHeight = .constant(52)
        } else {
            // 如果文本不为空，计算实际的文本高度
            let calculatedHeight = calculateTextViewHeight(for: text.wrappedValue)
            self._textViewHeight = .constant(calculatedHeight)
        }
    }
    
    public var body: some View {
        TextEditor(text: $text)
            .font(.system(size: 17, weight: .regular, design: .monospaced))
            .scrollDismissesKeyboard(.immediately)
            .scrollContentBackground(.hidden)
            .opacity(text.isEmpty ? 0.5 : 1)
            .padding(6)
            .frame(minHeight: textViewHeight, maxHeight: 280)
            .fixedSize(horizontal: false, vertical: true)
            .background(
                RoundedRectangle(cornerRadius: 10) // 设置圆角背景
                    .stroke(Color.clear, lineWidth: 1) // 外边框
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground))) // 内部填充
                    .opacity(0.8)
            )
            .background(GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        adjustTextViewHeight(geometry: geometry)
                    }
                    .onChange(of: text) { oldValue, newValue in
                        withAnimation(.smooth(duration: 0.1)) {
                            adjustTextViewHeight(geometry: geometry)
                        }
                    }
            })
            .overlay(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.gray)
                        .padding(.leading, 12)
                }
            }
        
    }
    
    private func adjustTextViewHeight(geometry: GeometryProxy) {
        Task {
            await MainActor.run {
                let newHeight = geometry.size.height
                if newHeight != textViewHeight {
                    textViewHeight = newHeight
                    debugPrint("newHeight ====== \(newHeight)")
                }
            }
        }
    }
    
    // 使用UITextView计算文字高度的方法
    private func calculateTextViewHeight(for text: String) -> CGFloat {
        let textView = UITextView()
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        // 32 是margin两边边距各16,12是editor padding,两边各6
        let size = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 32 - 12, height: CGFloat.greatestFiniteMagnitude))
        // 12 是editor上下padding各6
        return max(size.height+12, 52) // 最小高度为52
    }
}

#endif



















//#if os(iOS)
//
//import SwiftUI
//
//public struct AutoSizingTextEditor: View {
//    
//    @Binding var text: String
//    @Binding var textViewHeight: CGFloat
//    
//    var placeholder: String
//    
//    public init(text: Binding<String>, textViewHeight: Binding<CGFloat>, placeholder: String) {
//        self._text = text
//        self._textViewHeight = textViewHeight
//        self.placeholder = placeholder
//    }
//    
//    public var body: some View {
//        TextEditor(text: $text)
//            .scrollDismissesKeyboard(.immediately)
//            .scrollContentBackground(.hidden)
//            .opacity(text.isEmpty ? 0.5 : 1)
//            .padding(6)
//            .frame(minHeight: 52, maxHeight: 280)
//            .fixedSize(horizontal: false, vertical: true)
//            .background(
//                RoundedRectangle(cornerRadius: 10) // 设置圆角背景
//                    .stroke(Color.clear, lineWidth: 1) // 外边框
//                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground))) // 内部填充
//                    .opacity(0.8)
//            )
//            .background(GeometryReader { geometry in
//                Color.clear
//                    .onAppear {
//                        adjustTextViewHeight(geometry: geometry)
//                    }
//                    .onChange(of: text) { oldValue, newValue in
//                        withAnimation(.smooth(duration: 0.1)) {
//                            adjustTextViewHeight(geometry: geometry)
//                        }
//                    }
//            })
//            .overlay(alignment: .leading) {
//                if text.isEmpty {
//                    Text(placeholder)
//                        .foregroundColor(Color.gray)
//                        .padding(.leading, 12)
//                }
//            }
//        
//    }
//    
//    private func adjustTextViewHeight(geometry: GeometryProxy) {
//        DispatchQueue.main.async {
//            let newHeight = geometry.size.height
//            if newHeight != textViewHeight {
//                textViewHeight = newHeight
//                debugPrint("newHeight ====== \(newHeight)")
//            }
//        }
//    }
//}
//
//#endif
