#!/usr/bin/swift
//___FILEHEADER___

import Foundation
import Cocoa

let scriptPath: String = CommandLine.arguments.first ?? ""
let scriptDirUrl = URL(fileURLWithPath: scriptPath).deletingLastPathComponent()

// MARK: - Arguments parsing

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
    call(shell, arguments: arguments)
}

/// Run sell command from string
///
/// Example: `shell("ls -la")`
/// - parameter shell: shell descriptior
/// - parameter command: command with parameters like `echo $PATH`, `ls -l`, etc.
@discardableResult
func call(_ shell: Shell = Shell.default, command: String) -> (output: String?, exitCode: Int32) {
    call(shell, arguments: command.components(separatedBy: " "))
}

// MARK: - MAIN -

// MARK: Resolving the symbolic path
//let path: String = "~/Library/Developer/Xcode/Templates/File Templates/"
//let templatesDir = URL(fileURLWithPath: NSString(string: path).expandingTildeInPath,
//                       relativeTo: URL(fileURLWithPath: NSOpenStepRootDirectory()))

// MARK: Executing another script/command line app
//let commandPath = scriptDirUrl.path + "/CleanSwift/install"
//printOutput("Command: \(commandPath)")
//let (output, exitCode) = call(command: commandPath)
//if exitCode != 0 {
//    exitWithError(output, code: exitCode)
//} else if let output = output {
//    printOutput(output)
//}
