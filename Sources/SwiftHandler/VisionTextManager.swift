
import Vision
import AppKit
import SwiftUI

class VisionTextManager: ObservableObject {
    
//    @Published var extractedText: String = ""
    
    func getTextFromImage(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let image = PlatformImage(contentsOf: url), let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            completion(.failure(NSError(domain: "UniversalTextExtractor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image."])))
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                DispatchQueue.main.async {
//                    self.extractedText = text
                    completion(.success(text))
                }
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
}

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
