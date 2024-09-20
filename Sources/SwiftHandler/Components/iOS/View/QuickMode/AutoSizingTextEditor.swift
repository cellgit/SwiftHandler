//
//  File.swift
//  
//
//  Created by admin on 2024/9/4.
//

#if os(iOS)

import SwiftUI

public struct AutoSizingTextEditor: View {
    
    @Binding var text: String
    @Binding var textViewHeight: CGFloat
    
    var placeholder: String
    
    // 初始更新高度
    @Binding var isInitUpdateHeight: Bool
    
    public init(text: Binding<String>, textViewHeight: Binding<CGFloat>, placeholder: String, isInitUpdateHeight: Binding<Bool>) {
        self._text = text
        self._textViewHeight = textViewHeight
        self.placeholder = placeholder
        self._isInitUpdateHeight = isInitUpdateHeight
    }
    
    public var body: some View {
        TextEditor(text: $text)
            .scrollDismissesKeyboard(.immediately)
            .scrollContentBackground(.hidden)
            .opacity(text.isEmpty ? 0.5 : 1)
            .padding(6)
            .frame(minHeight: 52, maxHeight: 280)
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
                        // 保证显示后,如果初始有文字,要更新Editor高度
                        if isInitUpdateHeight {
                            self.text = ""
                        }
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
        DispatchQueue.main.async {
            let newHeight = geometry.size.height
            if newHeight != textViewHeight {
                textViewHeight = newHeight
                debugPrint("newHeight ====== \(newHeight)")
            }
        }
    }
}

#endif
