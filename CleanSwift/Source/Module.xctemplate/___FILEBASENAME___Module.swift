import Foundation

// MARK: - Module

public enum ___VARIABLE_moduleName___Module {
    internal static var businessLogic: ___VARIABLE_moduleName___ModuleBusinessLogic?
    internal static var delegate: ___VARIABLE_moduleName___ModuleDelegate?

    /// Configures the default module.
    public static func configure(delegate: ___VARIABLE_moduleName___ModuleDelegate? = nil) {
        self.configure(logic: ___VARIABLE_moduleName___Service(), delegate: delegate)
    }

    /// Internal configure method allowing to setup dependencies for tests.
    internal static func configure(logic: ___VARIABLE_moduleName___ModuleBusinessLogic, delegate: ___VARIABLE_moduleName___ModuleDelegate?) {
        self.businessLogic = logic
        self.delegate = delegate
    }

    /// This method creates the instance of the module interface.
    ///
    /// - returns: An instance of the default module controller allowing data access and loading/managing the scenes of the module
    public static func defaultController() -> ___VARIABLE_moduleName___ModuleAccessController { ___VARIABLE_moduleName___Controller() }
}

// MARK: - Module Data Source (data pulling)

public protocol ___VARIABLE_moduleName___ModuleDelegate: class {
    func dataRequest(_ request: ___VARIABLE_moduleName___Module.Request.Data)
}
