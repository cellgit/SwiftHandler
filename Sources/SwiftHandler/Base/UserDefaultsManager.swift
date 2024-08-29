//
//  File.swift
//  
//
//  Created by admin on 2024/8/29.
//

import Foundation

public struct UserDefaultsManager {
    // 存入数据: 数据需遵守Codable协议
    // 示例:
    // let model = UserModel(json) // UserModel需遵守Codable协议
    // UserDefaultsManager.save(model, forKey: UserDefaultsKey.user.key)
    public static func save<T: Codable>(_ data: T, forKey key: String) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encodedData, forKey: key)
        } catch {
            print("Save error: \(error)")
        }
    }
    
    // 获取数据
    // 示例:
    // let user: UserModel? = UserDefaultsManager.get(forKey: UserDefaultsKey.user.key)
    public static func get<T: Codable>(forKey key: String, ofType type: T.Type) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Get error: \(error)")
            return nil
        }
    }
    
    // 删除数据
    // 示例: UserDefaultsManager.delete(forKey: UserDefaultsKey.user.key)
    public static func delete(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
}


///// 对于字典需要先转为json
//class JSONSerializationManager {
//    static func saveList(_ value: [[String: Any]], forKey key: UserDefaultsKey) {
//        let defaults = UserDefaults.standard
//        if let data = try? JSONSerialization.data(withJSONObject: value, options: []) {
//            defaults.set(data, forKey: key.value)
//        }
//    }
//    
//    static func getList(forKey key: UserDefaultsKey) -> [[String: Any]]? {
//        let defaults = UserDefaults.standard
//        if let data = defaults.data(forKey: key.value),
//           let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
//            return array
//        }
//        return nil
//    }
//}
