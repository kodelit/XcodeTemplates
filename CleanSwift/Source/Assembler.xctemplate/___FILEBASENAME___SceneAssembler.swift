import UIKit

/// Responsible for assembling the scene and dependency injection.
class ___VARIABLE_sceneName___SceneAssembler: ___VARIABLE_sceneName___SceneAssembling {
    private(set) var isSceneAssembled = false

    /// Assembles the scene by creating and assigning all components of the scene and its dependencies if not done already.
    func assembleIfNeeded(_ viewController: ___VARIABLE_sceneName___SceneViewController) {
        guard !isSceneAssembled else { return }
        isSceneAssembled = true

        // Basic assembling
        let router = ___VARIABLE_sceneName___Router()
        viewController.router = router // strong
        router.viewController = viewController // weak

        let interactor = ___VARIABLE_sceneName___SceneInteractor()
        let presenter = ___VARIABLE_sceneName___ScenePresenter()
        interactor.presenter = presenter // strong
        presenter.view = viewController // weak
        presenter.router = router // weak
        viewController.interactor = interactor // strong
        router.dataStore = interactor // strong
        // or
        //let viewModel = ___VARIABLE_sceneName___SceneViewModel()
        //viewModel.view = viewController // weak
        //viewController.viewModel = viewModel // strong
        //viewModel.router = router // weak
        //router.dataStore = viewModel // strong

        // Dependencies
        //let worker = ___VARIABLE_sceneName___SceneWorker()
        //interactor.worker = worker
    }
}
