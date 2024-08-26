//
//  FileContentView.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/26.
//

#if os(macOS)
import SwiftUI
import UniformTypeIdentifiers

struct FileContentView: View {
    
    @Binding var sourceLanguage: LanguageManager
    @Binding var targetLanguage: LanguageManager
    
    @State private var sourceText: String = ""
    @State private var targetText: String = ""
    
    @State var isCopied: Bool = false
    
    @State private var documentURL: URL?
    
    var body: some View {
        
        HSplitView() {
            VStack(alignment: .trailing) {
                
                if let documentURL = documentURL {
                    let lowercased = documentURL.pathExtension.lowercased()
                    if lowercased == "pdf" {
                        PDFKitView(url: documentURL, extractedText: $sourceText)
                    }
                    else {
                        UniversalTextExtractor(url: documentURL, extractedText: $sourceText)
                    }
                } else {
                    VStack(alignment: .center, spacing: nil) {
                        VStack(alignment: .center, spacing: nil){
                            //                        Image(systemName: "text.document")
                            Image(systemName: "eraser.line.dashed")
                                .font(.system(size: 32))
                            Text("PDF")
                                .fontWeight(.medium)
                                .fontDesign(.monospaced)
                        }
                        .foregroundColor(.gray)
                        .frame(width: 100, height: 80)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style: StrokeStyle(lineWidth: 3.5, dash: [10, 6]))
                                .foregroundColor(.gray)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            selectDocument()
                        }
                    }
                    .frame(idealWidth: .infinity, maxWidth: .infinity, idealHeight: .infinity, maxHeight: .infinity, alignment: .center)
                }
                
                Button(action: {
                    debugPrint("清空")
                    documentURL = nil
                }, label: {
                    Image(systemName: "eraser.line.dashed")
                })
                .padding()
                
            }
            .onDrop(of: [.fileURL], isTargeted: nil, perform: handleDrop)
//            .onChange(of: documentURL)) { oldValue, newValue in
//                
//                let outputFileName = "output.pdf"
//                pdfConverter.convertFileToPDF(fileURL: newValue, outputFileName: outputFileName)
//            }
            
            
            VStack (alignment: .trailing){
                // 翻译后这里应该写成 $targetText
                TextEditor(text: $sourceText)
                    .scrollContentBackground(.hidden)
                    .font(.body)
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .onChange(of: targetText) { oldValue, newValue in
                        if oldValue != newValue {
                            isCopied = false
                        }
                    }
                
                if !targetText.isEmpty {
                    Button(action: {
                        TextManager.shared.copy(targetText)
                        isCopied = true
                    }, label: {
                        Image(systemName: "heart.text.clipboard")
                            .symbolRenderingMode(isCopied ? .multicolor : .monochrome)
                    })
                    .padding()
                }
                
                
            }
        }
        
    }
    
    func selectDocument() {
        let panel = NSOpenPanel()
        let wordDocType = UTType("com.microsoft.word.doc")!
        let wordDocxType = UTType("org.openxmlformats.wordprocessingml.document")!
//        panel.allowedFileTypes = ["pdf", "docx", "doc"]
        panel.allowedContentTypes = [UTType.pdf, wordDocType, wordDocxType]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        if panel.runModal() == .OK, let url = panel.url {
            documentURL = url
        }

    }
    
    // 拖拽
    func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let item = providers.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) }) else {
            return false
        }
        
        item.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (urlData, error) in
            DispatchQueue.main.async {
                if let data = urlData as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) {
                    self.documentURL = url
                }
            }
        }
        return true
    }
    
}




#Preview {
    FileContentView(sourceLanguage: .constant(.zh_Hans), targetLanguage: .constant(.en_US))
}

#endif
