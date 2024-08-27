//
//  LanguageManager.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/27.
//

import Foundation

public enum LanguageManager: String, CaseIterable {
    
    /// 美式英语
    case en_US
    /// 简体中文
    case zh_Hans
    /// 繁体中文
    case zh_Hant
    /// 日语
    case ja
    /// 韩语
    case ko
    /// 法语
    case fr
    /// 德语
    case de
    /// 俄语
    case ru
    
//    繁体中文:zh-Hant
//    繁体中文(香港):zh-HK
//    英语(UK):en-GB
//    英语(India):en-IN
//    英语(Australia):en-AU
//    日本语:ja
//    韩语:ko
//    法语:fr
//    德语:de
//    俄语:ru
    
    
    
    public var identifier: String {
        switch self {
        case .en_US:
            return "en-US"
        case .zh_Hans:
            return "zh-Hans"
        case .zh_Hant:
            return "zh-Hant"
        case .ja:
            return "ja"
        case .ko:
            return "ko"
        case .fr:
            return "fr"
        case .de:
            return "de"
        case .ru:
            return "ru"
        }
        
    }
    
    public var name: String {
        switch self {
        case .en_US:
            return LocalStrings.language_english.rawValue.localized
        case .zh_Hans:
            return LocalStrings.language_chinese_hans.rawValue.localized
        case .zh_Hant:
            return LocalStrings.language_chinese_hant.rawValue.localized
        case .ja:
            return LocalStrings.language_ja.rawValue.localized
        case .ko:
            return LocalStrings.language_ko.rawValue.localized
        case .fr:
            return LocalizableMapper().language_fr
        case .de:
            return LocalStrings.language_de.rawValue.localized
        case .ru:
            return LocalStrings.language_ru.rawValue.localized
        }
    }
    
    public var localeLanguage: Locale.Language {
        Locale.Language(identifier: self.identifier)
    }
    
    public static func from(localeLanguage: Locale.Language) -> LanguageManager? {
        return self.allCases.first { $0.localeLanguage == localeLanguage }
    }
    
    public static func fromLocale() -> LanguageManager? {
        let preferredLanguageIdentifier = Locale.preferredLanguages.first ?? "en-US"//"zh-Hans"
        let preferredLocaleLanguage = Locale.Language(identifier: preferredLanguageIdentifier)
        return self.from(localeLanguage: preferredLocaleLanguage)
    }
    
    public static func fromTarget() -> LanguageManager? {
        fromLocale()
    }
    
    public static func fromSource() -> LanguageManager? {
        let identifier = fromLocale()?.identifier ?? "en-US"//"zh-Hans"
        return identifier.contains("en") ? LanguageManager.en_US : LanguageManager.zh_Hans
    }
    
    public static func languages() -> [LanguageManager] {
        return self.allCases
    }
    
    
    
    
}

