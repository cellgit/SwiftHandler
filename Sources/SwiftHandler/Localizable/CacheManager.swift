//
//  File.swift
//  
//
//  Created by admin on 2024/9/2.
//

import Foundation

class CacheManager {
    
    public static let shared = CacheManager()
    
    private init() {}
    
}

/// 保存
extension CacheManager {
    /// 保存源语言
    func saveSourceLanguage(with languageCode: String) {
        UserDefaultsManager.save(languageCode, forKey: UserDefaultsKey.sourceLanguage.value)
    }
    
    /// 保存目标语言
    func saveTargetLanguage(with languageCode: String) {
        UserDefaultsManager.save(languageCode, forKey: UserDefaultsKey.targetLanguage.value)
    }
    
    /// 保存`隐藏WindowGroup`
    func saveHiddenWindowGroup(with isHidden: Bool) {
        UserDefaultsManager.save(isHidden, forKey: UserDefaultsKey.hiddenWindowGroup.value)
    }
}

/// 获取
extension CacheManager {
    /// 获取源语言
    func getSourceLanguage() -> String {
        UserDefaultsManager.get(forKey: UserDefaultsKey.sourceLanguage.value, ofType: String.self) ?? "en"
    }
    
    /// 获取目标语言
    func getTargetLanguage() -> String {
        UserDefaultsManager.get(forKey: UserDefaultsKey.targetLanguage.value, ofType: String.self) ?? (Locale.preferredLanguages.first ?? "zh-Hans")
    }
    
    /// 获取`隐藏WindowGroup`,默认不隐藏
    func getHiddenWindowGroup() -> Bool {
        UserDefaultsManager.get(forKey: UserDefaultsKey.hiddenWindowGroup.value, ofType: Bool.self) ?? false
    }
}
