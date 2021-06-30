#!/usr/bin/swift
// This code is distributed under the terms and conditions of the MIT License:

// Copyright © 2020-2021 kodelit.
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

let scriptPath: String = CommandLine.arguments.first ?? ""
let scriptDirUrl = URL(fileURLWithPath: scriptPath).deletingLastPathComponent()
let fileManager = FileManager.default

// MARK: - Arguments parsing

enum Environment {
    private static let dictionary: [String : String] = ProcessInfo.processInfo.environment
}

enum Arguments {
    static let arguments: [String] = CommandLine.arguments
    
    /// - parameter argument: An option after which should be provided some custom value, eg. some path to the resource
    /// - returns: The value after the given `argument` if the next value is not a known option.
    static func value(for argument: Option) -> String? {
        if let long = argument.key,
           let index = Self.arguments.firstIndex(of: long),
           arguments.count > index + 1 {
            let nextArg = arguments[index + 1]
            // if the `nextArg` is not a known Option it has to be the value for the given `argument`
            if Option(rawValue: nextArg) == nil {
                return nextArg
            }
        }
        return nil
    }

    static func contains(_ argument: Option) -> Bool {
        if let long = argument.key, Self.arguments.contains(long) {
            return true
        }
        return false
    }
}

enum Option: String, ExpressibleByStringLiteral {
    case help
    case develop
    case projectDir
    case unknown

    var key: String? {
        self == .unknown ? nil : "--\(rawValue)"
    }

    public init(stringLiteral value: String) {
        let value = value.trimmingCharacters(in: CharacterSet(charactersIn: "- "))
        self = Self(rawValue: value) ?? .unknown
    }
}

let isRequestingHelp = Arguments.contains(.help)
let projectDir = Arguments.value(for: .projectDir)

#if DEBUG
assert(projectDir != nil, "Missing debug argument --projectDir")
let rootDir = URL(fileURLWithPath: "\(projectDir ?? "")/../", relativeTo: URL(fileURLWithPath: NSOpenStepRootDirectory()))
#else
let rootDir = scriptDirUrl
#endif

// MARK: - Models

protocol TemlateDirectoryDefinition: CaseIterable, RawRepresentable {
    static var sourceDir: URL { get }
    static var outputDir: URL { get }
    static var installDir: URL { get }

    static var commonTemplates: [Self] { get }

    var name: String { get }
}

extension TemlateDirectoryDefinition where RawValue == String {
    static var templateDirectoryExtension: String { ".xctemplate" }
    var name: String { rawValue.capitalized + Self.templateDirectoryExtension }
    var sourceDir: URL { Self.sourceDir.appendingPathComponent(name) }
}

protocol Templates {
    associatedtype TemplateDir: TemlateDirectoryDefinition

    var sourceFileTopComment: String { get set }

    func generate() throws
    func install() throws
    func generateAndInstall() throws
}

extension Templates where TemplateDir.RawValue == String {
    func generateCommonTemplates(installDir: URL) throws {
        try TemplateDir.commonTemplates.forEach { (dir) in
            let templateSourceDir = dir.sourceDir
            let templateTargetDir = installDir.appendingPathComponent(dir.name)
            try resetTemplateDirectory(templateTargetDir)
            try copyNonSourceFiles(from: templateSourceDir, to: templateTargetDir)
            try generateSourceFiles(sourceDir: templateSourceDir, targetDir: templateTargetDir)
        }
    }

    /// Removes and creates again the directory
    func resetTemplateDirectory(_ dir: URL) throws {
        guard TemplateDir.allCases.contains(where: { (knownDir) -> Bool in
            dir.path.range(of: knownDir.name) != nil
        }) else { return }
        if fileManager.fileExists(atPath: dir.path) {
            try fileManager.removeItem(at: dir)
        }
        try fileManager.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
    }

    func generateSourceFiles(sourceDir: URL, targetDir: URL) throws {
        try fileManager.createDirectory(at: targetDir, withIntermediateDirectories: true, attributes: nil)
        if let files = try? fileManager.subpathsOfDirectory(atPath: sourceDir.path) {
            let swiftFiles = files.filter { $0.hasSuffix(".swift") }
            try swiftFiles.forEach { (path) in
                let sourceFile = URL(fileURLWithPath: path, relativeTo: sourceDir)
                var content = try String(contentsOf: sourceFile, encoding: .utf8)
                if !content.starts(with: "//") && !content.starts(with: "#") {
                    content = sourceFileTopComment + content
                }
                let targetFile = targetDir.appendingPathComponent(path)
                try content.write(to: targetFile, atomically: true, encoding: .utf8)
            }
        }
    }

    func copyNonSourceFiles(from sourceDir: URL, to targetDir: URL) throws {
        if let files = try? fileManager.contentsOfDirectory(atPath: sourceDir.path) {
            let swiftFiles = files.filter { !$0.hasSuffix(".swift") }
            try swiftFiles.forEach { (path) in
                let sourceFile = URL(fileURLWithPath: path, relativeTo: sourceDir)
                let fileName = sourceFile.lastPathComponent
                let targetFile = targetDir.appendingPathComponent(fileName)
                try fileManager.copyItem(at: sourceFile, to: targetFile)
            }
        }
    }

    func generate() throws {
        let outputDir = TemplateDir.outputDir
        if fileManager.fileExists(atPath: outputDir.path) {
            try fileManager.removeItem(at: outputDir)
        }
        try generateCommonTemplates(installDir: outputDir)
    }

    func install() throws {
        let outputDir = TemplateDir.outputDir
        let installDir = TemplateDir.installDir
        // create intermediate directories if does not exists
        try fileManager.createDirectory(at: installDir, withIntermediateDirectories: true, attributes: nil)
        if fileManager.fileExists(atPath: installDir.path) {
            try fileManager.removeItem(at: installDir)
        }
        try fileManager.copyItem(at: outputDir, to: installDir)
    }

    func generateAndInstall() throws {
        try generate()
        try install()
    }
}

// MARK: - Templates -

class CodeBase: Templates {
    struct TemplateDir: TemlateDirectoryDefinition {
        static var allCases: [Self] = commonTemplates
        let rawValue: String
        init(rawValue: String) { self.rawValue = rawValue }

        /// Single file templates
        ///
        /// The top comment is added to every `.swift` source file and the templates are simply copied to the install directory.
        static let commonTemplates: [TemplateDir] = {
            if let files = try? fileManager.contentsOfDirectory(atPath: sourceDir.path) {
                let swiftFiles = files.filter { $0.hasSuffix(templateDirectoryExtension) }
                return swiftFiles.map({ (path) -> TemplateDir in
                    let templateName = URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent
                    return TemplateDir(rawValue: templateName)
                })
            }
            return []
        }()

        static var sourceDir = URL(fileURLWithPath: "CodeBase/Source/", relativeTo: rootDir)
        static var outputDir = URL(fileURLWithPath: "CodeBase/Output/", relativeTo: rootDir)

        private static let installPath = "Library/Developer/Xcode/Templates/File Templates/Code Base (kodelit)/"
        static var installDir = URL(fileURLWithPath: installPath,
                                    relativeTo: URL(fileURLWithPath: NSHomeDirectory()))
    }

    var sourceFileTopComment: String = "//___FILEHEADER___\n"
}

class CleanSwift: Templates {
    public enum TemplateDir: String, TemlateDirectoryDefinition {
        case assembler, interactor, presenter, models, router, worker, scene
        case viewModel = "View Model"
        case viewController = "View Controller"
        case unitTests = "Unit Tests"
        case cleanSwiftSupport = "Clean Swift Support File"

        /// Single file templates
        ///
        /// The top comment is added to every `.swift` source file and the templates are simply copied to the install directory.
        static let commonTemplates: [TemplateDir] = [.assembler, .interactor, .presenter, .models, .router, .worker, .viewModel, .cleanSwiftSupport]
        /// Components of the Scene template
        ///
        /// Source files combined in to the one template.
        static let sceneTemplates: [TemplateDir] = [.interactor, .presenter, .models, .router, .worker, .viewModel, .viewController]

        static var sourceDir = URL(fileURLWithPath: "CleanSwift/Source/", relativeTo: rootDir)
        static var outputDir = URL(fileURLWithPath: "CleanSwift/Output/", relativeTo: rootDir)

        private static let installPath = "Library/Developer/Xcode/Templates/File Templates/Clean Swift (kodelit)/"
        static var installDir = URL(fileURLWithPath: installPath,
                                    relativeTo: URL(fileURLWithPath: NSHomeDirectory()))

        static var commentFile: URL {
            sourceDir
                .appendingPathComponent("SOURCE_FILE_TOP_COMMENT")
                .appendingPathExtension("swift")
        }

        var name: String { rawValue.capitalized + ".xctemplate" }
        var sourceDir: URL { Self.sourceDir.appendingPathComponent(name) }
    }

    enum ViewControllerBaseClass: String, CaseIterable {
        case viewController = "UIViewController"
        case tableViewController = "UITableViewController"
        case collectionViewController = "UICollectionViewController"

        var name: String { rawValue }
    }

    enum LogicTypeChoice: String, CaseIterable {
        case viewModel = "ViewModel"
        case presenterInteractor = "Presenter-Interactor"
    }

    enum Checkboxes: String, CaseIterable {
        case withWorker = "Worker"
    }

    var sourceFileTopComment: String = (try? String(contentsOf: TemplateDir.commentFile, encoding: .utf8)) ?? "//___FILEHEADER___\n"

    private func generateViewControllerTemplate(installDir: URL) throws {
        let dir = TemplateDir.viewController
        let templateSourceDir = dir.sourceDir
        let templateTargetDir = installDir.appendingPathComponent(dir.name)
        try resetTemplateDirectory(templateTargetDir)
        try copyNonSourceFiles(from: templateSourceDir, to: templateTargetDir)

        /// Generate for all cases because copied sources of swift files have no top comment
        try ViewControllerBaseClass.allCases.forEach({ (baseClass) in
            try LogicTypeChoice.allCases.forEach({ (logicType) in
                let sourceDir = templateSourceDir.appendingPathComponent("\(ViewControllerBaseClass.viewController.rawValue)\(logicType.rawValue)")
                let targetDir = templateTargetDir.appendingPathComponent("\(baseClass.rawValue)\(logicType.rawValue)")
                try generateSourceFiles(sourceDir: sourceDir, targetDir: targetDir)
            })
        })
    }

    private func generateSceneTemplate(installDir: URL) throws {
        var templateSourceDir = TemplateDir.scene.sourceDir
        let templateTargetDir = installDir.appendingPathComponent(TemplateDir.scene.name)
        try resetTemplateDirectory(templateTargetDir)
        try copyNonSourceFiles(from: templateSourceDir, to: templateTargetDir)

        try TemplateDir.sceneTemplates.forEach { (dir) in
            templateSourceDir = dir.sourceDir

            try ViewControllerBaseClass.allCases.forEach({ (baseClass) in
                try LogicTypeChoice.allCases.forEach({ (logicType) in
                    try Checkboxes.allCases.forEach({ (checkbox) in
                        // For each checkbox option
                        try ["", checkbox.rawValue].forEach { (suffix) in
                            var sourceDir = templateSourceDir
                            switch dir {
                            case .worker:
                                guard suffix == Checkboxes.withWorker.rawValue else { return }
                            case .viewModel:
                                guard logicType == .viewModel else { return }
                            case .presenter, .interactor:
                                guard logicType == .presenterInteractor else { return }
                            case .viewController:
                                sourceDir = templateSourceDir.appendingPathComponent("\(ViewControllerBaseClass.viewController.rawValue)\(logicType.rawValue)")
                            case .models, .router:
                                sourceDir = templateSourceDir.appendingPathComponent(logicType.rawValue)
                            case .scene, .assembler, .cleanSwiftSupport, .unitTests:
                                // Ignoring them explicitly (one by one) will make the compiler to alarm the developer that every newly added template has to be supported here.
                                break
                            }
                            let targetDir = templateTargetDir.appendingPathComponent("\(baseClass.rawValue)\(logicType.rawValue)\(suffix)")
                            try generateSourceFiles(sourceDir: sourceDir, targetDir: targetDir)
                        }
                    })
                })
            })
        }
    }

    func generate() throws {
        let outputDir = TemplateDir.outputDir
        if fileManager.fileExists(atPath: outputDir.path) {
            try fileManager.removeItem(at: outputDir)
        }
        try generateViewControllerTemplate(installDir: outputDir)
        try generateCommonTemplates(installDir: outputDir)
        try generateSceneTemplate(installDir: outputDir)
    }
}

// MARK: - Repo -

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
        printOutput(result.output ?? "")
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

func printOutput(_ output: String) {
    if let output = "\(output)\n".data(using: .utf8) {
        print(output)
        standardOutput.write(output)
    }
}

func exitWithError(_ output: String?, code: Int32 = 1) -> Never {
    if let message = output {
        printOutput(message)
    }
    exit(code)
}

func exitSuccessfully(_ output: String) -> Never {
    printOutput(output)
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
        var output: String?
        if #available(OSX 10.15.4, *) {
            if let data = try pipe.fileHandleForReading.readToEnd() {
                output = String(data: data, encoding: .utf8)
            }
        } else {
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            output = String(data: data, encoding: .utf8)
        }
        task.waitUntilExit()

        let exitCode = task.terminationStatus
        output = output?.components(separatedBy: "\n").map({ "\t\($0)" }).joined(separator: "\n")
        printOutput(" Output:\n \(output ?? "")\n exit code: \(exitCode)")
        return (output, exitCode)
    } catch {
        // handle errors
        printOutput("Error: \(error.localizedDescription)")
        return (nil, 1)
    }
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
    printOutput("Command: \(commandPath), arguments: \(arguments.joined(separator: ", "))")
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

// MARK: - MAIN -

//try GitRepo.update()
//
//let templateInfo = scriptDirUrl
//    .appendingPathComponent("repo")
//    .appendingPathComponent("CleanSwift/Source")
//    .appendingPathComponent("Scene.xctemplate")
//    .appendingPathComponent("TemplateInfo.plist")
//let data = try Data(contentsOf: templateInfo)
//
//let info = try TemplateInfo.plistDecoder.decode(TemplateInfo.self, from: data)
//try generateCommonTemplates(installDir: generatedTemplatesDir, generateOnlySourceFile: false)
//printOutput(info)

//printOutput("=== Begining: \(scriptPath)")

let cleanSwiftTemplates = CleanSwift()
try cleanSwiftTemplates.generateAndInstall()
let codeBaseTemplates = CodeBase()
try codeBaseTemplates.generateAndInstall()

//printOutput("=== End: \(scriptPath)")
