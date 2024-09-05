
//import SwiftUI
//import Speech
//import AVFoundation

//public class SpeechRecognizer: ObservableObject {
//    private var speechRecognizer: SFSpeechRecognizer?
//    private let audioEngine = AVAudioEngine()
//    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//    private var recognitionTask: SFSpeechRecognitionTask?
//    
//    @Published public var recognizedText: String = ""
//    @Published public var detectedLanguage: String
//    @Published public var isRecognizing: Bool = false
//    @Published public var errorMessage: String? = nil
//    @Published public var waveformValues: [Float] = []
//    
//    // 初始化时传入语言代码，例如 "en-US", "zh-Hans", "fr-FR" 等
//    public init(languageCode: String) {
//        self.detectedLanguage = languageCode
//        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode))
//    }
//    
//    public func requestAuthorization(completion: @escaping (SFSpeechRecognizerAuthorizationStatus) -> Void) {
//        SFSpeechRecognizer.requestAuthorization { authStatus in
//            DispatchQueue.main.async {
//                completion(authStatus)
//            }
//        }
//    }
//    
//    public func startRecording() throws {
//        errorMessage = nil
//        recognizedText = ""
//        guard !isRecognizing else {
//            print("Recognition is already in progress.")
//            return
//        }
//        
//        if audioEngine.isRunning {
//            print("Audio engine is already running.")
//            return
//        }
//        
//        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//        
//        guard let recognitionRequest = recognitionRequest else {
//            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
//        }
//        
//        let inputNode = audioEngine.inputNode
//        recognitionRequest.shouldReportPartialResults = true
//        
//        isRecognizing = true
//        
//        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
//            if let result = result {
//                DispatchQueue.main.async {
//                    self.recognizedText += result.bestTranscription.formattedString
//                }
//            }
//            
//            if let error = error {
//                print("Recognition error: \(error)")
//                self.stopRecording()
//                self.handleRecognitionError(error)
//            }
//        }
//        
//        let recordingFormat = inputNode.outputFormat(forBus: 0)
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
//            recognitionRequest.append(buffer)
//            
//            let channelData = buffer.floatChannelData?[0]
//            let channelDataValueArray = stride(from: 0, to: Int(buffer.frameLength), by: buffer.stride).map { channelData?[$0] ?? 0.0 }
//            let rms = sqrt(channelDataValueArray.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
//            
//            DispatchQueue.main.async {
//                self.waveformValues.append(rms)
//                if self.waveformValues.count > 100 {
//                    self.waveformValues.removeFirst()
//                }
//            }
//        }
//        
//        audioEngine.prepare()
//        
//        do {
//            try audioEngine.start()
//        } catch {
//            print("Audio engine couldn't start: \(error.localizedDescription)")
//            stopRecording()
//        }
//    }
//    
//    public func stopRecording() {
//        guard isRecognizing else { return }
//        audioEngine.stop()
//        audioEngine.inputNode.removeTap(onBus: 0)
//        
//        recognitionRequest?.endAudio()
//        recognitionTask?.cancel()
//        recognitionTask?.finish()
//        recognitionTask = nil
//        
//        isRecognizing = false
//    }
//    
//    private func handleRecognitionError(_ error: Error) {
//        DispatchQueue.main.async {
//            self.errorMessage = "Recognition error: \(error.localizedDescription)"
//            self.isRecognizing = false
//        }
//        print("Handled recognition error: \(error.localizedDescription)")
//    }
//}
//
//
///// 语音输入波形图
//public struct WaveformView: View {
//    @ObservedObject public var speechRecognizer: SpeechRecognizer
//    
//    public enum Direction {
//        case leftToRight
//        case rightToLeft
//    }
//    
//    public var direction: Direction = .rightToLeft // 默认从右向左
//    
//    public init(speechRecognizer: SpeechRecognizer, direction: Direction = .rightToLeft) {
//        self.speechRecognizer = speechRecognizer
//        self.direction = direction
//    }
//    
//    public var body: some View {
//        GeometryReader { geometry in
//            let height = geometry.size.height
//            let width: CGFloat = 2
//            
//            HStack(alignment: .center, spacing: 2) {
//                ForEach(self.displayWaveformValues, id: \.self) { value in
//                    WaveformBarView(value: value)
//                        .frame(width: width, height: CGFloat(value) * height)
//                }
//            }
//            .frame(maxWidth: .infinity, alignment: self.alignment)
//        }
//    }
//    
//    private var displayWaveformValues: [Float] {
//        switch direction {
//        case .leftToRight:
//            return speechRecognizer.waveformValues.reversed()
//        case .rightToLeft:
//            return speechRecognizer.waveformValues
//        }
//    }
//    
//    private var alignment: Alignment {
//        switch direction {
//        case .leftToRight:
//            return .leading
//        case .rightToLeft:
//            return .trailing
//        }
//    }
//}
//
//
//struct WaveformBarView: View {
//    var value: Float
//    
//    var body: some View {
//        Rectangle()
//            .fill(Color.blue)
//            .cornerRadius(2)
//    }
//}
