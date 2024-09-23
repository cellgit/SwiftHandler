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
    
    @Binding var isStar: Bool
    
    @State var isCopied: Bool = false
    
    var onAction: (TextEditorToolsView.ActionType) -> Void
    
    public enum ActionType {
        case onStar(Bool)
        case onCopied(Bool)
    }
    
    public init(text: Binding<String>, targetText: Binding<String>, isSourceTextEmpty: Bool = true, isStar: Binding<Bool>, onAction: @escaping (TextEditorToolsView.ActionType) -> Void) {
        self._text = text
        self._targetText = targetText
        self._isStar = isStar
        self.isSourceTextEmpty = isSourceTextEmpty
        self.onAction = onAction
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
                        Text(LocalStrings.paste.text)
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                    }
                    .padding(8)
                    .background(Color("bg_blue"))
                    .cornerRadius(30)
                }
            }
            else {
                Button {
                    text = ""
                    targetText = ""
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "eraser")
                        Text(LocalStrings.clear.text)
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                    }
                    .padding(8)
                    .background(Color("bg_blue"))
                    .cornerRadius(30)
                }
            }
            
//            Button {
//                debugPrint("添加到历史记录")
//            } label: {
//                HStack(spacing: 4) {
//                    Image(systemName: "arrow.right")
//                }
//                .padding(8)
//                .background(Color("bg_blue"))
//                .cornerRadius(30)
//            }
            
            Spacer()
            
            if !isSourceTextEmpty {
                Button(action: {
                    if !targetText.isEmpty {
                        PasteboardManager.shared.copy(targetText)
                        isCopied = true
                        // 已复制提示回调
                        onAction(.onCopied(true))
                        // 3秒后将 isCopy 设为 false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isCopied = false
                        }
                    }
                    else {
                        onAction(.onCopied(false))
                        debugPrint("复制的译文不能为空")
                    }
                }, label: {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(isCopied ? .gray : .primary)
                    
//                    Image(systemName: "heart.text.clipboard")
//                        .symbolRenderingMode(isCopied ? .multicolor : .monochrome)
                })
                .disabled(isCopied)
                
                Button {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isStar.toggle()
                        onAction(.onStar(isStar))
                    }
                } label: {
                    HStack(spacing: 4) {
//                        Image(systemName: isStar ? "star.fill" : "star")
//                            .symbolRenderingMode(isStar ? .multicolor : .monochrome)
                        Image(systemName: "star")
                            .foregroundColor(.primary)
                            .symbolRenderingMode(isStar ? .multicolor : .monochrome)
                    }
                }
                
            }
        }
        .foregroundColor(Color(.label))
        .onChange(of: text) { oldValue, newValue in
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
    TextEditorToolsView(text: .constant("这是输入的文字"), targetText: .constant("译文内容"), isStar: .constant(false)) { type in
        
    }
}

#endif
