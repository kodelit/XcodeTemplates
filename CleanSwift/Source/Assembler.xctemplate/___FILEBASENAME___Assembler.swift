import UIKit

/// Responsible for assembling the scene and dependency injection.
struct ___VARIABLE_sceneName___Assembler: ___VARIABLE_sceneName___Assembling {
    /// Assembles the scene by creating and assigning all components of the module and its dependencies.
    func assemble(_ viewController: ___VARIABLE_sceneName___ViewController) {
        // Basic assembling
        let router = ___VARIABLE_sceneName___Router()
        viewController.router = router
        router.viewController = viewController

        let interactor = ___VARIABLE_sceneName___Interactor()
        let presenter = ___VARIABLE_sceneName___Presenter()
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.interactor = interactor
        router.dataStore = interactor

        // or
        //let viewModel = ___VARIABLE_sceneName___ViewModel()
        //viewController.viewModel = viewModel
        //router.dataStore = viewModel

        // Dependencies
        //let worker = ___VARIABLE_sceneName___Worker()
        //interactor.worker = worker
    }
}
