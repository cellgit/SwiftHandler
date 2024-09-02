//
//  File.swift
//  
//
//  Created by admin on 2024/9/2.
//

import Foundation

enum UserDefaultsKey {
    /// 源语言(输入)
    case sourceLanguage
    /// 目标语言(输出)
    case targetLanguage
    /// 隐藏 WindowGroup (不在Dock显示 App)
    case hiddenWindowGroup
    
    var value: String {
        switch self {
        case .sourceLanguage:
            return "\(appId)_sourceLanguage"
        case .targetLanguage:
            return "\(appId)_targetLanguage"
        case .hiddenWindowGroup:
            return "\(appId)_hiddenWindowGroup"
        }
    }
    
    var appId: String {
        "bear_translate"
    }
    
}
