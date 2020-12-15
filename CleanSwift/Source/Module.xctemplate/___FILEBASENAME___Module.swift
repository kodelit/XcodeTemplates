import Foundation

// MARK: - Module

public enum ___VARIABLE_moduleName___Module {
    internal static var service: ___VARIABLE_moduleName___Service?
    internal static var dataSource: ___VARIABLE_moduleName___DataSource?

    /// Configures the default module.
    public static func configure(dataSource: ___VARIABLE_moduleName___DataSource? = nil) {
        self.configure(service: ___VARIABLE_moduleName___Manager(), dataSource: dataSource)
    }

    /// Internal configure method allowing to setup dependencies for tests.
    internal static func configure(service: ___VARIABLE_moduleName___Service, dataSource: ___VARIABLE_moduleName___DataSource?) {
        self.service = service
        self.dataSource = dataSource
    }

    /// This method creates the instance of the module interface.
    ///
    /// - returns: An instance of the default module controller allowing data access and loading/managing the scenes of the module
    public static func defaultController() -> ___VARIABLE_moduleName___Controller { ___VARIABLE_moduleName___DefaultController() }
}

// MARK: - Module Data Source (data pulling)

public protocol ___VARIABLE_moduleName___DataSource {
    //func dataRequest(_ request: ___VARIABLE_moduleName___Module.Request)
}
