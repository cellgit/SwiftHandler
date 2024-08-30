//
//  File.swift
//  
//
//  Created by admin on 2024/8/30.
//

/**
 反馈与支持
 */

import Foundation
import StoreKit

public class FeedbackManager {
    
    public static let shared = FeedbackManager()
    
    private init() {}
    
    /// 反馈
    public func requestReview() {
        SKStoreReviewController.requestReview()
    }
    
}
