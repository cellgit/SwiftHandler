//
//  File.swift
//  
//
//  Created by admin on 2024/8/27.
//

import UniformTypeIdentifiers
let markdownUTI = UTType("net.daringfireball.markdown")!
let wordDocType = UTType("com.microsoft.word.doc")!
let wordDocxType = UTType("org.openxmlformats.wordprocessingml.document")!

public class SupportedUrlType {
    
    public static let shared = SupportedUrlType()
    
    private init() {}
    
    public var allTypes: [UTType] {
    
        [.pdf,
         .plainText,
         .utf8PlainText,
         .utf16PlainText,
         .utf16ExternalPlainText,
         
         .commaSeparatedText,
         .tabSeparatedText,
         .utf8TabSeparatedText,
         
         .rtf,
         
         .html,
         
         .xml,
         .yaml,
         .json,
         
         .sourceCode,
         .cSource,
         .objectiveCSource,
         .swiftSource,
         .cPlusPlusSource,
         .cHeader,
         .cPlusPlusHeader,
         .script,
         
         .log,
         
         .vCard,
         
         .m3uPlaylist,
         
         .png,
         .jpeg,
         .tiff,
         .heic,
         .heif,
         
         markdownUTI,
         wordDocType,
         wordDocxType,
         
        ]
        
        
    }
    
    
}
