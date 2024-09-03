//
//  File.swift
//  
//
//  Created by admin on 2024/9/2.
//


import PDFKit
import SwiftUI

struct PDFKitRepresentedView: PlatformViewRepresentable {

    let pdfView = PDFView()
    let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    #if os(iOS)
    func makeUIView(context: Context) -> PDFView {
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = PDFDocument(url: url)
    }
    
    #elseif os(macOS)
    func makeNSView(context: Context) -> PDFView {
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateNSView(_ nsView: PDFView, context: Context) {
        nsView.document = PDFDocument(url: url)
    }
    #endif
}
