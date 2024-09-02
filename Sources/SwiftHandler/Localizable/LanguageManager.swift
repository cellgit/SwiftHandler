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
    
    public var identifier: String {
        switch self {
        case .en_US:
            return "en"
//            return "en-US"
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
        }
    }
    
    public var localeLanguage: Locale.Language {
        Locale.Language(identifier: self.identifier)
    }
    
    public static func from(localeLanguage: Locale.Language) -> LanguageManager? {
        return self.allCases.first { $0.localeLanguage == localeLanguage }
    }
    
    private static func selectedSourceLanguage() -> LanguageManager? {
        let preferredLanguageIdentifier = CacheManager.shared.getSourceLanguage()
        let preferredLocaleLanguage = Locale.Language(identifier: preferredLanguageIdentifier)
        return self.from(localeLanguage: preferredLocaleLanguage)
    }
    
    private static func selectedTargetLanguage() -> LanguageManager? {
        let preferredLanguageIdentifier = CacheManager.shared.getTargetLanguage()
        let preferredLocaleLanguage = Locale.Language(identifier: preferredLanguageIdentifier)
        return self.from(localeLanguage: preferredLocaleLanguage)
    }
    
    public static func fromSource() -> LanguageManager {
        selectedSourceLanguage() ?? .en_US
    }
    
    public static func fromTarget() -> LanguageManager {
        selectedTargetLanguage() ?? .zh_Hans
    }
    
    public static func languages() -> [LanguageManager] {
        return self.allCases
    }
    
    
    
    
}

