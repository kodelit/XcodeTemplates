import UIKit

protocol ___VARIABLE_sceneName___SceneDisplayLogic: class {
    /// Whole view update handler.
    func display(_ initialSetup: ___VARIABLE_sceneName___Scene.InitialSetup)
    /// Generic method for handling small updates
    func display(_ update: ___VARIABLE_sceneName___Scene.Update)

    // More specialized update method. More complex update logic should be implemented in the separate method
    //func display(_ update: ___VARIABLE_sceneName___Scene.Update.<#Update#>)

    /// This method is implemented by the UIVIewController, and might be used for simplicity. However in accordance with the programming art it's the ruter who should be responsible for navigation
    //func dismiss(animated: Bool, completion: (() -> Void)?)
}

protocol ___VARIABLE_sceneName___SceneRouting: class {
    func route(to destination: ___VARIABLE_sceneName___Scene.Destination)
}

class ___VARIABLE_sceneName___ScenePresenter {
    weak var router: ___VARIABLE_sceneName___SceneRouting?
    /// UIViewController or UIView  implementing the Display Logic protocol
    weak var view: ___VARIABLE_sceneName___SceneDisplayLogic?
}

// MARK: - Presentation Logic

extension ___VARIABLE_sceneName___ScenePresenter: ___VARIABLE_sceneName___ScenePresentationLogic {
    func present(response: ___VARIABLE_sceneName___Scene.Response) {
        switch response {
        case .initialSetup:
            let initialSetup = ___VARIABLE_sceneName___Scene.InitialSetup()
            view?.display(initialSetup)
        }
    }

    func present(notification: ___VARIABLE_sceneName___Scene.Notification) {
    }
}
