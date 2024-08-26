//
//  PDFKitRepresentedView.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/26.
//

#if os(macOS)
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

#endif

