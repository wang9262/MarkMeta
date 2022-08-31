//
//  File.swift
//  
//
//  Created by Vong on 2022/8/31.
//

import Foundation
import ArgumentParser

public struct MarkMeta: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to easily generate markdown with metadata for blog, or append metadata for existing markdown",
        subcommands: [Generate.self, Append.self])
    
    public init() { }
}
