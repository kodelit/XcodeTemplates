#!/usr/bin/swift
// This code is distributed under the terms and conditions of the MIT License:

// Copyright © 2020 kodelit.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Cocoa

let scriptPath = CommandLine.arguments.first!
var scriptDirUrl = URL(fileURLWithPath: scriptPath)
scriptDirUrl.deleteLastPathComponent()
let fileManager = FileManager.default

enum Arguments {
    static let arguments = CommandLine.arguments

    static func contains(_ argument: Option) -> Bool {
        guard let long = argument.long, let short = argument.short else { return false }
        return Self.arguments.contains(long) || Self.arguments.contains(short)
    }
}

enum Option: String, ExpressibleByStringLiteral {
    case help
    case develop
    case unknown

    private enum ShortKey: String, CaseIterable {
        case develop = "d"
    }

    var long: String? {
        self == .unknown ? nil : "--\(rawValue)"
    }

    var short: String? {
        guard self != .unknown else { return nil }
        if let shortKey = ShortKey(rawValue: self.rawValue) {
            return "-\(shortKey.rawValue)"
        }
        return "-\(rawValue.first!)"
    }

    public init(stringLiteral value: String) {
        let value = value.trimmingCharacters(in: CharacterSet(charactersIn: "- "))
        self = Self(rawValue: value) ?? .unknown
    }
}

let isRequestingHelp = Arguments.contains(.help)

//let path: String = "~/Library/MobileDevice/Provisioning Profiles/"
//let profilesDirAbsolutPath = NSString(string: path).expandingTildeInPath
//print("Path", profilesDirAbsolutPath)


let sourceDir = scriptDirUrl.appendingPathComponent("Source")
let generatedTemplatesDir = scriptDirUrl.appendingPathComponent("Output")

// MARK: - Models

class Architectures {
    let sourceDir = scriptDirUrl.appendingPathComponent("Source")
    let generatedTemplatesDir = scriptDirUrl.appendingPathComponent("Output")
}

class CleanSwift {
    static let rootDir = scriptDirUrl.appendingPathComponent("Source")
    static var sourceDir = rootDir.appendingPathComponent("Source")
    static let commentFileUrl = sourceDir.appendingPathComponent("SOURCE_FILE_TOP_COMMENT.swift")

    var fileName = ""
    var fileNameWithoutExtension = ""


    let sourceFileTopComment: String

    let commonTemplatesDirNames = ["Assembler.xctemplate", "Interactor.xctemplate", "Models.xctemplate", "Presenter.xctemplate", "Router.xctemplate", "Worker.xctemplate"]
    let viewControllerNames = ["UICollectionViewController", "UITableViewController", "UIViewController"]

    let sceneTemplateDirName = "Scene.xctemplate"
    lazy var sceneTemplateSourceDir = Self.sourceDir.appendingPathComponent(sceneTemplateDirName)
    let viewControllerTemplateDirName = "View Controller.xctemplate"
    lazy var viewControllerSourceDir = Self.sourceDir.appendingPathComponent(viewControllerTemplateDirName)
    lazy var viewControllerSourceFile = viewControllerSourceDir
        .appendingPathComponent("UIViewController")
        .appendingPathComponent("___FILEBASENAME___ViewController.swift")
    let testsTemplatesDirName = "Unit Tests.xctemplate"

    init() throws {
        sourceFileTopComment = try String(contentsOf: Self.commentFileUrl, encoding: .utf8)
    }

    func getFileName(from url: URL) -> (fileName: String, fileNameWithoutExtension: String) {
        let fileName = url.lastPathComponent
        let fileNameWithoutExtension = url.deletingPathExtension().lastPathComponent
        return (fileName: fileName, fileNameWithoutExtension: fileNameWithoutExtension)
    }

    func generate(sourceFile: URL, targetDir: URL) throws {
        let (fileName, _) = getFileName(from: sourceFile)
        let targetFile = targetDir.appendingPathComponent(fileName)
        var content = try String(contentsOf: sourceFile, encoding: .utf8)
        content = sourceFileTopComment + content
        try content.write(to: targetFile, atomically: true, encoding: .utf8)
    }

    func generateCommonTemplates(installDir: URL, generateOnlySourceFile: Bool) throws {
        try fileManager.createDirectory(at: installDir, withIntermediateDirectories: true, attributes: nil)
        try commonTemplatesDirNames.forEach { (templateDirName) in
            let templateSourceDir = Self.sourceDir.appendingPathComponent(templateDirName)
            var templateTargetDir = installDir

            if !generateOnlySourceFile {
                templateTargetDir.appendPathComponent(templateDirName)

                if fileManager.fileExists(atPath: templateTargetDir.absoluteString) {
                    try fileManager.removeItem(at: templateTargetDir)
                }
                try fileManager.createDirectory(at: templateTargetDir, withIntermediateDirectories: true, attributes: nil)
                try fileManager.copyItem(at: Self.sourceDir, to: installDir)
            }

            if let files = try? FileManager.default.contentsOfDirectory(atPath: Self.sourceDir.absoluteString) {
                let swiftFiles = files.filter { $0.hasSuffix(".swift") }

                try swiftFiles.forEach { (path) in
                    guard let url = URL(string: path) else { return }
                    try generate(sourceFile: url, targetDir: templateTargetDir)
                }
            }
        }
    }

    func install() throws {
        if fileManager.fileExists(atPath: generatedTemplatesDir.absoluteString) {
            try fileManager.removeItem(at: generatedTemplatesDir)
        }
    }

}

struct GitRepo {
    static let repo = "https://github.com/kodelit/XcodeTemplates.git"
    static let targetDirectory = scriptDirUrl.appendingPathComponent("repo")
    private static  let gitDir = targetDirectory.appendingPathComponent(".git")
    private static  let cloneDevelpBranch = Arguments.contains(.develop)
    private static  let fileManager = FileManager.default

    static func execute(command: String) {
        var result: (output: String?, exitCode: Int32)
        result = call(command:command)
        guard result.exitCode == 0 else { exitWithError(result.output, code: result.exitCode) }
        print(result.output ?? "")
    }

    static func update() throws {
        let repoDirExists = fileManager.fileExists(atPath: Self.targetDirectory.path, isDirectory: nil)
        if !repoDirExists {
            try fileManager.createDirectory(at: Self.targetDirectory, withIntermediateDirectories: true, attributes: nil)
        } else {
            let gitDirExists = fileManager.fileExists(atPath: gitDir.path, isDirectory: nil)
            let command: String
            if gitDirExists {
                let branch = cloneDevelpBranch ? "develop" : ""
                command = "git checkout \(branch)"
            } else {
                let branch = cloneDevelpBranch ? "--branch develop" : ""
                command = "git clone \(branch)\(Self.repo)"
            }
            execute(command: "cd \(Self.targetDirectory.path)")
            execute(command: "pwd")
            execute(command: command)
            execute(command: "cd \(scriptPath)")
        }
    }
}



struct TemplateInfo: Codable {
    static let plistEncoder: PropertyListEncoder = {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        return encoder
    }()

    static let plistDecoder: PropertyListDecoder = {
        let decoder = PropertyListDecoder()
        return decoder
    }()

    static let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()

    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    enum CodingKeys: String, CodingKey {
        case defaultCompletionName = "DefaultCompletionName"
        case descriptionText = "Description"
        case kind = "Kind"
        case options = "Options"
        case platforms = "Platforms"
        case sortOrder = "SortOrder"
        case summary = "Summary"
    }

    var defaultCompletionName: String?
    var descriptionText: String?
    var kind: Kind = .fileTemplate
    var options: [Option]?
    var platforms: [Platform]? = [.iphoneos]
    var sortOrder: Int?
    var summary: String?
}

extension TemplateInfo {
    struct Kind: RawRepresentable, ExpressibleByStringLiteral, Codable {
        static let fileTemplate: Self = "Xcode.IDEKit.TextSubstitutionFileTemplateKind"
        static let knownValues: [Self] = [.fileTemplate]

        let rawValue: String
        init(rawValue: String) {
            assert(Self.knownValues.contains(where: { $0.rawValue == rawValue }), "Unknonw value of \(Self.self)")
            self.rawValue = rawValue
        }
        init(stringLiteral value: StringLiteralType) { self.init(rawValue: value) }
    }

    struct OptionType: RawRepresentable, ExpressibleByStringLiteral, Codable {
        static let text: Self = "text"
        static let `static`: Self = "static"
        static let `class`: Self = "class"
        static let knownValues: [Self] = [.text, .static, .class]

        let rawValue: String
        init(rawValue: String) {
            assert(Self.knownValues.contains(where: { $0.rawValue == rawValue }), "Unknonw value of \(Self.self)")
            self.rawValue = rawValue
        }
        init(stringLiteral value: StringLiteralType) { self.init(rawValue: value) }
    }

    struct Platform: RawRepresentable, ExpressibleByStringLiteral, Codable {
        static let iphoneos: Self = "com.apple.platform.iphoneos"
        static let knownValues: [Self] = [.iphoneos]

        let rawValue: String
        init(rawValue: String) {
            assert(Self.knownValues.contains(where: { $0.rawValue == rawValue }), "Unknonw value of \(Self.self)")
            self.rawValue = rawValue
        }
        init(stringLiteral value: StringLiteralType) { self.init(rawValue: value) }
    }

    struct Option: Codable {
        enum CodingKeys: String, CodingKey {
            case identifier = "Identifier"
            case `default` = "Default"
            case descriptionText = "Description"
            case name = "Name"
            case notPersisted = "NotPersisted"
            case required = "Required"
            case type = "Type"
            case values = "Values"
            case fallbackHeader = "FallbackHeader"
        }

        var identifier: String
        var name: String?
        var descriptionText: String?
        var `default`: String? = "Some"
        var notPersisted: Bool?
        var required: Bool?
        var type: OptionType?
        var values: [String]?
        var fallbackHeader: String?

        var variablePlaceholder: String { "___VARIABLE_\(identifier):identifier___" }

        static func inputOption(identifier: String, name: String = "File name:", defaultValue: String = "Some", description: String = "The name of the file to create") -> Option {
            Option(identifier: identifier, name: name, descriptionText: description, default: defaultValue, notPersisted: true, required: true, type: .text)
        }

        static func staticOption(identifier: String, name: String, description: String? = nil, defaultValue: String) -> Option {
            Option(identifier: identifier, name: name, descriptionText: description, default: defaultValue, required: true, type: .static)
        }

        static func staticHiddenOption(identifier: String, defaultValue: String) -> Option {
            Option(identifier: identifier, default: defaultValue, type: .static)
        }

        static func classOption(identifier: String, defaultValue: String? = nil, values: [String], fallbackHeader: String = "#import &lt;Foundation/Foundation.h&gt;") -> Option {
            Option(identifier: identifier, default: defaultValue ?? values.first, type: .class, values: values)
        }

        static func viewControllerClassOption() -> Option {
            let values = ["UIViewController", "UITableViewController", "UICollectionViewController", "UITabBarController", "UINavigationController"]
            return Option(identifier: "viewControllerSubclass", name: "Subclass of:", default: values.first, type: .class, values: values, fallbackHeader: "#import &lt;UIKit/UIKit.h&gt;")
        }
    }
}


// MARK: - MAIN -

try GitRepo.update()

let templateInfo = scriptDirUrl
    .appendingPathComponent("repo")
    .appendingPathComponent("CleanSwift/Source")
    .appendingPathComponent("Scene.xctemplate")
    .appendingPathComponent("TemplateInfo.plist")
let data = try Data(contentsOf: templateInfo)

let info = try TemplateInfo.plistDecoder.decode(TemplateInfo.self, from: data)
//try generateCommonTemplates(installDir: generatedTemplatesDir, generateOnlySourceFile: false)
print(info)

// MARK: - END of MAIN -

// https://stackoverflow.com/questions/48333607/how-to-launch-an-external-process
// https://bash.0x1fff.com/na_poczatek/index.html
// How to include .swift file from other .swift file in an immediate mode?:
// https://stackoverflow.com/a/36265686/1776859
// https://stackoverflow.com/a/27437969/1776859

// https://nshipster.com/swift-sh/
// [Run swift script from Xcode iOS project as build phase](https://stackoverflow.com/a/30983482/1776859)
// [Issue: NSTask /bin/echo: /bin/echo: cannot execute binary file](https://stackoverflow.com/a/36827499/1776859)

//enum Shell {
//    /// `/usr/bin/env sh`
//    static let `default` = Env.sh
//
//    static let sh = "/usr/bin/sh"
//    static let bash = "/bin/bash"
//
//    // https://unix.stackexchange.com/q/29608
//    enum Env {
//        static let sh = "/usr/bin/env sh"
//    }
//}

// MARK: - CommandLine Helpers

func showInFinder(url: URL?){
    guard let url = url else { return }
    NSWorkspace.shared.activateFileViewerSelecting([url])
}

let standardInput = FileHandle.standardInput
let standardOutput = FileHandle.standardOutput
//let standardError = FileHandle.standardError

func exitWithError(_ message: String?, code: Int32 = 1) -> Never {
    if let message = message, let output = message.data(using: .utf8) {
        standardOutput.write(output)
    }
    exit(code)
}

func exitSuccessfully(_ output: String) -> Never {
    if let output = output.data(using: .utf8) {
        standardOutput.write(output)
    }
    exit(0)
}

// MARK: - Shell

struct Shell {
    /// `/usr/bin/env sh`
    static let `default` = Env.sh

    /// `/usr/bin/sh -l`
    static let sh = Shell(path: "/usr/bin/sh", args: ["-l"])

    /// `/bin/bash -l`
    static let bash = Shell(path: "/bin/bash", args: ["-l"])

    // https://unix.stackexchange.com/q/29608
    enum Env {
        /// `/usr/bin/env sh -l`
        static let sh = Shell(path: "/usr/bin/env", args: ["sh", "-l"])
    }

    let path: String
    let args: [String]
}

@discardableResult
private func startProcess(launchPath: String, arguments: [String]) -> (output: String?, exitCode: Int32) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: launchPath)
    task.arguments = arguments

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe

    do {
        try task.run()
    } catch {
        // handle errors
        print("Error: \(error.localizedDescription)")
        return (nil, 1)
    }

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)
    task.waitUntilExit()
    
    let exitCode = task.terminationStatus
    print("Output:\n", output ?? "", "exit code:", exitCode)
    return (output, exitCode)
}

private func commandComponents(command: String) -> (path: String, args: [String])? {
    var components = command.components(separatedBy: " ")
    guard let launchPath = components.first else {
        return nil
    }
    components.removeFirst()
    return (launchPath, components)
}

/// Wrapper function for shell commands.
/// Wrapper function for shell commands.
/// Must provide full path to executable.
/// - parameter shell: executable path to the shell, can contain its arguments, default to `Shell.default`
/// - parameter arguments: command and its arguments
/// - returns: Tuple containing output and exit status
@discardableResult
func call(_ shell: Shell = Shell.default, arguments: [String]) -> (output: String?, exitCode: Int32) {
    var arguments = arguments
    guard let command = arguments.first else {
        return (nil, 1)
    }
    arguments.removeFirst()

    // see: [Why not use “which”? What to use then?](https://unix.stackexchange.com/a/85250/290567)
    let shellArgs = shell.args + ["-c", "which \(command)"]
    let (optionalOutput, exitCode) = startProcess(launchPath: shell.path, arguments: shellArgs)
    guard exitCode == 0, let output = optionalOutput else { return (nil, exitCode) }
    
    let commandPath = output.trimmingCharacters(in: .whitespacesAndNewlines)
    print("Command: \(commandPath), arguments: \(arguments.joined(separator: ", "))")
    return startProcess(launchPath: commandPath, arguments: arguments)
}

@discardableResult
func call(_ shell: Shell = Shell.default, arguments: String...) -> (output: String?, exitCode: Int32) {
    return call(shell, arguments: arguments)
}

/// Run sell command from string
///
/// Example: `shell("ls -la")`
/// - parameter shell: shell descriptior
/// - parameter command: command with parameters like `echo $PATH`, `ls -l`, etc.
@discardableResult
func call(_ shell: Shell = Shell.default, command: String) -> (output: String?, exitCode: Int32) {
    return call(shell, arguments: command.components(separatedBy: " "))
}

