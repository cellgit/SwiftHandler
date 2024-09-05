//
//  File.swift
//  
//
//  Created by admin on 2024/9/5.
//

import SwiftUI

// 用于通过 PreferenceKey 传递高度信息
public struct ViewHeightKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue: CGFloat = 0
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
