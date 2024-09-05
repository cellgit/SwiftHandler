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
            LazyVStack(alignment: .center, spacing: 16) {
                ForEach(languages, id: \.self) { language in
                    LazyHStack {
                        Button(action: {
                            selectedLanguage = language
                            debugPrint("selectedLanguage is \(selectedLanguage)")
                        }) {
                            HStack {
                                Text(language.name)
                                if language == selectedLanguage {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        .foregroundColor(Color.primary)
                    }
                }
            }
            .padding()
        }
        .gradientTheme1
    }
    
}

#endif
