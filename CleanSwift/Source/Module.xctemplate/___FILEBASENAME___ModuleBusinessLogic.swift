import Foundation

// MARK: - Module Business Logic Interface

/// Module business logic protocol.
///
/// An interface for the centralized/common logic for every scene and interface instance of the module.
/// - note: In most cases there should be only one instance of this interface in the application.
internal protocol ___VARIABLE_moduleName___ModuleBusinessLogic {
    typealias ModuleData = <#DataType#>

    func getData() -> ModuleData
    func update(with: ModuleData)
}

// MARK: - Default Implementation

/// The centralized/common logic for every scene and interface instance of the module.
///
/// It is the default implementation of the module logic protocol.
/// - warning: In most cases there should be only one instance of the Service in the application and it is implemented having that in mind.
class ___VARIABLE_moduleName___Service {
    private let updateHandlersList = HandlersList<___VARIABLE_moduleName___Controller>()

    init() {
        //reloadData()
    }

    // MARK: - Data Management

    //@OptionalUserDefault(key: "___VARIABLE_moduleName___.data")
    //private static var sharedData: Data?
    private var data = ModuleData()

    //private func reloadData() {
    //    let jsonEncoder = JSONDecoder()
    //    do {
    //        try write {
    //            guard let sharedData = Self.sharedData else { return }
    //            data = try jsonEncoder.decode(ModuleData.self, from: sharedData)
    //        }
    //    } catch {
    //        assertionFailure("[___VARIABLE_moduleName___Service] Could not restore the ModuleData form the storage.")
    //        DPrint("[___VARIABLE_moduleName___Service] Could not restore the ModuleData form the storage.")
    //    }
    //}

    // MARK: - Thread-Safe read/write

    /// Property access mutex
    private lazy var mutex = DispatchQueue(label: String(describing: ObjectIdentifier(self)), attributes: .concurrent)

    /// Method that should encapsulates any read operation from the shared storage or batch of operations, but only read operations, If any part of the transaction is a write operation you should use `write(_:)` method instead.
    private func read<T>(_ transaction: () -> T) -> T {
        mutex.sync(execute: transaction)
    }

    /// Safe write.
    ///
    /// If any part of the transaction is a write operation to the shared storage you should use this method to encapsulate such transaction.
    private func write<T>(_ transaction: @autoclosure () throws -> T) rethrows -> T {
        try mutex.sync(flags: .barrier) { try transaction() }
    }
}

/// Service protocol implementation
extension ___VARIABLE_moduleName___Service: ___VARIABLE_moduleName___ModuleBusinessLogic {
    func getData() -> ModuleData {
        var result = read { data }
        // some optional data modifications/filtering

        return result
    }

    func update(with data: ModuleData) {
        let jsonEncoder = JSONEncoder()
        do {
            let data: ModuleData = try write {
                var updatedData = self.data

                // Modify `updatedData` here

                Self.sharedData = try jsonEncoder.encode(updatedData)
                // if encoding fails data will remain unchanged
                self.data = updatedData
                return updatedData
            }
            self.updateHandlersList.handlers.forEach({ controller in
                controller.dataUpdateHandler?(data)
            })
        } catch {
            assertionFailure("[___VARIABLE_moduleName___Service] Could not update the ModuleData.")
            print("[___VARIABLE_moduleName___Service] Could not update the ModuleData.")
        }
    }
}
