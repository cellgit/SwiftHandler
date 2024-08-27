//
//  String+extension.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/26.
//

import Foundation

public extension String {
    
    /// 检查字符串是否是有效的电子邮件地址
    var isValidEmail: Bool {
//        let regex = "^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+"
        let regex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        let regextestemail = NSPredicate(format: "SELF MATCHES %@",regex)
        return regextestemail.evaluate(with: self) == true ? true : false
    }
    
    /// 反转字符串
    func reversedString() -> String {
        return String(self.reversed())
    }
}

/// 文本提取的后期处理(去除多余空格,换行符和自动分段,目前看Vision识别没有必要)
extension String {
    
    /// 去除首尾空格和多余换行符，仅在不影响内容的情况下操作
    func minimalCleanUp() -> String {
        // 去除首尾空白字符
        var cleanedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 去除连续的空行，但保留单个换行符
        cleanedText = cleanedText.replacingOccurrences(of: "\n\n+", with: "\n\n", options: .regularExpression)
        
        // 去除连续的空格，但保留句子中的空格
        cleanedText = cleanedText.replacingOccurrences(of: " {2,}", with: " ", options: .regularExpression)
        
        return cleanedText
    }
    
    /// 智能段落分割，不强制改变段落结构
    func smartSegmentedText() -> String {
        // 通过段落标记符（如换行符）进行分段
        let paragraphs = self.components(separatedBy: "\n\n")
        
        // 保留每段原始文本结构
        let segmentedText = paragraphs.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.joined(separator: "\n\n")
        
        return segmentedText
    }
    
    /// 综合后期处理方法
    func improvedPostProcessText() -> String {
        return self.minimalCleanUp().smartSegmentedText()
    }
}
