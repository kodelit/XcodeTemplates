import UIKit

/// External interface for the Scene
public protocol ___VARIABLE_sceneName___Module {
    static func create() -> ___VARIABLE_sceneName___Module
}

/// Internal API of the UI of the scene
protocol ___VARIABLE_sceneName___UserInterfaceLogic {
    func handle(request: ModuleRequest)
}

/// Root module class. It is your module/manager/coordinator implementing the module interface
public class ___VARIABLE_sceneName___: ___VARIABLE_sceneName___Module {
    typealias Router = (NSObjectProtocol & ___VARIABLE_sceneName___Routing & ___VARIABLE_sceneName___DataPassing)

    private var router: Router?

    /// An Interactor in case of complex module or a View Model in case of simple module.
    private var userInterface: ___VARIABLE_sceneName___UserInterfaceLogic?

    static func create() -> ___VARIABLE_sceneName___Module {
        let module = ___VARIABLE_sceneName___Module()

        return module
    }
}

extension ___VARIABLE_sceneName___: ___VARIABLE_sceneName___Assembling {
    /// Assembles the scene by creating and assigning all components of the module and its dependencies.
    func assemble(_ viewController: ___VARIABLE_sceneName___ViewController) {
        // Basic assembling
        let router = ___VARIABLE_sceneName___Router()
        viewController.router = router
        router.viewController = viewController

        let interactor = ___VARIABLE_sceneName___Interactor()
        let presenter = ___VARIABLE_sceneName___Presenter()
        interactor.presenter = presenter
        presenter.view = viewController
        viewController.interactor = interactor
        router.dataStore = interactor

        // or
        //let viewModel = ___VARIABLE_sceneName___ViewModel()
        //viewController.viewModel = viewModel
        //router.dataStore = viewModel

        // Dependencies
        //let worker = ___VARIABLE_sceneName___Worker()
        //interactor.worker = worker

        self.router = router
        self.userInterface = interactor
    }
}
