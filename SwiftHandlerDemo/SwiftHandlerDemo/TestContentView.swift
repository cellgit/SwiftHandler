//
//  TestContentView.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/26.
//

import SwiftUI

struct TestContentView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                // 测试 SwiftHandler 中的辅助函数
                let email = "liuppppp@gamil.com"
                print("Is valid email: \(email.isValidEmail)")
                let reversed = "hello".reversedString()
                print("Reversed string: \(reversed)")
            }
    }
}

#Preview {
    TestContentView()
}
