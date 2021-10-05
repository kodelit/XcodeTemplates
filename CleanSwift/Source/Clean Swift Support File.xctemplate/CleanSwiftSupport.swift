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

// MARK: - Table View Model
// MARK: - Common TableViewModel

/// - note: This view model is ment to be used in tandem with the `CommonTableViewModel` as its `Section` type.
protocol CommonSectionViewModel {
    associatedtype Row

    /// - warning: You should not use this property directly, use helper methods of the `CommonTableViewModel` instead.
    var rows: [Row] { get }
}

/// Table view model protocol for common cases.
///
/// Common table view model, where:
///
/// - every section contains its rows models
/// - all sections are of the same type
/// - all rows are of the same type
protocol CommonTableViewModel {
    associatedtype Section
    associatedtype Row

    /// Sections view models.
    ///
    /// - warning: In order to be able to use all helper methods every section should conform to the `CommonSectionViewModel` protocol otherwise you might need to implement the methods by yourself.
    /// - warning: You should not use this property directly, use helper methods instead.
    var sections: [Section] { get }

    // MARK: Helper methods

    var numberOfSections: Int { get }
    func numberOfRowsInSection(index: Int) -> Int
    func section(for index: Int) -> Section?
    func row(for indexPath: IndexPath) -> Row?
    func row(at index: Int, in section: Int) -> Row?
}

extension CommonTableViewModel {
    var numberOfSections: Int {
        return sections.count
    }

    func section(for index: Int) -> Section? {
        guard index >= 0 && index < numberOfSections else { return nil }
        return sections[index]
    }
}

extension CommonTableViewModel where Section: CommonSectionViewModel {
    func numberOfRowsInSection(index: Int) -> Int {
        guard index >= 0 && index < numberOfSections else { return 0 }
        let sectionModel = section(for: index)
        return sectionModel?.rows.count ?? 0
    }

    func row(at index: Int, in sectionIndex: Int) -> Section.Row? {
        let sectionModel = section(for: sectionIndex)
        return sectionModel?.rows[index]
    }

    func row(for indexPath: IndexPath) -> Section.Row? {
        row(at: indexPath.row, in: indexPath.section)
    }
}

// MARK: - ComplexTableViewModel

/// - note: This view model is ment to be used in tandem with the `ComplexTableViewModel`.
protocol ComplexSectionViewModel {

    /// - warning: You should not use this property directly, use helper methods of the `ComplexTableViewModel` instead.
    var rows: [Any] { get }
}

/// Table view model protocol for complex cases.
///
/// Complex table view model, where:
///
/// - sections might be of different type
/// - rows might be of different type
protocol ComplexTableViewModel {
    /// Sections view models.
    ///
    /// - warning: In order to be able to use all helper methods every section should conform to the `ComplexSectionViewModel` protocol otherwise you might need to implement the methods by yourself.
    /// - warning: You should not use this property directly, use helper methods instead.
    var sections: [Any] { get }

    // MARK: Helper methods

    var numberOfSections: Int { get }
    /// - warning: The default implementation of this method works only if the section at `index` conforms to protocol `ComplexSectionViewModel`. In other cases you have to implement the method by yourself
    func numberOfRowsInSection(at index: Int) -> Int
    func section<T>(for index: Int) -> T?

    /// - warning: To simpify the code and to avoid returning optional value the default implementation doesn't check if the index exists,
    /// because table should never ask for not existing row if it uses method `numberOfRowsInSection(index:)` where the index is validated.
    func row<T>(for indexPath: IndexPath) -> T?

    /// - warning: To simpify the code and to avoid returning optional value the default implementation doesn't check if the index exists,
    /// because table should never ask for not existing row if it uses method `numberOfRowsInSection(index:)` where the index is validated.
    /// - warning: The default implementation of this method works only if the section at `section` index conforms to protocol `ComplexSectionViewModel`. In other cases you have to implement the method by yourself
    func row<T>(at index: Int, in section: Int) -> T?
}

extension ComplexTableViewModel {
    var numberOfSections: Int {
        return sections.count
    }

    func numberOfRowsInSection(at index: Int) -> Int {
        guard index >= 0 && index < numberOfSections else { return 0 }
        let sectionModel: ComplexSectionViewModel? = section(for: index)
        return sectionModel?.rows.count ?? 0
    }

    func section<T>(for index: Int) -> T? {
        guard index >= 0 && index < numberOfSections else { return nil }
        return sections[index] as? T
    }

    func row<T>(for indexPath: IndexPath) -> T? {
        row(at: indexPath.row, in: indexPath.section)
    }

    func row<T>(at index: Int, in sectionIndex: Int) -> T? {
        let sectionModel: ComplexSectionViewModel? = section(for: sectionIndex)
        return sectionModel?.rows[index] as? T
    }
}

// MARK: - SimpleTableViewModel

/// Table view model protocol for simplest cases.
///
/// Simple table view model, where:
///
/// - section might be a simple title of the section (String)
/// - all sections are of the same type
/// - all rows are of the same type
protocol SimpleTableViewModel {
    associatedtype Section
    associatedtype Row

    /// - warning: You should not use this property directly, use helper methods instead.
    var sections: [Section] { get }

    /// Rows array is a container (two dimensional array) containing a separate array of rows for every section.
    ///
    /// - warning: You should not use this property directly, use helper methods instead.
    var rows: [[Row]] { get }

    // MARK: Helper methods

    var numberOfSections: Int { get }
    func numberOfRowsInSection(index: Int) -> Int
    func section(for index: Int) -> Section?

    /// - warning: To simpify the code and to avoid returning optional value the default implementation doesn't check if the index exists,
    /// because table should never ask for not existing row if it uses method `numberOfRowsInSection(index:)` where the index is validated.
    func row(for indexPath: IndexPath) -> Row

    /// - warning: To simpify the code and to avoid returning optional value the default implementation doesn't check if the index exists,
    /// because table should never ask for not existing row if it uses method `numberOfRowsInSection(index:)` where the index is validated.
    func row(at index: Int, in section: Int) -> Row
}

extension SimpleTableViewModel {
    @inline(__always) private func checkDataConsistency() {
        assert(sections.count == rows.count, "Table data are inconsistent. Sections count (sections.count): \(sections.count) is not the same as the number of the goups of the rows (rows.count): \(rows.count)")
    }

    var numberOfSections: Int {
        checkDataConsistency()
        return rows.count
    }

    func numberOfRowsInSection(index: Int) -> Int {
        checkDataConsistency()
        guard index >= 0 && index < rows.count else { return 0 }
        return rows[index].count
    }

    func section(for index: Int) -> Section? {
        checkDataConsistency()
        guard index >= 0 && index < numberOfSections else { return nil }
        return sections[index]
    }

    func row(for indexPath: IndexPath) -> Row {
        row(at: indexPath.row, in: indexPath.section)
    }

    func row(at index: Int, in section: Int) -> Row {
        checkDataConsistency()
        return rows[section][index]
    }
}

// MARK: - SingleSectionTableViewModel

protocol SingleSectionTableViewModel {
    associatedtype Row

    /// Rows array is a container (two dimensional array) containing a separate array of rows for every section.
    ///
    /// - warning: You should not use this property directly, use helper methods instead.
    var rows: [Row] { get }

    var numberOfSections: Int { get }
    func numberOfRowsInSection(index: Int) -> Int

    /// - warning: To simpify the code and to avoid returning optional value the default implementation doesn't check if the index exists,
    /// because table should never ask for not existing row if it uses method `numberOfRowsInSection(index:)` where the index is validated.
    func row(for indexPath: IndexPath) -> Row

    /// - warning: To simpify the code and to avoid returning optional value the default implementation doesn't check if the index exists,
    /// because table should never ask for not existing row if it uses method `numberOfRowsInSection(index:)` where the index is validated.
    func row(at index: Int) -> Row
}

extension SingleSectionTableViewModel {
    var numberOfSections: Int { return 1 }

    func numberOfRowsInSection(index: Int) -> Int {
        guard index == 0 else { return 0 }
        return rows.count
    }

    func row(for indexPath: IndexPath) -> Row {
        row(at: indexPath.row)
    }

    func row(at index: Int) -> Row {
        return rows[index]
    }
}
