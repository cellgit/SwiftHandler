//
//  File.swift
//  
//
//  Created by admin on 2024/9/4.
//

#if os(iOS)
import UIKit

//let screenWidth = UIScreen.main.bounds.width


import SwiftUI
import SwiftHandler

// arrow.left.arrow.right

public struct LanguageSwitch: View {
    /// 源语言
    @Binding var source: LanguageManager
    /// 目标语言
    @Binding var target: LanguageManager
    
    /// 显示语言选择列表的状态
    @State private var showSourceLanguageView = false
    
    @State private var showTargetLanguageView = false
    
    @State private var settingsDetent = PresentationDetent.height(500)
    
    
    public init(source: Binding<LanguageManager>, target: Binding<LanguageManager>, showSourceLanguageView: Bool = false, showTargetLanguageView: Bool = false, settingsDetent: SwiftUI.PresentationDetent = PresentationDetent.height(500)) {
        self._source = source
        self._target = target
        self.showSourceLanguageView = showSourceLanguageView
        self.showTargetLanguageView = showTargetLanguageView
        self.settingsDetent = settingsDetent
    }
    
    private let languages = LanguageManager.allCases
    
    public var body: some View {
        
        VStack {
            Spacer()
            HStack(alignment: .center) {
                // 源语言
                Button {
                    debugPrint("switch original language")
                    showSourceLanguageView.toggle()
                } label: {
                    HStack(alignment: .center, spacing: 0) {
                        Text(source.name)
                            .font(.system(size: 15, weight: .medium, design: .monospaced))
                            .padding(4)
//                        Image(systemName: "chevron.down")
//                            .font(Font.system(size: 14, weight: .regular))
                    }
                }
                .foregroundColor(.primary)
                .padding(.trailing, 4)
                .frame(width: (UIScreen.main.bounds.size.width - 32) / 3, alignment: .trailing)
                
                // 互换语言
                Button {
                    debugPrint("exchange source and target language")
                    withAnimation {
                        swap(&source, &target)
                    }
                } label: {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(Font.system(size: 16, weight: .light))
                        .foregroundColor(Color.secondary)
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .background(Color("bg"))
                        .cornerRadius(16)
                }
                .foregroundColor(.primary)
                .padding(.leading, 4)
                .frame(width: 32, height: 32, alignment: .center)
                // 目标语言
                Button {
                    debugPrint("switch target language")
                    showTargetLanguageView.toggle()
                } label: {
                    HStack(alignment: .center, spacing: 0) {
                        Text(target.name)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .padding(4)
//                        Image(systemName: "chevron.down")
//                            .font(Font.system(size: 14, weight: .regular))
                    }
                }
                .foregroundColor(.primary)
                .padding(.leading, 4)
                .frame(width: (UIScreen.main.bounds.size.width-32)/3, height: 44, alignment: .leading)
            }
            .frame(width: UIScreen.main.bounds.size.width, height: 44)
//            .background(Color(.systemBlue))
            .sheet(isPresented: $showSourceLanguageView) {
                LanguagePickerView(selectedLanguage: $source, languages: languages)
                    .presentationDetents([.fraction(0.5), .fraction(0.9)])
                    .presentationDragIndicator(.hidden)
                    .presentationCornerRadius(16)
            }
            .sheet(isPresented: $showTargetLanguageView) {
                LanguagePickerView(selectedLanguage: $target, languages: languages)
                    .presentationDetents([.fraction(0.5), .fraction(0.9)])
                    .presentationDragIndicator(.hidden)
                    .presentationCornerRadius(16)
            }
        }
        
        
    }
}

#Preview {
    LanguageSwitch(source: .constant(.zh_Hans), target: .constant(.en_US))
}

struct LanguagePickerView: View {
    
    @Binding var selectedLanguage: LanguageManager
    
    let languages: [LanguageManager]
    
    var body: some View {
        
        ScrollView {
            
            GeometryReader { proxy in
                
                LazyVStack(alignment: .center, spacing: 0) {
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
                                            .padding()
                                    }
                                }
                                
                            }
                            .foregroundColor(Color.primary)
                            .frame(width: proxy.size.width, height: 50, alignment: .center)
                            
                        }
                        
                        
                    }
                }
                
            }
            
        }
        .gradientTheme1
        
        
    }
}

#endif

