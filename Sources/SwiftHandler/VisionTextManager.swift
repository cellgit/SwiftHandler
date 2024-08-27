
import Vision
import AppKit
import SwiftUI

class VisionTextManager: ObservableObject {
    
    func getTextFromImage(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let image = PlatformImage(contentsOf: url), let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            completion(.failure(NSError(domain: "UniversalTextExtractor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image."])))
            return
        }
        
        performTextRecognition(on: cgImage, completion: completion)
    }
    
    func getTextFromClipboard(completion: @escaping (Result<String, Error>) -> Void) {
        guard let image = getClipboardImage(), let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            completion(.failure(NSError(domain: "UniversalTextExtractor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image from clipboard."])))
            return
        }
        
        performTextRecognition(on: cgImage, completion: completion)
    }
    
    private func performTextRecognition(on cgImage: CGImage, completion: @escaping (Result<String, Error>) -> Void) {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                DispatchQueue.main.async {
                    completion(.success(text))
                }
            }
        }
        
        // 使用 LanguageManager 获取所有语种标识符
        //        request.recognitionLanguages = LanguageManager.allCases.map { $0.identifier }
        request.recognitionLanguages = ["zh-Hant", "en", "en-US", "zh-Hans", "ja", "ko", "fr", "de", "ru"]
        request.usesLanguageCorrection = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func getClipboardImage() -> NSImage? {
        let pasteboard = NSPasteboard.general
        if let data = pasteboard.data(forType: .png) {
            return NSImage(data: data)
        }
        return nil
    }
}




//class VisionTextManager: ObservableObject {
//    
//    /// 提取url文件的文字
//    func getTextFromImage(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
//        guard let image = PlatformImage(contentsOf: url), let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
//            completion(.failure(NSError(domain: "UniversalTextExtractor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image."])))
//            return
//        }
//        
//        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        let request = VNRecognizeTextRequest { (request, error) in
//            guard error == nil else {
//                completion(.failure(error!))
//                return
//            }
//            if let observations = request.results as? [VNRecognizedTextObservation] {
//                let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
//                DispatchQueue.main.async {
//                    completion(.success(text))
//                }
//            }
//        }
//        
//        // 设置识别语言
////        let languages = LanguageManager.allCases.map { $0.identifier } // 这个不起作用
//        request.recognitionLanguages = ["zh-Hant", "en", "en-US", "zh-Hans", "ja", "ko", "fr", "de", "ru"]
//        request.usesLanguageCorrection = true
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                try requestHandler.perform([request])
//            } catch {
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    /// 提取剪切板截图的文字
//    func getTextFromClipboard(completion: @escaping (Result<String, Error>) -> Void) {
//        guard let image = getClipboardImage(), let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
//            completion(.failure(NSError(domain: "UniversalTextExtractor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image from clipboard."])))
//            return
//        }
//        
//        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        let request = VNRecognizeTextRequest { (request, error) in
//            guard error == nil else {
//                completion(.failure(error!))
//                return
//            }
//            if let observations = request.results as? [VNRecognizedTextObservation] {
//                let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
//                DispatchQueue.main.async {
//                    completion(.success(text))
//                }
//            }
//        }
//        
//        // 设置识别语言
//        request.recognitionLanguages = ["zh-Hant", "en", "en-US", "zh-Hans", "ja", "ko", "fr", "de", "ru"]
//        
//        request.usesLanguageCorrection = true
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                try requestHandler.perform([request])
//            } catch {
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    private func getClipboardImage() -> NSImage? {
//        let pasteboard = NSPasteboard.general
//        if let data = pasteboard.data(forType: .png) {
//            return NSImage(data: data)
//        }
//        return nil
//    }
//}


// 通用类型别名
#if os(iOS)
typealias PlatformImage = UIImage

extension Image {
    init(platformImage: PlatformImage) {
        self.init(uiImage: platformImage)
    }
}

#elseif os(macOS)
typealias PlatformImage = NSImage

extension Image {
    init(platformImage: PlatformImage) {
        self.init(nsImage: platformImage)
    }
}
#endif
