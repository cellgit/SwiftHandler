//
//  File.swift
//  
//
//  Created by admin on 2024/8/30.
//

import SwiftUI
import Combine

public class PasteboardMonitor: ObservableObject {
    @Published public var pasteboardContent: String = ""
    private var pasteboardChangeCount = NSPasteboard.general.changeCount
    private var timer: Timer?
    
    public init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkPasteboard()
        }
    }
    
    private func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkPasteboard() {
        let pasteboard = NSPasteboard.general
        let currentChangeCount = pasteboard.changeCount
        
        if currentChangeCount != pasteboardChangeCount {
            pasteboardChangeCount = currentChangeCount
            if let content = pasteboard.string(forType: .string) {
                DispatchQueue.main.async {
                    self.pasteboardContent = content
                }
            }
        }
    }
}

//struct ContentView: View {
//    @StateObject private var pasteboardMonitor = PasteboardMonitor()
//    @AppStorage("isAutoPasteEnabled") private var isAutoPasteEnabled = false
//    @State private var sourceText: String = ""
//    @FocusState private var focusedField: Field?
//    
//    enum Field {
//        case sourceTextEditor
//    }
//    
//    var body: some View {
//        VStack {
//            Picker("自动粘贴", selection: $isAutoPasteEnabled) {
//                Text("启用").tag(true)
//                Text("禁用").tag(false)
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//            
//            TextEditor(text: $sourceText)
//                .scrollContentBackground(.hidden)
//                .font(.body)
//                .lineSpacing(2)
//                .padding([.horizontal, .top], 8)
//                .focused($focusedField, equals: .sourceTextEditor)
//                .onChange(of: pasteboardMonitor.pasteboardContent) { newValue in
//                    if isAutoPasteEnabled {
//                        sourceText = newValue
//                    }
//                }
//        }
//        .padding()
//    }
//}
