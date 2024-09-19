//
//  File.swift
//  
//
//  Created by admin on 2024/9/5.
//

#if os(iOS)

import SwiftUI

public struct LanguagePickerView: View {
    
    @Binding private var selectedLanguage: LanguageManager
    
    private let languages: [LanguageManager]
    
    public init(selectedLanguage: Binding<LanguageManager>, languages: [LanguageManager]) {
        self._selectedLanguage = selectedLanguage
        self.languages = languages
    }
    
    public var body: some View {
        
        DynamicScrollView {
            LazyVStack(alignment: .center, spacing: 1) {
                ForEach(languages, id: \.self) { language in
                    LazyHStack {
                        Button(action: {
                            selectedLanguage = language
                        }) {
                            HStack {
                                Spacer()
                                Text(language.name)
                                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                                if language == selectedLanguage {
                                    Image(systemName: "checkmark")
                                }
                                Spacer()
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 44) // 让按钮占满整个屏幕宽度
                        .foregroundColor(Color.primary)
                    }
                }
            }
            .padding(20)
        }
        .gradientTheme1
    }
    
}

#endif
