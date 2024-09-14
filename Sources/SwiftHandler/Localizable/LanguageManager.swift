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
    
    
    /// 英式英语
    case en_GB
    /// 阿拉伯语
    case ar
    /// 波兰语
    case pl
    /// 荷兰语
    case nl
    /// 葡萄牙语(巴西)
    case pt_BR
    /// 泰语
    case th
    /// 土耳其语
    case tr
    /// 乌克兰语
    case uk
    /// 西班牙语(西班牙)
    case es
    
    /// 意大利语
    case it
    /// 印地语
    case hi
    /// 印度尼西亚语
    case id
    /// 越南语
    case vi
    
    
    
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
        case .en_GB:
            return "en_GB"
        case .ar:
            return "ar"
        case .pl:
            return "pl"
        case .nl:
            return "nl"
        case .pt_BR:
            return "pt_BR"
        case .th:
            return "th"
        case .tr:
            return "tr"
        case .uk:
            return "uk"
        case .es:
            return "es"
        case .it:
            return "it"
        case .hi:
            return "hi"
        case .id:
            return "id"
        case .vi:
            return "vi"
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
        case .en_GB:
            return LocalStrings.language_english_gb.text
        case .ar:
            return LocalStrings.language_ar.text
        case .pl:
            return LocalStrings.language_pl.text
        case .nl:
            return LocalStrings.language_nl.text
        case .pt_BR:
            return LocalStrings.language_pt_br.text
        case .th:
            return LocalStrings.language_th.text
        case .tr:
            return LocalStrings.language_tr.text
        case .uk:
            return LocalStrings.language_uk.text
        case .es:
            return LocalStrings.language_es.text
        case .it:
            return LocalStrings.language_it.text
        case .hi:
            return LocalStrings.language_hi.text
        case .id:
            return LocalStrings.language_id.text
        case .vi:
            return LocalStrings.language_vi.text
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
    
    /// 根据 `identifier` 获取本地化语言名字
    public static func findName(with identifier: String ) -> String {
        return LanguageManager.languages().first { $0.identifier == identifier }?.name ?? ""
    }
    
    /// 根据 `identifier` 获取本地化语言
    public static func findLanguage(with identifier: String ) -> LanguageManager {
        return LanguageManager.languages().first { $0.identifier == identifier } ?? .en_US
    }
    
}

