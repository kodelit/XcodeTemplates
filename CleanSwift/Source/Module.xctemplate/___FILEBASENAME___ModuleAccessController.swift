import Foundation

// MARK: - Module Access Controller (module interface)

/// Module access controller protocol.
///
/// An interface of an instance of the module controller allowing data access and loading/managing the scenes of the module
public protocol ___VARIABLE_moduleName___ModuleAccessController {
    typealias SomeData = Data

    /// Router allowing to manage the module scenes from outside of the module.
    ///
    /// - note: There is only one module router instance per module access controller.
    var moduleRouter: ___VARIABLE_moduleName___ModuleRouting { get }
    //var dataUpdateHandler: ((SomeData) -> Void)? { get set }

    /// Requests data from the local storage.
    //func requestLocalData(completion: @escaping (SomeData?) -> Void)
    /// Requests data by sending the request to the `___VARIABLE_moduleName___DataSource` if data soruce was set with the `___VARIABLE_moduleName___Module.configure(dataSource:)` method.
    //func requestDataUpdate(completion: ((SomeData?) -> Void)?)
    //func update(data: SomeData)
}

// MARK: - Module Interface Implementation (Default Module Access Controller)

/// Default implementation of the module controller.
internal class ___VARIABLE_moduleName___Controller {
    private let service: ___VARIABLE_moduleName___Service

    init() {
        guard let service = ___VARIABLE_moduleName___Module.service else {
            fatalError("[___VARIABLE_moduleName___DefaultController] Module not configured.")
        }
        self.service = service
    }

    // MARK: - ___VARIABLE_moduleName___Controller

    public let moduleRouter: ResidentsRouting
    public var dataUpdateHandler: (() -> Void)?
}

extension ___VARIABLE_moduleName___Controller: ___VARIABLE_moduleName___ModuleAccessController {
}
