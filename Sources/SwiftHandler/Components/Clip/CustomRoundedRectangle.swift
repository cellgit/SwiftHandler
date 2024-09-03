//
//  File.swift
//  
//
//  Created by admin on 2024/9/3.
//

/**
 Usage:
 
 ///struct ContentView: View {
 ///    var body: some View {
 ///        Text("Hello, SwiftUI!")
 ///            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
 ///            .foregroundColor(.primary)
 ///            .background(Color(.quaternarySystemFill))
 ///            .clipShape(CustomRoundedRectangle(topLeft: 24, topRight: 16, bottomLeft: 8, bottomRight: 4))
 ///            .padding()
 ///    }
 ///}
 
 */



import SwiftUI

public struct CustomRoundedRectangle: Shape {
    private var topLeft: CGFloat
    private var topRight: CGFloat
    private var bottomLeft: CGFloat
    private var bottomRight: CGFloat
    
    public init(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Top left corner
        path.move(to: CGPoint(x: rect.minX + topLeft, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - topRight, y: rect.minY + topRight), radius: topRight, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        
        // Top right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        path.addArc(center: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight), radius: bottomRight, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        
        // Bottom right corner
        path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY - bottomLeft), radius: bottomLeft, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        
        // Bottom left corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        path.addArc(center: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft), radius: topLeft, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        
        path.closeSubpath()
        
        return path
    }
}


#Preview {
    CustomRoundedRectangle(topLeft: 24, topRight: 16, bottomLeft: 8, bottomRight: 4)
}

