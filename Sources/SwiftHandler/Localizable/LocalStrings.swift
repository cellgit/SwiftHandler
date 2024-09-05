//
//  LocalStrings.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/27.
//

import Foundation

public enum LocalStrings: String {
    
    case language_english
    case language_english_gb
    case language_chinese_hans
    case language_chinese_hant
    case language_ja
    case language_ko
    case language_fr
    case language_de
    case language_ru
    case language_ar
    case language_pl
    case language_nl
    case language_pt_br
    case language_th
    case language_tr
    case language_uk
    case language_es
    case language_it
    case language_hi
    case language_id
    case language_vi
    
    case quick_mode
    case document_translation
    case screenshoot_translation
    case screenshoot_translation_action
    case clear
    case paste
    case copied
    case placeholder_enter_text

    /// 本地化显示的text
    public var text: String {
        self.rawValue.localized
    }
}

//public enum LocalStrings: String {
//    
//    case language_english
//    case language_chinese_hans
//    case language_chinese_hant
//    case language_ja
//    case language_ko
//    case language_fr
//    case language_de
//    case language_ru
//    
//    case quick_mode
//    case document_translation
//    case screenshoot_translation
//    case screenshoot_translation_action
//    
//    /// 本地化显示的text
//    public var text: String {
//        self.rawValue.localized
//    }
//    
//}


extension String {
    var localized: String {
        debugPrint("localized ==== \(self)")
        return NSLocalizedString(self, bundle: .module, comment: self)
    }
}
