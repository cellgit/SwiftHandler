//
//  File.swift
//  
//
//  Created by admin on 2024/8/29.
//

import Foundation

public extension Dictionary {
    public func toString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let carbonPaperData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: carbonPaperData, encoding: .utf8)
    }
}
