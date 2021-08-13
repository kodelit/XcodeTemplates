import UIKit

protocol ___VARIABLE_sceneName___ScenePresentationLogic {
    func present(_ response: ___VARIABLE_sceneName___Scene.Response)
    func present(_ notification: ___VARIABLE_sceneName___Scene.Notification)
}

protocol ___VARIABLE_sceneName___SceneRouting: class {
    func route(to destination: ___VARIABLE_sceneName___Scene.Destination)
}

protocol ___VARIABLE_sceneName___SceneDelegate: class {
    func handle(_ request: ___VARIABLE_sceneName___Scene.Request.Data)
}

class ___VARIABLE_sceneName___SceneInteractor: ___VARIABLE_sceneName___SceneDataStoring {
    weak var router: ___VARIABLE_sceneName___SceneRouting?
    var presenter: ___VARIABLE_sceneName___ScenePresentationLogic?

    // MARK: - Dependencies (services, managers, helpers, formatters, workers, etc.)

    weak var delegate: ___VARIABLE_sceneName___SceneDelegate?

    // MARK: - Data Storing

    //var name: String = ""
}

// MARK: - Business Logic

extension ___VARIABLE_sceneName___SceneInteractor: ___VARIABLE_sceneName___SceneBusinessLogic {
    func handle(event: ___VARIABLE_sceneName___Scene.LifecycleEvent) {
        switch event {
        case .viewDidLoad:
            presenter?.present(response: .initialSetup)
        default: break
        }
    }

    func handle(action: ___VARIABLE_sceneName___Scene.UserAction) {
        switch action {
        case .backButton: router?.route(to: .exit)
        }
    }
}
