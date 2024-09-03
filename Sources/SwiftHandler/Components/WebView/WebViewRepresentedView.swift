//
//  File.swift
//  
//
//  Created by admin on 2024/9/3.
//

import WebKit
import SwiftUI

struct WebViewRepresentedView: PlatformViewRepresentable {
    
    let url: URL
    
    #if os(iOS)
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
    
    #elseif os(macOS)
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        nsView.load(request)
    }
    #endif
}
