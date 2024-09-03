//
//  File.swift
//  
//
//  Created by admin on 2024/9/3.
//

import SwiftUI

#if os(iOS)
import UIKit
typealias PlatformViewRepresentable = UIViewRepresentable

#elseif os(macOS)
import AppKit
typealias PlatformViewRepresentable = NSViewRepresentable

#endif
