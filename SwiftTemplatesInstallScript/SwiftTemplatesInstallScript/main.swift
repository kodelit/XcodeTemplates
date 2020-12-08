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
var dirUrl = URL(fileURLWithPath: scriptPath)
dirUrl.deleteLastPathComponent()
let fileManager = FileManager.default

enum Option: String, ExpressibleByStringLiteral {
    static let help: Option = "--help"
    case unknown
    
    public init(stringLiteral value: String) {
        self = value.isEmpty ? .unknown : .init
    }
}

enum Argument {
    static let arguments = CommandLine.arguments
    
    func contains(_ argument: Option) {
        arguments.contains(Options.help)
    }
}

let isRequestingHelp = arguments.contains(Options.help)

//let path: String = "~/Library/MobileDevice/Provisioning Profiles/"
//let profilesDirAbsolutPath = NSString(string: path).expandingTildeInPath
//print("Path", profilesDirAbsolutPath)


let sourceDir = dirUrl.appendingPathComponent("Source")
let generatedTemplatesDir = dirUrl.appendingPathComponent("Output")

class Architectures {
    let sourceDir = dirUrl.appendingPathComponent("Source")
    let generatedTemplatesDir = dirUrl.appendingPathComponent("Output")
}

class CleanSwift {
    static let rootDir = dirUrl.appendingPathComponent("Source")
    static var sourceDir = rootDir.appendingPathComponent("Source")
}

if fileManager.fileExists(atPath: generatedTemplatesDir.absoluteString) {
    try fileManager.removeItem(at: generatedTemplatesDir)
}

var fileName = ""
var fileNameWithoutExtension = ""

let commentFileUrl = sourceDir.appendingPathComponent("SOURCE_FILE_TOP_COMMENT.swift")
let sourceFileTopComment = try String(contentsOf: commentFileUrl, encoding: .utf8)

let commonTemplatesDirNames = ["Assembler.xctemplate", "Interactor.xctemplate", "Models.xctemplate", "Presenter.xctemplate", "Router.xctemplate", "Worker.xctemplate"]
let viewControllerNames = ["UICollectionViewController", "UITableViewController", "UIViewController"]

let sceneTemplateDirName = "Scene.xctemplate"
let sceneTemplateSourceDir = sourceDir.appendingPathComponent(sceneTemplateDirName)
let viewControllerTemplateDirName = "View Controller.xctemplate"
let viewControllerSourceDir = sourceDir.appendingPathComponent(viewControllerTemplateDirName)
let viewControllerSourceFile = viewControllerSourceDir
    .appendingPathComponent("UIViewController")
    .appendingPathComponent("___FILEBASENAME___ViewController.swift")
let testsTemplatesDirName = "Unit Tests.xctemplate"

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
        let templateSourceDir = sourceDir.appendingPathComponent(templateDirName)
        var templateTargetDir = installDir

        if !generateOnlySourceFile {
            templateTargetDir.appendPathComponent(templateDirName)

            if fileManager.fileExists(atPath: templateTargetDir.absoluteString) {
                try fileManager.removeItem(at: templateTargetDir)
            }
            try fileManager.createDirectory(at: templateTargetDir, withIntermediateDirectories: true, attributes: nil)
            try fileManager.copyItem(at: sourceDir, to: installDir)
        }

        if let files = try? FileManager.default.contentsOfDirectory(atPath: sourceDir.absoluteString) {
            let swiftFiles = files.filter { $0.hasSuffix(".swift") }

            try swiftFiles.forEach { (path) in
                guard let url = URL(string: path) else { return }
                try generate(sourceFile: url, targetDir: templateTargetDir)
            }
        }
    }
}

//try generateCommonTemplates(installDir: generatedTemplatesDir, generateOnlySourceFile: false)




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

func exitWithError(_ message: String) -> Never {
    if let output = message.data(using: .utf8) {
        standardOutput.write(output)
    }
    exit(1)
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
func shell(shell: Shell = Shell.default, arguments: [String]) -> (output: String?, exitCode: Int32) {
    var arguments = arguments
    guard let command = arguments.first else {
        return (nil, 1)
    }
    arguments.removeFirst()

    let shellArgs = shell.args + ["-c", "which \(command)"]
    let (optionalOutput, exitCode) = startProcess(launchPath: shell.path, arguments: shellArgs)
    guard exitCode == 0, let output = optionalOutput else { return (nil, exitCode) }
    
    let commandPath = output.trimmingCharacters(in: .whitespacesAndNewlines)
    return startProcess(launchPath: command, arguments: arguments)
}

@discardableResult
func shell(shell: String = Shell.default, arguments: String...) -> (output: String?, exitCode: Int32) {
    return shell(shell: shell, arguments: arguments)
}

/// Run sell command from string
///
/// Example: `shell("ls -la")`
/// - parameter shell: shell descriptior
/// - parameter command: command with parameters like `echo $PATH`, `ls -l`, etc.
func shell(shell config: Shell = Shell.default, command: String) -> (output: String?, exitCode: Int32) {
    return shell(shell: config, arguments: command.components(separatedBy: " "))
}
