//
//  File.swift
//  
//
//  Created by Vong on 2022/8/31.
//

import Foundation
import ArgumentParser
import Files
import Sweep

struct Append: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "append", abstract: "Append metadata to exsisted markdown file.")
    @Argument(help: "The markdown file full path include file extension or jsut name without extension at current folder")
    private var path = ""
    
    @Option(name: .long, help: "Update title in markdown metadata")
    private var title = ""
    
    @Option(name: .shortAndLong, parsing: .upToNextOption, help: "Update tags for current md file")
    private var tags: [String] = [String]()
    
    @Option(name: .shortAndLong, help: "Update description for current md file")
    private var description: String = ""
    
    @Flag(name: .shortAndLong, help:"Show full log for debug")
    private var verbose: Bool = false
    func run() throws {
        guard !path.isEmpty else {
            throw ValidationError("Must specify markdown path!")
        }
        try updateMetadata(at: path)
    }
}

private extension Append {
    func updateMetadata(at path: String) throws {
        var fileName = path
        var realPath = path
        if !path.contains("/") {
            realPath = Folder.current.path.appending("\(path)\(Metadata.Supplement.fileExtension.rawValue)")
        } else {
            fileName = String(path.components(separatedBy: "/").last!.dropLast(3))
        }
        var title = self.title
        if title.isEmpty {
            title = fileName
        }
        let file = try File(path: realPath)
        var content = try file.readAsString()
        
        var originMeta = content.firstSubstring(between: Identifier(stringLiteral:Metadata.Supplement.prefix.rawValue), and: Terminator(stringLiteral:Metadata.Supplement.suffix.rawValue)) ?? ""
        let meta = Metadata(title: title, tags: tags.joined(separator: ","), description: description)
        if originMeta.isEmpty {
            content = meta.formatedMarkdownMeta() + content
        } else {
            var metaInfo: [Metadata.Kind: String] = [
                .title: meta.title,
                .tags: meta.tags,
                .description: meta.description,
                .date: ""
            ]
            let matchers: [Matcher] = Metadata.Kind.allCases.map { kind in
                Matcher(identifier: Identifier(stringLiteral:"\(kind.rawValue): "), terminator: Terminator(stringLiteral: Metadata.Supplement.newLine.rawValue), allowMultipleMatches: false, handler: { text, _ in
                    if let kindMeta = metaInfo[kind], kindMeta.isEmpty {
                        metaInfo[kind] = String(text)
                    }
                })
            }
            originMeta.scan(using: matchers)
            if metaInfo[.date]!.isEmpty {
                metaInfo[.date] = Date().mdMeta
            }
            let resultMeta = Metadata(title: metaInfo[.title]!, date: metaInfo[.date]!, tags: metaInfo[.tags]!, description: metaInfo[.description]!)
            originMeta = Metadata.Supplement.prefix.rawValue + originMeta + Metadata.Supplement.suffix.rawValue
            content = content.replacingOccurrences(of: originMeta, with: resultMeta.formatedMarkdownMeta())
        }
        
        let folder = file.parent
        try file.delete()
        try folder!.createFile(named: fileName + Metadata.Supplement.fileExtension.rawValue, contents: content.data(using: .utf8))
        Logger.message("Update successfully")
    }
}
