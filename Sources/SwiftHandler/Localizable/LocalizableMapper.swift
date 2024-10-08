//
//  LocalizableMapper.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/27.
//

import Foundation


public struct LocalizableMapper {
    
    public init() {
        
    }
    
    public let language_english = NSLocalizedString("language_english", bundle: .module, comment: "English-语种")
    public let language_english_gb = NSLocalizedString("language_english_gb", bundle: .module, comment: "English(UK)-语种")
    public let language_english_in = NSLocalizedString("language_english_in", bundle: .module, comment: "English(India)-语种")
    public let language_english_au = NSLocalizedString("language_english_au", bundle: .module, comment: "English(Australia)-语种")
    
    public let language_chinese_hans = NSLocalizedString("language_chinese_hans", bundle: .module, comment: "简体中文-语种")
    public let language_chinese_hant = NSLocalizedString("language_chinese_hant", bundle: .module, comment: "繁體中文-语种")
    public let language_chinese_hant_hk = NSLocalizedString("language_chinese_hant_hk", bundle: .module, comment: "繁體中文(HK)-语种")
    
    public let language_ja = NSLocalizedString("language_ja", bundle: .module, comment: "Japanese-语种")
    public let language_ko = NSLocalizedString("language_ko", bundle: .module, comment: "Korean-语种")
    public let language_fr = NSLocalizedString("language_fr", bundle: .module, comment: "French-语种")
    public let language_de = NSLocalizedString("language_de", bundle: .module, comment: "German-语种")
    public let language_ru = NSLocalizedString("language_ru", bundle: .module, comment: "Russian-语种")
    
    public let quick_mode = NSLocalizedString("quick_mode", bundle: .module, comment: "快捷模式-内容")
    public let document_translation = NSLocalizedString("document_translation", bundle: .module, comment: "文件翻译-内容")
    public let screenshoot_translation = NSLocalizedString("screenshoot_translation", bundle: .module, comment: "截屏翻译-内容")
    public let screenshoot_translation_action = NSLocalizedString("screenshoot_translation_action", bundle: .module, comment: "截屏翻译事件-内容")
    

}

