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
