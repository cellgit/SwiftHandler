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
    
    public var identifier: String {
        switch self {
        case .en_US:
            return "en"
//            return "en-US"
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
        }
        
    }
    
    public var name: String {
        switch self {
        case .en_US:
            return LocalStrings.language_english.text
        case .zh_Hans:
            return LocalStrings.language_chinese_hans.text
        case .ja:
            return LocalStrings.language_ja.text
        case .ko:
            return LocalStrings.language_ko.text
        case .fr:
            return LocalStrings.language_fr.text
        case .de:
            return LocalStrings.language_de.text
        case .ru:
            return LocalStrings.language_ru.text
        case .zh_Hant:
            return LocalStrings.language_chinese_hant.text
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

