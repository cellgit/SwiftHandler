//
//  File.swift
//  
//
//  Created by admin on 2024/8/29.
//

import Foundation

public extension Encodable {
    public subscript(key: String) -> Any? {
        return toDictionary[key]
    }
    public var toJsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    public var toDictionary: [String: Any] {
        guard let data = toJsonData else {return [:]}
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] ?? [:]
    }
    public var toJsonString: String? {
        guard let data = toJsonData else {return nil}
        return String(data: data, encoding: .utf8)
    }
}

public extension Decodable {
    public static func getModel(data: Data) -> Self? {
        return try? JSONDecoder().decode(self, from: data)
    }
    public static func getModel(jsonString: String) -> Self? {
        guard let data = jsonString.data(using: .utf8) else {return nil}
        return try? JSONDecoder().decode(self, from: data)
    }
}
