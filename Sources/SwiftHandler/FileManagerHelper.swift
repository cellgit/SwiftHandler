//
//  FileManagerHelper.swift
//  Demo
//
//  Created by admin on 2024/8/26.
//

import Foundation

public struct FileManagerHelper {
    
    /// 读取指定路径的文件内容
    public static func readFile(atPath path: String) -> String? {
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            return content
        } catch {
            print("Failed to read file at path \(path): \(error)")
            return nil
        }
    }
    
    /// 将内容写入指定路径的文件
    public static func writeFile(content: String, toPath path: String) -> Bool {
        do {
            try content.write(toFile: path, atomically: true, encoding: .utf8)
            return true
        } catch {
            print("Failed to write file at path \(path): \(error)")
            return false
        }
    }
    
    /// 检查文件是否存在
    public static func fileExists(atPath path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}

