//
//  File.swift
//  
//
//  Created by admin on 2024/9/9.
//

import SwiftUI
import SwiftData

@Model
public class QuickSessionModel: Identifiable {
    @Attribute(.unique) var sessionId: String
    var sourceText: String
    var targetText: String
    var sourceLanguage: String
    var targetLanguage: String
    var createdAt: Date
    var updatedAt: Date
    
    // 初始化函数
    public init(sessionId: String,
                sourceText: String = "",
                targetText: String = "",
                sourceLanguage: String,
                targetLanguage: String,
                createdAt: Date = Date(),
                updatedAt: Date = Date()) {
        self.sessionId = sessionId
        self.sourceText = sourceText
        self.targetText = targetText
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // 提供 public 方法用于访问属性
    public func getSourceText() -> String {
        return sourceText
    }
    
    public func setSourceText(_ newText: String, modelContext: ModelContext) {
        self.sourceText = newText
        self.updatedAt = Date()  // 更新修改时间
        saveTextHistory(modelContext: modelContext)
        try? modelContext.save()  // 保存到数据库
    }
    
    // 提供 public 方法用于访问和修改其他属性
    public func getTargetText() -> String {
        return targetText
    }
    
    public func setTargetText(_ newText: String, modelContext: ModelContext) {
        self.targetText = newText
        self.updatedAt = Date()
        saveTextHistory(modelContext: modelContext)
        try? modelContext.save()
    }
    
    
    
    public func getCreatedAt() -> Date {
        return createdAt
    }
    
    public func getUpdateAt() -> Date {
        return updatedAt
    }
    
    
    
    // 保存当前会话数据，并记录更新时间
    public func saveSession(modelContext: ModelContext) {
        self.updatedAt = Date()  // 更新修改时间
        saveTextHistory(modelContext: modelContext)  // 保存文本修改历史
        try? modelContext.save() // 保存到数据库
    }
    
    // 保存文本修改历史
    private func saveTextHistory(modelContext: ModelContext) {
        let history = TextHistory(
            sessionId: self.sessionId,
            sourceText: self.sourceText,
            targetText: self.targetText,
            timestamp: Date()
        )
        modelContext.insert(history)  // 插入文本历史记录
        try? modelContext.save()      // 保存到数据库
    }
    
    // 物理删除功能
    public func deleteSession(modelContext: ModelContext) {
        modelContext.delete(self)  // 删除当前会话
        try? modelContext.save()   // 保存删除操作
    }
}

@Model
public class TextHistory: Identifiable {
    public var sessionId: String
    public var sourceText: String
    public var targetText: String
    public var timestamp: Date
    
    public init(sessionId: String, sourceText: String, targetText: String, timestamp: Date = Date()) {
        self.sessionId = sessionId
        self.sourceText = sourceText
        self.targetText = targetText
        self.timestamp = timestamp
    }
}
//@Model
//class QuickSessionModel: Identifiable {
//    @Attribute(.unique) var sessionId: String
//    var sourceText: String
//    var targetText: String
//    var createdAt: Date
//    var updatedAt: Date
//
//    init(sessionId: String, sourceText: String = "", targetText: String = "", createdAt: Date = Date(), updatedAt: Date = Date()) {
//        self.sessionId = sessionId
//        self.sourceText = sourceText
//        self.targetText = targetText
//        self.createdAt = createdAt
//        self.updatedAt = updatedAt
//    }
//}
