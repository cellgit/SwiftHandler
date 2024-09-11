//
//  File.swift
//  SwiftHandler
//
//  Created by admin on 2024/9/11.
//

/** 修复侧滑返回示例(目标视图)
 
 VStack {
     
 }
 .navigationBarHidden(true)
 
 */


#if os(iOS)

import SwiftUI

/// 修复侧滑手势
public extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

#endif
