//
//  File.swift
//  
//
//  Created by admin on 2024/9/5.
//

import SwiftUI

public struct DynamicScrollView<Content>: View where Content: View {
    
    private let content: Content
    private let alignment: Alignment
    private let axis: Axis.Set
    private let minHeight: CGFloat?
    private let maxHeight: CGFloat?
    
    public init(
        axis: Axis.Set = .vertical,
        alignment: Alignment = .center,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.axis = axis
        self.alignment = alignment
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView(axis) {
                LazyVStack(alignment: alignment.horizontal) {
                    content
                        .frame(maxWidth: geometry.size.width, alignment: alignment)
                        .background(
                            GeometryReader { contentGeometry in
                                Color.clear
                                    .preference(key: ViewHeightKey.self, value: contentGeometry.size.height)
                            }
                        )
                }
                .frame(maxWidth: .infinity)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: calculateHeight(availableHeight: geometry.size.height)
            )
//            .onPreferenceChange(ViewHeightKey.self) { contentHeight in
//                let newHeight = adjustScrollViewHeight(contentHeight: contentHeight, availableHeight: geometry.size.height)
//                debugPrint("newHeight ===== \(newHeight)")
//            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // 计算 ScrollView 的高度，确保不超出屏幕可用高度
    private func calculateHeight(availableHeight: CGFloat) -> CGFloat {
        var finalHeight = availableHeight
        
        // 应用 maxHeight 和 minHeight 的限制
        if let maxHeight = maxHeight {
            finalHeight = min(finalHeight, maxHeight)
        }
        
        if let minHeight = minHeight {
            finalHeight = max(finalHeight, minHeight)
        }
        
        return finalHeight
    }
    
    // 自适应高度逻辑
    private func adjustScrollViewHeight(contentHeight: CGFloat, availableHeight: CGFloat) -> CGFloat {
        let adjustedHeight = min(contentHeight, availableHeight)
        
        if let minHeight = minHeight {
            return max(adjustedHeight, minHeight)
        }
        
        if let maxHeight = maxHeight {
            return min(adjustedHeight, maxHeight)
        }
        
        return adjustedHeight
    }
}

#Preview {
    
    VStack(content: {
        Text("Hello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby, Hello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, babyHello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, babyHello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, babyHello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, babyHello, baby Hello, baby  Hello")
            .padding()
        
        DynamicScrollView {
            Text("Hello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby, Hello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, babyHello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, babyHello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, babyHello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, babyHello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, babyHello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, babyHello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, babyHello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, babyHello, baby Hello, baby  Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby Hello, baby")
        }
        
    })
    
    
}



//public struct DynamicScrollView<Content>: View where Content: View {
//
//    private let content: Content
//
//    private let alignment: Alignment
//
//    public init(alignment: Alignment = .center, @ViewBuilder content: () -> Content) {
//        self.alignment = alignment
//        self.content = content()
//    }
//
//    public var body: some View {
//        GeometryReader { geometry in
//            ScrollView {
//                LazyVStack {
//                    content
//                        .frame(maxWidth: geometry.size.width, alignment: alignment)
//                }
//                .frame(maxWidth: .infinity)
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//}

