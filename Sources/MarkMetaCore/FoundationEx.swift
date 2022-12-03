//
//  File.swift
//  
//
//  Created by Vong on 2022/8/31.
//

import Foundation

extension DateFormatter {
    static var mdFileFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    static var mdMetaFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }
}

extension Date {
    var mdFilename: String {
        return DateFormatter.mdFileFormatter.string(from: self)
    }
    
    var mdMeta: String {
        return DateFormatter.mdMetaFormatter.string(from: self)
    }
}
