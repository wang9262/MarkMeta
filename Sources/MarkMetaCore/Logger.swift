//
//  Logger.swift
//  
//
//  Created by Vong on 2022/8/31.
//

import Foundation

struct Logger {
    static var verbose = false
    static func debug(_ message: Any) {
        guard verbose else { return }
        print(message)
    }
    
    static func message(_ message: Any) {
        print(message)
    }
}
