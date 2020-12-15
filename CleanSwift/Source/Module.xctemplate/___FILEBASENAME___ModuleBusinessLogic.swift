import Foundation

// MARK: - Module Business Logic Interface

/// Module business logic protocol.
///
/// An interface for the centralized/common logic for every scene and interface instance (ResidentsController) of the module.
/// - note: In most cases there should be only one instance of the interface in the application.
internal protocol ___VARIABLE_moduleName___ModuleBusinessLogic {
}

// MARK: - Default Implementation

/// The centralized/common logic for every scene and interface instance of the module.
///
/// It is the default implementation of the module logic protocol.
/// - warning: In most cases there should be only one instance of the Service in the application and it is impemented having that in mind.
class ___VARIABLE_moduleName___Service {
    private let updateHandlersList = HandlersList<___VARIABLE_moduleName___Controller>()

    init() {
        //reloadData()
    }

    // MARK: - Data Management

    //@OptionalUserDefault(key: "___VARIABLE_moduleName___.data")
    //private static var sharedData: Data?
    private var data = ___VARIABLE_moduleName___Data()

    //private func reloadData() {
    //    let jsonEncoder = JSONDecoder()
    //    do {
    //        try write {
    //            guard let sharedData = Self.sharedData else { return }
    //            data = try jsonEncoder.decode(___VARIABLE_moduleName___Data.self, from: sharedData)
    //        }
    //    } catch {
    //        DPrint("Could not restore the ResidentsData form the storage.")
    //    }
    //}

    // MARK: - Thread-Safe read/write

    /// Property access mutex
    private lazy var mutex = DispatchQueue(label: String(describing: ObjectIdentifier(self)), attributes: .concurrent)

    private func read<T>(_ transaction: () -> T) -> T {
        mutex.sync(execute: transaction)
    }

    private func write<T>(_ transaction: () throws -> T) rethrows -> T {
        try mutex.sync(flags: .barrier) { try transaction() }
    }
}

/// Service protocol implementation
extension ___VARIABLE_moduleName___Service: ___VARIABLE_moduleName___ModuleBusinessLogic {
    //func getData() -> ___VARIABLE_moduleName___Data {
    //    var data = read { data }
    //
    //    // some optional data modifications/filtering
    //
    //    return data
    //}

    //func update(with: ...) {
    //    let jsonEncoder = JSONEncoder()
    //    do {
    //        let data: ___VARIABLE_moduleName___Data = try write {
    //            var udpatedData = self.data
    //
    //            // Modify `udpatedData` here
    //
    //            Self.sharedData = try jsonEncoder.encode(udpatedData)
    //            // if encoding fails data will remain unchanged
    //            self.data = udpatedData
    //            return udpatedData
    //        }
    //        self.updateHandlersList.handlers.forEach({ controller in
    //            controller.dataUpdateHandler?(data)
    //        })
    //    } catch {
    //        DPrint("Could not update the ___VARIABLE_moduleName___Data.")
    //    }
    //}
}
