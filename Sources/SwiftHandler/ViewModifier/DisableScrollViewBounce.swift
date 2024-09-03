//
//  File.swift
//  
//
//  Created by admin on 2024/9/3.
//

#if os(iOS)
import SwiftUI

public struct DisableScrollViewBounce: ViewModifier {
    
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                //                UIScrollView.appearance().bounces = false
                if #available(iOS 17.4, *) {
                    UIScrollView.appearance().bouncesHorizontally = false
                } else {
                    // Fallback on earlier versions
                }
            }
            .onDisappear {
                //                UIScrollView.appearance().bounces = true
                if #available(iOS 17.4, *) {
                    UIScrollView.appearance().bouncesHorizontally = false
                } else {
                    // Fallback on earlier versions
                }
            }
    }
}

extension View {
    public func disableScrollViewBounce() -> some View {
        self.modifier(DisableScrollViewBounce())
    }
}

#endif

