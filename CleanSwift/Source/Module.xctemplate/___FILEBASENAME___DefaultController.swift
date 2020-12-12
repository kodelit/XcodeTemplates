import Foundation

// MARK: - Service (logic) Interface

/// An interface for the centralized/common logic for every scene and interface instance (___VARIABLE_moduleName___Controller) of the module.
///
/// - warning: In most cases there should be only one instance of the manager in the application and it is impemented having that in mind.
internal protocol ___VARIABLE_moduleName___Service {
}

internal protocol ___VARIABLE_moduleName___Routing {
    func startScene() -> UIViewController?
}

// MARK: - Module Interface Implementation

internal class ___VARIABLE_moduleName___DefaultController {
    private let service: ___VARIABLE_moduleName___Service
    private var sceneRouter: ___VARIABLE_moduleName___Routing?

    init() {
        guard let service = ___VARIABLE_moduleName___Module.service else {
            fatalError("[___VARIABLE_moduleName___DefaultController] Module not configured.")
        }
        self.service = service
    }

    // MARK: - ___VARIABLE_moduleName___Controller

    public var dataUpdateHandler: (() -> Void)?
}

extension ___VARIABLE_moduleName___DefaultController: ___VARIABLE_moduleName___Controller {
}
