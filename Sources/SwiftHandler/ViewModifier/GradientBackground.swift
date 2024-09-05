//
//  File.swift
//  
//
//  Created by admin on 2024/9/3.
//

import SwiftUI

struct GradientBackground: ViewModifier {
    var radialColors: [Color]
    var linearColors: [Color]
    var radialCenter: UnitPoint
    var radialStartRadius: CGFloat
    var radialEndRadius: CGFloat
    var linearStartPoint: UnitPoint
    var linearEndPoint: UnitPoint
    var linearOpacity: Double
    
    // 径向渐变1 默认色
    static let gradient1_0: Color = Color(red: 169/255, green: 122/255, blue: 224/255, opacity: 0.15)
    static let gradient1_1: Color = Color(red: 163/255, green: 87/255, blue: 215/255, opacity: 0.05)
    // 线性渐变2 默认色（现在改写为 Color(red:green:blue:opacity:) 形式）
    static let gradient2_0: Color = Color(red: 243/255, green: 213/255, blue: 220/255, opacity: 1.0)  // #F3D5DC
    static let gradient2_1: Color = Color(red: 208/255, green: 239/255, blue: 248/255, opacity: 1.0)  // #D0EFF8
    
    init(
        radialColors: [Color] = [gradient1_0, gradient1_1],
        linearColors: [Color] = [gradient2_0, gradient2_1],
        radialCenter: UnitPoint = .trailing,
        radialStartRadius: CGFloat = 5,
        radialEndRadius: CGFloat = 1000,
        linearStartPoint: UnitPoint = .top,
        linearEndPoint: UnitPoint = .bottom,
        linearOpacity: Double = 0.5
    ) {
        self.radialColors = radialColors
        self.linearColors = linearColors
        self.radialCenter = radialCenter
        self.radialStartRadius = radialStartRadius
        self.radialEndRadius = radialEndRadius
        self.linearStartPoint = linearStartPoint
        self.linearEndPoint = linearEndPoint
        self.linearOpacity = linearOpacity
    }
    
    func body(content: Content) -> some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: radialColors),
                center: radialCenter,
                startRadius: radialStartRadius,
                endRadius: radialEndRadius
            )
            .ignoresSafeArea()  // 仅对最底层背景视图忽略安全区域
            
            LinearGradient(
                gradient: Gradient(colors: linearColors),
                startPoint: linearStartPoint,
                endPoint: linearEndPoint
            )
            .opacity(linearOpacity)
            .ignoresSafeArea()
            
            content
        }
    }
}

