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
    
    @Option(name: .shortAndLong, help: "Title for current md file")
    private var title: String = ""
    
    // upToNextOption 到下一个option之前都解析，放到数组里
    @Option(name: .long, parsing: .upToNextOption, help: "Tags for current md file")
    private var tags: [String] = [String]()
    
    @Option(name: .shortAndLong, help: "Description for current md file")
    private var description: String = ""
    
    @Flag(name: .shortAndLong, help:"Show full log for debug")
    private var verbose: Bool = false
    
    @Flag(name: .long, help:"Open created file or not")
    private var open: Bool = false
    
    func run() throws {
        Logger.verbose = verbose
        let realTitle = title.isEmpty ? name : title
        let result = Metadata(title: realTitle, tags: tags.joined(separator: ","), description: description).formatedMarkdownMeta()
        let file = try Folder.current.createFile(named: "\(name)\(Metadata.Supplement.fileExtension.rawValue)")
        Logger.debug("\(file.path)")
        try file.write(result)
        if open {
            file.open()
        }
        Logger.message("\(name)\(Metadata.Supplement.fileExtension.rawValue) has beed created successfully!")
        Logger.debug("Content is as below:\n\(result)")
    }
}
