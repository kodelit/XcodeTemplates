import UIKit

protocol ___VARIABLE_sceneName___SceneDisplayLogic: class {
    /// Whole view update handler.
    func display(_ initialSetup: ___VARIABLE_sceneName___Scene.InitialSetup)
    /// Generic method for handling small updates
    func display(_ update: ___VARIABLE_sceneName___Scene.Update)

    // More specialized update method. More complex update logic should be implemented in the separate method
    //func display(_ update: ___VARIABLE_sceneName___Scene.Update.<#Update#>)
}

protocol ___VARIABLE_sceneName___SceneRouting: class {
    func route(to destination: ___VARIABLE_sceneName___Scene.Destination)
}

protocol ___VARIABLE_sceneName___SceneDelegate: class {
    func handle(_ request: ___VARIABLE_sceneName___Scene.Request.Data)
}

class ___VARIABLE_sceneName___SceneViewModel: ___VARIABLE_sceneName___SceneDataStoring {
    weak var router: ___VARIABLE_sceneName___SceneRouting?
    /// UIViewController or UIView  implementing the Display Logic protocol
    weak var view: ___VARIABLE_sceneName___SceneDisplayLogic?

    // MARK: - Dependencies (services, managers, helpers, formatters, workers, etc.)

    weak var delegate: ___VARIABLE_sceneName___SceneDelegate?

    // MARK: - Data Storing

    //var name: String = ""
}

// MARK: - Business Logic

extension ___VARIABLE_sceneName___SceneViewModel: ___VARIABLE_sceneName___SceneBusinessLogic {
    func handle(event: ___VARIABLE_sceneName___Scene.LifecycleEvent) {
        switch event {
        case .viewDidLoad:
            let initialSetup = ___VARIABLE_sceneName___Scene.InitialSetup()
            view?.display(initialSetup)
        default: break
        }
    }

    func handle(action: ___VARIABLE_sceneName___Scene.UserAction) {
        switch action {
        case .backButton: router?.route(to: .exit)
        }
    }
}
