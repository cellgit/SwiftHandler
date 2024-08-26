//
//  DocxToPDFConverter.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/26.
//

import Foundation
import PDFKit

//public struct DocxToPDFConverter {
//    public static func convertDocxToPDF(docxPath: String) -> URL? {
//        // 尝试将 .docx 文件内容读取为 NSAttributedString
//        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
//            .documentType: NSAttributedString.DocumentType.docx
//        ]
//        guard let attributedString = try? NSAttributedString(url: URL(fileURLWithPath: docxPath), options: options, documentAttributes: nil) else {
//            print("Failed to read DOCX file as NSAttributedString.")
//            return nil
//        }
//
//        // 设置 PDF 的文件名
//        let pdfFileName = UUID().uuidString + ".pdf"
//
//        // 获取应用的文档目录路径
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let pdfFilePath = documentsDirectory.appendingPathComponent(pdfFileName)
//
//        // 使用 PDFKit 渲染 PDF
//        let pdfData = NSMutableData()
//        guard let pdfConsumer = CGDataConsumer(url: pdfFilePath as CFURL) else {
//            print("Failed to create PDF consumer.")
//            return nil
//        }
//        
//        var mediaBox = CGRect(x: 0, y: 0, width: 612, height: 792) // A4 大小
//        guard let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil) else {
//            print("Failed to create PDF context.")
//            return nil
//        }
//        
//        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
//        var currentRange = CFRange(location: 0, length: 0)
//        var done = false
//
//        while !done {
//            pdfContext.beginPDFPage(nil)
//            
//            // 设置页面范围
//            let framePath = CGPath(rect: mediaBox, transform: nil)
//            let frame = CTFramesetterCreateFrame(framesetter, currentRange, framePath, nil)
//
//            // 绘制当前页面内容
//            CTFrameDraw(frame, pdfContext)
//            
//            // 更新页面范围
//            let visibleRange = CTFrameGetVisibleStringRange(frame)
//            currentRange.location += visibleRange.length
//
//            if currentRange.location >= attributedString.length {
//                done = true
//            }
//            
//            pdfContext.endPDFPage()
//        }
//        
//        pdfContext.closePDF()
//
//        // 确保 PDF 文件已经保存到本地路径
//        if FileManager.default.fileExists(atPath: pdfFilePath.path) {
//            return pdfFilePath
//        } else {
//            print("Failed to save PDF to path: \(pdfFilePath.path)")
//            return nil
//        }
//    }
//}





public struct DocxToPDFConverter {
    public static func convertDocxToPDF(docxPath: String) -> URL? {
        // 尝试将 .docx 文件内容读取为 NSAttributedString
        guard let attributedString = try? NSAttributedString(url: URL(fileURLWithPath: docxPath), options: [:], documentAttributes: nil) else {
            print("Failed to read DOCX file as NSAttributedString.")
            return nil
        }

        // 设置 PDF 的文件名
        let pdfFileName = UUID().uuidString + ".pdf"

        // 获取应用的文档目录路径
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pdfFilePath = documentsDirectory.appendingPathComponent(pdfFileName)

        // 使用 PDFKit 渲染 PDF
        let pdfData = NSMutableData()
        let pdfConsumer = CGDataConsumer(url: pdfFilePath as CFURL)!
        var mediaBox = CGRect(x: 0, y: 0, width: 612, height: 792) // A4 大小
        let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!

        pdfContext.beginPDFPage(nil)

        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let framePath = CGPath(rect: mediaBox, transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), framePath, nil)

        CTFrameDraw(frame, pdfContext)

        pdfContext.endPDFPage()
        pdfContext.closePDF()

        // 确保 PDF 文件已经保存到本地路径
        if FileManager.default.fileExists(atPath: pdfFilePath.path) {
            return pdfFilePath
        } else {
            print("Failed to save PDF to path: \(pdfFilePath.path)")
            return nil
        }
    }
}
