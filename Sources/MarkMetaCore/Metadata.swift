//
//  File.swift
//  
//
//  Created by Vong on 2022/8/31.
//

import Foundation

struct Metadata {
    enum Kind: String, CaseIterable {
        case title
        case tags
        case date
        case description
    }
    
    enum Supplement: String {
        case prefix = "---"
        case suffix = "---\n"
        case fileExtension = ".md"
        case newLine = "\n"
    }
    
    var title: String
    var date = Date().mdMeta
    var tags: String
    var description: String
}

extension Metadata {
    func formatedMarkdownMeta() -> String {
        let dict = [
            Kind.title.rawValue: title,
            Kind.date.rawValue: date,
            Kind.tags.rawValue: tags,
            Kind.description.rawValue: description
        ].sorted {$0.key < $1.key}
        var result = Supplement.prefix.rawValue
        for (key, value) in dict {
            if !value.isEmpty {
                result += "\(Supplement.newLine.rawValue)\(key): \(value)"
            }
        }
        result += Supplement.newLine.rawValue
        result += Supplement.suffix.rawValue
        return result
    }
}
