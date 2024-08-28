//
//  File.swift
//  
//
//  Created by admin on 2024/8/28.
//

import SwiftUI

public struct AlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let primaryButtonTitle: String
    let primaryButtonAction: () -> Void
    let secondaryButtonTitle: String
    let secondaryButtonAction: () -> Void
    
    public func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                Alert(
                    title: Text(title),
                    message: Text(message),
                    primaryButton: .default(Text(primaryButtonTitle), action: primaryButtonAction),
                    secondaryButton: .cancel(Text(secondaryButtonTitle), action: secondaryButtonAction)
                )
            }
    }
}

public extension View {
    /// 语音识别被拒绝后去设置权限的提示框
    /// - Parameters:
    ///   - isPresented: is show alert
    /// - Returns: View
    func alertForSpeechRecognizer(isPresented: Binding<Bool>) -> some View {
        self.modifier(AlertModifier(
            isPresented: isPresented,
            title: "Speech Recognition Denied",
            message: "You have denied access to speech recognition. Please go to Settings and enable the permission.",
            primaryButtonTitle: "Settings",
            primaryButtonAction: {SettingsHandler.shared.openSettings()},
            secondaryButtonTitle: "Cancel",
            secondaryButtonAction: {}
        ))
    }
    
    /// 语音识别被拒绝后去设置权限的提示框
    /// - Parameters:
    ///   - isPresented: is show alert
    ///   - title: title
    ///   - message: alert message
    ///   - primaryButtonTitle: to settings title
    ///   - primaryButtonAction: to settings action
    ///   - secondaryButtonTitle: cancel title
    ///   - secondaryButtonAction: cancel action
    /// - Returns: View
    func alertForSpeechRecognizer(
        isPresented: Binding<Bool>,
        title: String = "Speech Recognition Denied",
        message: String = "You have denied access to speech recognition. Please go to Settings and enable the permission.",
        primaryButtonTitle: String = "Settings",
        primaryButtonAction: @escaping () -> Void = {},
        secondaryButtonTitle: String = "Cancel",
        secondaryButtonAction: @escaping () -> Void = {}
    ) -> some View {
        self.modifier(AlertModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            primaryButtonTitle: primaryButtonTitle,
            primaryButtonAction: primaryButtonAction,
            secondaryButtonTitle: secondaryButtonTitle,
            secondaryButtonAction: secondaryButtonAction
        ))
    }
    
    
    
}

