
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
    @Published public var errorMessage: String? = nil
    @Published public var waveformValues: [Float] = [] // 音频波形值
    
    public init() {}
    
    public func requestAuthorization(completion: @escaping (SFSpeechRecognizerAuthorizationStatus) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                completion(authStatus)
            }
        }
    }
    
    public func startRecording() throws {
        errorMessage = nil
        recognizedText = ""
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
                    // 通过累积所有的部分结果来构建完整的文本
                    self.recognizedText += result.bestTranscription.formattedString
//                    self.recognizedText = result.bestTranscription.formattedString
                    
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
            
            // 处理音频数据来生成波形
            let channelData = buffer.floatChannelData?[0]
            let channelDataValueArray = stride(from: 0, to: Int(buffer.frameLength), by: buffer.stride).map { channelData?[$0] ?? 0.0 }
            
            let rms = sqrt(channelDataValueArray.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
            
            DispatchQueue.main.async {
                self.waveformValues.append(rms)
                if self.waveformValues.count > 100 {
                    self.waveformValues.removeFirst()
                }
            }
            
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
        recognitionTask?.finish()
        recognitionTask = nil
        
        isRecognizing = false // 标记为未在识别
    }
    
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
    
    
    private var lastLanguageDetectionTime: Date = Date()
    
    private func detectLanguage(from text: String) {
        let currentTime = Date()
        if currentTime.timeIntervalSince(lastLanguageDetectionTime) < 5 {
            // 如果上次语言检测是在5秒之内，不重新检测
            return
        }
        lastLanguageDetectionTime = currentTime
        
        let languageRecognizer = NLLanguageRecognizer()
        languageRecognizer.processString(text)
        
        if let languageCode = languageRecognizer.dominantLanguage?.rawValue {
            if languageCode != self.detectedLanguage {
                self.detectedLanguage = languageCode
                print("Detected language: \(languageCode)")
                
                // 更新语音识别器并重启识别
                self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode))
                self.stopRecording()
                try? self.startRecording()
            }
        }
    }
    
    
    
    
    private func handleRecognitionError(_ error: Error) {
        // 根据需要处理错误，比如提示用户或尝试恢复
        DispatchQueue.main.async {
                self.errorMessage = "Recognition error: \(error.localizedDescription)"
                self.isRecognizing = false // 标记为未在识别
            }
        print("Handled recognition error: \(error.localizedDescription)")
    }
}


/// 语音输入波形图
public struct WaveformView: View {
    @ObservedObject public var speechRecognizer: SpeechRecognizer
    
    public enum Direction {
        case leftToRight
        case rightToLeft
    }
    
    public var direction: Direction = .rightToLeft // 默认从右向左
    
    public init(speechRecognizer: SpeechRecognizer, direction: Direction = .rightToLeft) {
        self.speechRecognizer = speechRecognizer
        self.direction = direction
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width: CGFloat = 2
            
            HStack(alignment: .center, spacing: 2) {
                ForEach(self.displayWaveformValues, id: \.self) { value in
                    WaveformBarView(value: value)
                        .frame(width: width, height: CGFloat(value) * height)
                }
            }
            .frame(maxWidth: .infinity, alignment: self.alignment)
        }
    }
    
    private var displayWaveformValues: [Float] {
        switch direction {
        case .leftToRight:
            return speechRecognizer.waveformValues.reversed()
        case .rightToLeft:
            return speechRecognizer.waveformValues
        }
    }
    
    private var alignment: Alignment {
        switch direction {
        case .leftToRight:
            return .leading
        case .rightToLeft:
            return .trailing
        }
    }
}


struct WaveformBarView: View {
    var value: Float
    
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .cornerRadius(2)
    }
}
