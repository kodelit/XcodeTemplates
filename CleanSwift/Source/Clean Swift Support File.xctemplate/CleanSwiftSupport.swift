import Foundation

@propertyWrapper
public struct ReuiredOptional<T> {
    private let propertyName: String
    private let className: String?
    private let comment: String?
    private let file: StaticString
    private let line: UInt

    private var value: T?
    public var wrappedValue: T? {
        get { return value.assertExistence(propertyName: propertyName, className: className, file: file, line: line) }
        set { value = newValue }
    }

    public var isSet: Bool { value != nil }

    /// - parameter propertyName: Name of the required property. If provided will help to recognize the property in logs.
    /// - parameter className: if set there will be class name instead of file and line displayed in logs.
    /// - parameter comment: Addtional message to print with message.
    /// - parameter fileOrClassName: Name of the class or file where the property is declared. Default value is the file name.
    /// - parameter file: The file name to print with message. The default is the file where the property is declared.
    /// - parameter line: The line number to print along with message. The default is the line number where the property is declared.
    public init(_ propertyName: String = "", className: String? = nil, comment: String? = nil, file: StaticString = #fileID, line: UInt = #line) {
        self.propertyName = propertyName
        self.className = className
        self.comment = comment
        self.file = file
        self.line = line
    }
}

/// - parameter propertyName: Name of the required property. If provided will help to recognize the property in logs.
/// - parameter className: if set there will be class name instead of file and line displayed in logs.
/// - parameter comment: Addtional message to print with message.
/// - parameter fileOrClassName: Name of the class or file where the property is declared. Default value is the file name.
/// - parameter file: The file name to print with message. The default is the file where the method is called.
/// - parameter line: The line number to print along with message. The default is the line number where the method is called.
@discardableResult
public func assertExistence<T>(of value: T?, propertyName: String = "", className: String? = nil, comment: String? = nil, file: StaticString = #fileID, line: UInt = #line) -> T? {
    return value.assertExistence(propertyName: propertyName, className: className, comment: comment, file: file, line: line)
}

public extension Optional {
    /// - parameter propertyName: Name of the required property. If provided will help to recognize the property in logs.
    /// - parameter className: if set there will be class name instead of file and line displayed in logs.
    /// - parameter comment: Addtional message to print with message.
    /// - parameter fileOrClassName: Name of the class or file where the property is declared. Default value is the file name.
    /// - parameter file: The file name to print with message. The default is the file where the method is called.
    /// - parameter line: The line number to print along with message. The default is the line number where the method is called.
    @discardableResult
    func assertExistence(propertyName: String = "", className: String? = nil, comment: String? = nil, file: StaticString = #fileID, line: UInt = #line) -> Self {
        if case .none = self {
            let message = "[\(className ?? String(describing: file))\(className == nil ? ", line \(line)" : "")] Required optional property\(propertyName.isEmpty ? "" : " `\(propertyName)`") not set. Application might not work correctly.\n\(comment ?? "")"
            assertionFailure(message, file: file, line: line)
            print(message)
        }
        return self
    }
}
