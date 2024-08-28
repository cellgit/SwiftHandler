
import Vision
import SwiftUI

// 通用类型别名
#if os(iOS)
import UIKit
typealias PlatformImage = UIImage

extension Image {
    init(platformImage: PlatformImage) {
        self.init(uiImage: platformImage)
    }
}

#elseif os(macOS)
import AppKit

typealias PlatformImage = NSImage

extension Image {
    init(platformImage: PlatformImage) {
        self.init(nsImage: platformImage)
    }
}
#endif



class VisionTextManager: ObservableObject {
    
    func getTextFromImage(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
#if os(iOS)
        guard let image = UIImage(contentsOfFile: url.path),
              let cgImage = image.cgImage else {
            completion(.failure(NSError(domain: "UniversalTextExtractor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image."])))
            return
        }
#elseif os(macOS)
        guard let image = PlatformImage(contentsOf: url), let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            completion(.failure(NSError(domain: "UniversalTextExtractor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image."])))
            return
        }
        
#endif
        performTextRecognition(on: cgImage, completion: completion)
    }
    
    func getTextFromClipboard(completion: @escaping (Result<String, Error>) -> Void) {
#if os(iOS)
        guard let image = getClipboardImage(),
              let cgImage = image.cgImage else {
            completion(.failure(NSError(domain: "UniversalTextExtractor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image from clipboard."])))
            return
        }
#elseif os(macOS)
        guard let image = getClipboardImage(), let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            completion(.failure(NSError(domain: "UniversalTextExtractor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image from clipboard."])))
            return
        }
#endif
        
        
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
        
        // 自动检测语言
        request.automaticallyDetectsLanguage = true
        request.usesLanguageCorrection = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func getClipboardImage() -> PlatformImage? {
        
        #if os(macOS)
        let pasteboard = NSPasteboard.general
        if let data = pasteboard.data(forType: .png) {
            return PlatformImage(data: data)
        }
        #elseif os(iOS)
        let pasteboard = UIPasteboard.general
        if let data = pasteboard.data(forPasteboardType: "png") {
            return PlatformImage(data: data)
        }
        #endif
        return nil
    }
}
