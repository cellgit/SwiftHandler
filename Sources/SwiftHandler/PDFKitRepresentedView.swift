//
//  File.swift
//  
//
//  Created by admin on 2024/9/2.
//

import PDFKit
import SwiftUI

struct PDFKitRepresentedView: NSViewRepresentable {
    
    let pdfView = PDFView()
    let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    func makeNSView(context: Context) -> PDFView {
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateNSView(_ nsView: PDFView, context: Context) {
        nsView.document = PDFDocument(url: url)
    }
}


import WebKit

struct WebViewRepresentedView: NSViewRepresentable {
    
    let url: URL
    
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
}
