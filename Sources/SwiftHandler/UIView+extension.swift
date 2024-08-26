//
//  UIView+extension.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/26.
//


import WebKit


#if os(iOS)
import UIKit


extension UIView {
    func convertToPDFData() -> Data? {
        let format = self.viewPrintFormatter()
        let renderer = UIPrintPageRenderer()
        renderer.addPrintFormatter(format, startingAtPageAt: 0)
        
        let pageRect = CGRect(x: 0, y: 0, width: 600, height: 768)
        let printableRect = pageRect.insetBy(dx: 50, dy: 50)
        
        renderer.setValue(NSValue(cgRect: pageRect), forKey: "paperRect")
        renderer.setValue(NSValue(cgRect: printableRect), forKey: "printableRect")
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pageRect, nil)
        
        for i in 0..<renderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            let bounds = UIGraphicsGetPDFContextBounds()
            renderer.drawPage(at: i, in: bounds)
        }
        
        UIGraphicsEndPDFContext()
        
        return pdfData as Data
    }
}

#endif

