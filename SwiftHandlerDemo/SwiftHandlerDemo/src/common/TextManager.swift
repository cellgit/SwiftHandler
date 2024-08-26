//
//  TextManager.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/26.
//

import Foundation
import SwiftUI


/**
 文字管理
 
 */

class TextManager {
    
    static let shared = TextManager()
    
    /// 复制文本到粘贴板
    func copy(_ text: String) {
#if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        debugPrint("Copied to clipboard: \(text)")
#else
        UIPasteboard.general.string = text
        debugPrint("Copied to clipboard: \(text)")
#endif
    }
    
}
