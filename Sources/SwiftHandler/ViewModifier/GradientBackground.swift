//
//  File.swift
//  
//
//  Created by admin on 2024/9/3.
//

import SwiftUI

/// 一个为视图添加渐变背景的修饰符。
///
/// - 使用自定义的渐变颜色、位置和透明度创建一个背景修饰符。
///
/// - Parameters:
///   - radialColors: 径向渐变的颜色数组。默认为 `gradient1_0` 和 `gradient1_1`。
///   - linearColors: 线性渐变的颜色数组。默认为 `gradient2_0` 和 `gradient2_1`。
///   - radialCenter: 径向渐变的中心点。默认为 `.trailing`。
///   - radialStartRadius: 径向渐变的起始半径。默认为 5。
///   - radialEndRadius: 径向渐变的终止半径。默认为 1000。
///   - linearStartPoint: 线性渐变的起始点。默认为 `.top`。
///   - linearEndPoint: 线性渐变的终止点。默认为 `.bottom`。
///   - linearOpacity: 线性渐变的透明度。默认为 0.5。
///
/// - 使用示例:
///
/// 不传递任何参数，使用默认的渐变背景:
/// ```swift
/// Text("Hello, World!")
///     .gradientBackground()
/// ```
///
/// 自定义渐变背景:
/// ```swift
/// Text("Custom Gradient")
///     .gradientBackground(
///         radialColors: [Color.red, Color.orange],
///         linearColors: [Color.blue, Color.green],
///         radialCenter: .center,
///         radialStartRadius: 10,
///         radialEndRadius: 500,
///         linearStartPoint: .leading,
///         linearEndPoint: .trailing,
///         linearOpacity: 0.7
///     )
/// ```
public struct GradientBackground: ViewModifier {
    public var radialColors: [Color]
    public var linearColors: [Color]
    public var radialCenter: UnitPoint
    public var radialStartRadius: CGFloat
    public var radialEndRadius: CGFloat
    public var linearStartPoint: UnitPoint
    public var linearEndPoint: UnitPoint
    public var linearOpacity: Double
    
    // 默认渐变颜色
    public static let gradient1_0: Color = Color(red: 169/255, green: 122/255, blue: 224/255, opacity: 0.15)
    public static let gradient1_1: Color = Color(red: 163/255, green: 87/255, blue: 215/255, opacity: 0.05)
    public static let gradient2_0: Color = Color(red: 243/255, green: 213/255, blue: 220/255, opacity: 1.0)
    public static let gradient2_1: Color = Color(red: 208/255, green: 239/255, blue: 248/255, opacity: 1.0)
    
    public init(
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
    
    public func body(content: Content) -> some View {
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

public extension View {
    /// 为视图添加渐变背景修饰符。
    ///
    /// - 使用默认渐变或自定义渐变背景。
    ///
    /// - Parameters:
    ///   - radialColors: 径向渐变的颜色数组，默认使用预设颜色。
    ///   - linearColors: 线性渐变的颜色数组，默认使用预设颜色。
    ///   - radialCenter: 径向渐变的中心点，默认为 `.trailing`。
    ///   - radialStartRadius: 径向渐变的起始半径，默认为 5。
    ///   - radialEndRadius: 径向渐变的终止半径，默认为 1000。
    ///   - linearStartPoint: 线性渐变的起始点，默认为 `.top`。
    ///   - linearEndPoint: 线性渐变的终止点，默认为 `.bottom`。
    ///   - linearOpacity: 线性渐变的透明度，默认为 0.5。
    ///
    /// - Returns: 应用了渐变背景的视图。
    ///
    /// - 使用示例:
    ///
    /// 使用默认背景:
    /// ```swift
    /// Text("Hello, World!")
    ///     .gradientBackground()
    /// ```
    ///
    /// 使用自定义背景:
    /// ```swift
    /// Text("Custom Gradient")
    ///     .gradientBackground(
    ///         radialColors: [Color.red, Color.orange],
    ///         linearColors: [Color.blue, Color.green],
    ///         radialCenter: .center,
    ///         radialStartRadius: 10,
    ///         radialEndRadius: 500,
    ///         linearStartPoint: .leading,
    ///         linearEndPoint: .trailing,
    ///         linearOpacity: 0.7
    ///     )
    /// ```
    func gradientBackground(
        radialColors: [Color] = GradientBackground.gradient1_0,
        linearColors: [Color] = GradientBackground.gradient2_0,
        radialCenter: UnitPoint = .trailing,
        radialStartRadius: CGFloat = 5,
        radialEndRadius: CGFloat = 1000,
        linearStartPoint: UnitPoint = .top,
        linearEndPoint: UnitPoint = .bottom,
        linearOpacity: Double = 0.5
    ) -> some View {
        self.modifier(
            GradientBackground(
                radialColors: radialColors,
                linearColors: linearColors,
                radialCenter: radialCenter,
                radialStartRadius: radialStartRadius,
                radialEndRadius: radialEndRadius,
                linearStartPoint: linearStartPoint,
                linearEndPoint: linearEndPoint,
                linearOpacity: linearOpacity
            )
        )
    }
}
