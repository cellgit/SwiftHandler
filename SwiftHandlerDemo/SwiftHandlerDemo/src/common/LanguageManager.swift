//
//  LanguageManager.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/26.
//

import Foundation

enum LanguageManager: Int, CaseIterable {
    
    /// 美式英语
    case en_US
    /// 简体中文
    case zh_Hans
    /// 日语
    case ja
    /// 韩语
    case ko
    
    var identifier: String {
        switch self {
        case .en_US:
            return "en-US"
        case .zh_Hans:
            return "zh-Hans"
        case .ja:
            return "ja"
        case .ko:
            return "ko"
        }
        
    }
    
    var name: String {
        switch self {
        case .en_US:
            return "English(US)"
        case .zh_Hans:
            return "简体中文"
        case .ja:
            return "日语"
        case .ko:
            return "韩语"
        }
    }
    
    var localeLanguage: Locale.Language {
        Locale.Language(identifier: self.identifier)
    }
    
    static func from(localeLanguage: Locale.Language) -> LanguageManager? {
        return self.allCases.first { $0.localeLanguage == localeLanguage }
    }
    
    static func fromLocale() -> LanguageManager? {
        let preferredLanguageIdentifier = Locale.preferredLanguages.first ?? "zh-Hans"
        let preferredLocaleLanguage = Locale.Language(identifier: preferredLanguageIdentifier)
        return self.from(localeLanguage: preferredLocaleLanguage)
    }
    
    static func fromTarget() -> LanguageManager? {
        fromLocale()
    }
    
    static func fromSource() -> LanguageManager? {
        let identifier = fromLocale()?.identifier ?? "zh-Hans"
        return identifier.contains("en") ? LanguageManager.en_US : LanguageManager.zh_Hans
    }
    
    static func languages() -> [LanguageManager] {
        return self.allCases
    }
    
    
    
    
}
