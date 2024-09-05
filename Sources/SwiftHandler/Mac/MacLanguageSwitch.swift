//
//  File.swift
//  
//
//  Created by admin on 2024/9/2.
//

import SwiftUI

public struct MacLanguageSwitch: View {
    
    @Binding var source: LanguageManager
    @Binding var target: LanguageManager
    
    /// 显示语言选择列表的状态
    @State private var showSourceLanguageView = false
    
    @State private var showTargetLanguageView = false
    
    let languages = LanguageManager.allCases
    
    // 自定义 public 初始化方法
    public init(source: Binding<LanguageManager>, target: Binding<LanguageManager>) {
        self._source = source
        self._target = target
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 2) {
            Menu {
                ForEach(LanguageManager.allCases, id: \.self) { language in
                    Button(action: {
                        withAnimation() {
                            source = language
                            CacheManager.shared.saveSourceLanguage(with: language.identifier)
                        }
                    }) {
                        Text(language.name)
                    }
                }
            } label: {
                Text(source.name)
            }
            .fixedSize()
            
            Button {
                withAnimation {
                    swap(&source, &target)
                } completion: {
                    CacheManager.shared.saveSourceLanguage(with: source.identifier)
                    CacheManager.shared.saveTargetLanguage(with: target.identifier)
                }
            } label: {
                Image(systemName: "arrow.left.arrow.right")
                    .imageScale(.medium)
            }
            .fixedSize()
            
            Menu {
                ForEach(LanguageManager.allCases, id: \.self) { language in
                    Button(action: {
                        withAnimation() {
                            target = language
                            CacheManager.shared.saveTargetLanguage(with: language.identifier)
                        }
                    }) {
                        Text(language.name)
                    }
                }
            } label: {
                Text(target.name)
            }
            .fixedSize()
        }
    }
}

#Preview {
    MacLanguageSwitch(source: .constant(.zh_Hans), target: .constant(.en_US))
}

