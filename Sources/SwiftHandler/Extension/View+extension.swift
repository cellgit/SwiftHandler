//
//  File.swift
//  
//
//  Created by admin on 2024/9/3.
//

import SwiftUI

public extension View {
    
    /// 渐变背景
    /// - Returns: 渐变View
    var gradientTheme1: some View {
        self.modifier(GradientBackground())
    }
    
    
}
