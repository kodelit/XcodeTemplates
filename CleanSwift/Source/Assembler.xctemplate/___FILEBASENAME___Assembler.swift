import UIKit

/// Responsible for assembling the scene and dependency injection.
///
/// The assembler is an optional component which might be skipped in favour of the Router.
/// In that case router should take the tasks of the assembler.
struct ___VARIABLE_sceneName___Assembler: ___VARIABLE_sceneName___Assembling {

    /// Assembles the scene by creating and assigning all components of the module and its dependencies.
    func assemble(_ viewController: ___VARIABLE_sceneName___ViewController) {
        // Basic assembling
        let interactor = ___VARIABLE_sceneName___Interactor()
        let presenter = ___VARIABLE_sceneName___Presenter()
        let router = ___VARIABLE_sceneName___Router()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

        // Dependencies
        //let worker = IncomingCallWorker()
        //interactor.worker = worker
    }
}
