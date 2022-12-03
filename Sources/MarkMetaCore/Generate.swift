//
//  File.swift
//  
//
//  Created by Vong on 2022/8/31.
//

import Foundation
import ArgumentParser
import Files

struct Generate: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "new", abstract: "Create a new markdown file with specified metadata at current folder。Just give a name, don't need file extesion `.md` etc. The name will use as title in metadata.")
    @Argument(help: "The markdown file name")
    private var name = Date().mdFilename
    
    // upToNextOption 到下一个option之前都解析，放到数组里
    @Option(name: .shortAndLong, parsing: .upToNextOption, help: "tags for current md file")
    private var tags: [String] = [String]()
    
    @Option(name: .shortAndLong, help: "description for current md file")
    private var description: String = ""
    
    @Flag(name: .shortAndLong, help:"show full log for debug")
    private var verbose: Bool = false
    
    func run() throws {
        Logger.verbose = verbose
        let result = Metadata(title: name, tags: tags.joined(separator: ","), description: description).formatedMarkdownMeta()
        let file = try Folder.current.createFile(named: "\(name)\(Metadata.Supplement.fileExtension.rawValue)")
        try file.write(result)
        Logger.debug("\(name)\(Metadata.Supplement.fileExtension.rawValue) has beed created successfully! Content is as below:\n\(result)")
    }
}
