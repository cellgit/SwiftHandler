//
//  LanguageManager.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/27.
//

import Foundation

public enum LanguageManager: Int, CaseIterable {
    
    /// 美式英语
    case en_US
    /// 简体中文
    case zh_Hans
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
    /// 繁体中文
    case zh_Hant
    /// 繁体中文 (香港)
    case zh_HK
    /// 英语(UK)
    case en_GB
    /// 英语(India)
    case en_IN
    /// 英语(Australia)
    case en_AU
    
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
        case .zh_Hant:
            return "zh-Hant"
        case .zh_HK:
            return "zh-HK"
        case .en_GB:
            return "en-GB"
        case .en_IN:
            return "en-IN"
        case .en_AU:
            return "en-AU"
            
            
        }
        
    }
    
    public var name: String {
        switch self {
        case .en_US:
            return LocalizableMapper().language_english
        case .zh_Hans:
            return LocalizableMapper().language_chinese_hans
        case .ja:
            return LocalizableMapper().language_ja
        case .ko:
            return LocalizableMapper().language_ko
        case .fr:
            return LocalizableMapper().language_fr
        case .de:
            return LocalizableMapper().language_de
        case .ru:
            return LocalizableMapper().language_ru
        case .zh_Hant:
            return LocalizableMapper().language_chinese_hant
        case .zh_HK:
            return LocalizableMapper().language_chinese_hant_hk
        case .en_GB:
            return LocalizableMapper().language_english_gb
        case .en_IN:
            return LocalizableMapper().language_english_in
        case .en_AU:
            return LocalizableMapper().language_english_au
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

