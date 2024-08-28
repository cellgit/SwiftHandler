
import SwiftUI
import Speech
import AVFoundation
import NaturalLanguage

public class SpeechRecognizer: ObservableObject {
    private var speechRecognizer: SFSpeechRecognizer?
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    @Published public var recognizedText: String = ""
    @Published public var detectedLanguage: String = "en-US" // Default language
    @Published public var isRecognizing: Bool = false // 是否正在识别的状态变量
    
    public init() {}
    
    public func requestAuthorization(completion: @escaping (SFSpeechRecognizerAuthorizationStatus) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                completion(authStatus)
            }
        }
    }
    
    public func startRecording() throws {
        guard !isRecognizing else {
            print("Recognition is already in progress.")
            return
        }
        
        // 检查音频引擎是否正在运行
        if audioEngine.isRunning {
            print("Audio engine is already running.")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
        }
        
        let inputNode = audioEngine.inputNode
        
        recognitionRequest.shouldReportPartialResults = true
        
        // Initialize the recognizer with a default language (en-US)
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: detectedLanguage))
        
        isRecognizing = true // 标记为正在识别
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.recognizedText = result.bestTranscription.formattedString
                    
                    // Detect the language from the partial result and update the recognizer
                    self.detectLanguage(from: self.recognizedText)
                }
            }
            
            if let error = error {
                print("Recognition error: \(error)")
                self.stopRecording()
                self.handleRecognitionError(error)
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine couldn't start: \(error.localizedDescription)")
            stopRecording()
        }
    }
    
    public func stopRecording() {
        guard isRecognizing else { return }
        
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        
        isRecognizing = false // 标记为未在识别
    }
    
    private func detectLanguage(from text: String) {
        let languageRecognizer = NLLanguageRecognizer()
        languageRecognizer.processString(text)
        
        if let languageCode = languageRecognizer.dominantLanguage?.rawValue {
            if languageCode != self.detectedLanguage {
                self.detectedLanguage = languageCode
                print("Detected language: \(languageCode)")
                
                // Update the speech recognizer with the new language
                self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode))
                
                // Restart recognition with the new language
                self.stopRecording()
                try? self.startRecording()
            }
        }
    }
    
    private func handleRecognitionError(_ error: Error) {
        // 根据需要处理错误，比如提示用户或尝试恢复
        print("Handled recognition error: \(error.localizedDescription)")
    }
}


//public class SpeechRecognizer: ObservableObject {
//    private var speechRecognizer: SFSpeechRecognizer?
//    private let audioEngine = AVAudioEngine()
//    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//    private var recognitionTask: SFSpeechRecognitionTask?
//    
//    @Published public var recognizedText: String = ""
//    @Published public var detectedLanguage: String = "en-US" // Default language
//    @Published public var isRecognizing: Bool = false // 是否正在识别的状态变量
//    
//    // 初始化方法设为 public
//    public init() {}
//    
//    // 修改 requestAuthorization 方法，增加完成回调
//    public func requestAuthorization(completion: @escaping (SFSpeechRecognizerAuthorizationStatus) -> Void) {
//        SFSpeechRecognizer.requestAuthorization { authStatus in
//            DispatchQueue.main.async {
//                completion(authStatus)
//            }
//        }
//    }
//    
//    public func startRecording() throws {
//        guard !isRecognizing else {
//            print("Recognition is already in progress.")
//            return
//        }
//        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//        
//        guard let recognitionRequest = recognitionRequest else {
//            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
//        }
//        
//        let inputNode = audioEngine.inputNode
//        recognitionRequest.shouldReportPartialResults = true
//        
//        // Initialize the recognizer with a default language (en-US)
//        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: detectedLanguage))
//        
//        isRecognizing = true // 标记为正在识别
//        
//        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
//            if let result = result {
//                DispatchQueue.main.async {
//                    self.recognizedText = result.bestTranscription.formattedString
//                    
//                    // Detect the language from the partial result and update the recognizer
//                    self.detectLanguage(from: self.recognizedText)
//                }
//            }
//            
//            if let error = error {
//                print("Recognition error: \(error)")
//                self.audioEngine.stop()
//                inputNode.removeTap(onBus: 0)
//                self.recognitionRequest = nil
//                self.recognitionTask = nil
//            }
//        }
//        
//        let recordingFormat = inputNode.outputFormat(forBus: 0)
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
//            recognitionRequest.append(buffer)
//        }
//        
//        audioEngine.prepare()
//        try audioEngine.start()
//    }
//    
//    public func stopRecording() {
//        guard isRecognizing else { return }
//        audioEngine.stop()
//        recognitionRequest?.endAudio()
//        recognitionTask?.cancel()
//        isRecognizing = false // 标记为未在识别
//    }
//    
//    private func detectLanguage(from text: String) {
//        let languageRecognizer = NLLanguageRecognizer()
//        languageRecognizer.processString(text)
//        
//        if let languageCode = languageRecognizer.dominantLanguage?.rawValue {
//            if languageCode != self.detectedLanguage {
//                self.detectedLanguage = languageCode
//                print("Detected language: \(languageCode)")
//                
//                // Update the speech recognizer with the new language
//                self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode))
//                
//                // Restart recognition with the new language
//                self.stopRecording()
//                try? self.startRecording()
//            }
//        }
//    }
//}

