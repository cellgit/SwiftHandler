//
//  File.swift
//  SwiftHandler
//
//  Created by admin on 2024/9/14.
//

import SwiftUI

public extension View {
    
    /// 根据条件决定是否应用修饰符。
    ///
    /// 此方法用于根据给定的布尔条件，在视图上应用特定的修饰符。如果条件为 `true`，则应用 `content` 闭包返回的修饰符；否则，返回原始视图。
    ///
    /// - Parameters:
    ///   - condition: 布尔值，用于判断是否应用修饰符。
    ///   - content: 一个闭包，返回要应用的修饰符。
    ///
    /// - Returns: 依据条件决定是否应用修饰符的视图。
    ///
    /// # 示例
    /// ```
    /// Text("Hello, World!")
    ///     .if(showGradient) { view in
    ///         view.gradientBackground()
    ///     }
    /// ```
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
}
