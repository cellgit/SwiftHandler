//
//  TextEditorToolsView.swift
//  HandlerDemo
//
//  Created by admin on 2024/9/4.
//

#if os(iOS)

import SwiftUI
import SwiftHandler

public struct TextEditorToolsView: View {
    
    @Binding var text: String
    
    @Binding var targetText: String
    
    @State var isSourceTextEmpty: Bool = true
    
    @State var isStar: Bool = false
    
    @State var isCopied: Bool = false
    
    public init(text: Binding<String>, targetText: Binding<String>, isSourceTextEmpty: Bool = true, isStar: Bool = false) {
        self._text = text
        self._targetText = targetText
        self.isSourceTextEmpty = isSourceTextEmpty
        self.isStar = isStar
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 8) {
            
            if isSourceTextEmpty {
                Button {
                    if let pasteText = PasteboardManager.shared.paste() as? String {
                        text = pasteText
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "document.on.clipboard")
                        Text("粘贴")
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                    }
                    .foregroundColor(Color(.label))
                    .padding(8)
                    .background(Color("bg_blue"))
                    .cornerRadius(30)
                }
            }
            
            Spacer()
            
            if !isSourceTextEmpty {
                Button(action: {
                    if !targetText.isEmpty {
                        PasteboardManager.shared.copy(targetText)
                        isCopied = true
                        // 3秒后将 isCopy 设为 false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isCopied = false
                        }
                    }
                    else {
                        debugPrint("复制的译文不能为空")
                    }
                }, label: {
                    Image(systemName: "heart.text.clipboard")
                        .symbolRenderingMode(isCopied ? .multicolor : .monochrome)
                        .foregroundColor(Color(.label))
                })
            }
            
            
            if !isSourceTextEmpty {
                Button {
                    isStar = !isStar
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "star")
                            .symbolRenderingMode(isStar ? .multicolor : .monochrome)
                    }
                    .foregroundColor(Color(.label))
                }
            }
        }
        .onChange(of: text) { oldValue, newValue in
            if oldValue != newValue {
                isStar = false
            }
            withAnimation(.smooth(duration: 0.1)) {
                isSourceTextEmpty = newValue.isEmpty
            }
        }
        .onChange(of: targetText) { oldValue, newValue in
            if oldValue != newValue {
                isCopied = false
            }
        }
        
    }
    
}

#Preview {
    TextEditorToolsView(text: .constant("这是输入的文字"), targetText: .constant("译文内容"))
}

#endif
