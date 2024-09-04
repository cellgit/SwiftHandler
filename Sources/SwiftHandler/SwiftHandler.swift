// The Swift Programming Language
// https://docs.swift.org/swift-book


#if os(iOS)
import UIKit

public let isPad = UIDevice.current.userInterfaceIdiom == .pad

#else

#endif
