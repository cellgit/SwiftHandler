//
//  File.swift
//  
//
//  Created by admin on 2024/9/4.
//

#if os(iOS)

import SwiftUI

public struct TextView: View {
    
    @Binding var text: String
    
    @Binding var textHeight: CGFloat
    
    public init(text: Binding<String>, textHeight: Binding<CGFloat>) {
        self._text = text
        self._textHeight = textHeight
    }
    
    public var body: some View {
        
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Text(text)
                    .frame(minHeight: 20, maxHeight: .infinity, alignment: .topLeading)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(2)
                    .fontDesign(.monospaced)
                    .padding(12)
                    .background(GeometryReader { innerGeometry in
                        Color.clear
                            .onAppear {
                                self.textHeight = max(innerGeometry.size.height, 20)
                            }
                            .onChange(of: text, { oldValue, newValue in
                                DispatchQueue.main.async {
                                    withAnimation {
                                        self.textHeight = max(innerGeometry.size.height, 20)
                                    }
                                }
                            })
                    })
            }
            .frame(maxWidth: .infinity, minHeight: 20, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(Color("bg_blue"))
        .cornerRadius(8)
        
    }
}

#Preview {
    TextView(text: .constant("avwedbvha"), textHeight: .constant(44))
}

#endif
