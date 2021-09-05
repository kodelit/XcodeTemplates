import UIKit

/// Responsible for assembling the scene and dependency injection.
class ___VARIABLE_sceneName___SceneAssembler: ___VARIABLE_sceneName___SceneAssembling {
    /// Assembles the scene by creating and assigning all components of the scene and its dependencies if not done already.
    func assembleIfNeeded(_ viewController: ___VARIABLE_sceneName___SceneViewController, isAssembled: inout Bool) {
        guard !isSceneAssembled else { return }
        isSceneAssembled = true

        // Basic assembling
        let router = ___VARIABLE_sceneName___Router()
        viewController.router = router // strong
        router.viewController = viewController // weak

        let viewModel = ___VARIABLE_sceneName___SceneViewModel()
        viewModel.view = viewController // weak
        viewController.viewModel = viewModel // strong
        viewModel.router = router // weak
        router.dataStore = viewModel // strong

        // Dependencies
        //let worker = ___VARIABLE_sceneName___SceneWorker()
        //viewModel.worker = worker
    }
}
