//
//  File.swift
//  
//
//  Created by admin on 2024/8/28.
//

import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public class SettingsHandler {
    
    public static let shared = SettingsHandler()
    
    public func openSettings() {
        #if os(iOS)
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings)
        }
        #elseif os(macOS)
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_SpeechRecognition") {
            NSWorkspace.shared.open(url)
        }
        #endif
    }
}

