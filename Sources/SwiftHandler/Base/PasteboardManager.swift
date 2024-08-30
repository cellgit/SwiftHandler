//
//  File.swift
//  
//
//  Created by admin on 2024/8/30.
//

import Foundation
import SwiftUI
#if os(macOS)
import AppKit // macOS
#else
import UIKit  // iOS
#endif

/**
 复制粘贴文字管理
 
 */

public class PasteboardManager {
    
    public static let shared = PasteboardManager()
    
    private init() {}
    
    /// 复制任意支持类型的数据到粘贴板
    public func copy(_ item: Any) {
        if let text = item as? String {
            copyText(text)
        } else if let image = item as? ImageType {
            copyImage(image)
        } else if let url = item as? URL {
            copyURL(url)
        } else {
            debugPrint("Unsupported item type")
        }
    }
    
    /// 粘贴
    public func paste() -> Any? {
        #if os(macOS)
        return pasteFromMacOSPasteboard()
        #else
        return pasteFromiOSPasteboard()
        #endif
    }
    
    
    #if os(macOS)
    private typealias ImageType = NSImage
    #else
    private typealias ImageType = UIImage
    #endif
    
    // MARK: - 复制文本
    private func copyText(_ text: String) {
        #if os(macOS)
        copyToMacOSPasteboard(text)
        #else
        copyToiOSPasteboard(text)
        #endif
    }
    
    #if os(macOS)
    private func copyToMacOSPasteboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        let success = pasteboard.setString(text, forType: .string)
        debugPrint(success ? "Copied to clipboard: \(text)" : "Failed to copy to clipboard")
    }
    #else
    private func copyToiOSPasteboard(_ text: String) {
        UIPasteboard.general.string = text
        debugPrint("Copied to clipboard: \(text)")
    }
    #endif
    
    // MARK: - 复制图片
    private func copyImage(_ image: ImageType) {
        #if os(macOS)
        copyImageToMacOSPasteboard(image)
        #else
        copyImageToiOSPasteboard(image)
        #endif
    }
    
    #if os(macOS)
    private func copyImageToMacOSPasteboard(_ image: NSImage) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([image])
        debugPrint("Copied image to clipboard")
    }
    #else
    private func copyImageToiOSPasteboard(_ image: UIImage) {
        UIPasteboard.general.image = image
        debugPrint("Copied image to clipboard")
    }
    #endif
    
    // MARK: - 复制URL
    private func copyURL(_ url: URL) {
        #if os(macOS)
        copyURLToMacOSPasteboard(url)
        #else
        copyURLToiOSPasteboard(url)
        #endif
    }
    
    #if os(macOS)
    private func copyURLToMacOSPasteboard(_ url: URL) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(url.absoluteString, forType: .string)
        debugPrint("Copied URL to clipboard: \(url)")
    }
    #else
    private func copyURLToiOSPasteboard(_ url: URL) {
        UIPasteboard.general.url = url
        debugPrint("Copied URL to clipboard: \(url)")
    }
    #endif
    
    // MARK: - 粘贴功能（可选实现）
    
    #if os(macOS)
    private func pasteFromMacOSPasteboard() -> Any? {
        let pasteboard = NSPasteboard.general
        if let text = pasteboard.string(forType: .string) {
            return text
        } else if let image = pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage {
            return image
        } else {
            return nil
        }
    }
    #else
    private func pasteFromiOSPasteboard() -> Any? {
        let pasteboard = UIPasteboard.general
        if let text = pasteboard.string {
            return text
        } else if let image = pasteboard.image {
            return image
        } else if let url = pasteboard.url {
            return url
        } else {
            return nil
        }
    }
    #endif
}

