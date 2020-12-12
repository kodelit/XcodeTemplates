import UIKit

protocol ___VARIABLE_sceneName___ScenePresentationLogic {
    func present(response: ___VARIABLE_sceneName___Scene.Response)
    func present(notification: ___VARIABLE_sceneName___Scene.Notification)
}

class ___VARIABLE_sceneName___SceneInteractor: ___VARIABLE_sceneName___SceneDataStoring {
    var presenter: ___VARIABLE_sceneName___ScenePresentationLogic?

    // MARK: - Dependencies (services, managers, helpers, formatters, workers, etc.)

    //var worker: ___VARIABLE_sceneName___SceneWorker?

    // MARK: - Data Storing

    //var name: String = ""
}

// MARK: - Business Logic

extension ___VARIABLE_sceneName___SceneInteractor: ___VARIABLE_sceneName___SceneBusinessLogic {
    func handle(event: ___VARIABLE_sceneName___Scene.LifecycleEvent) {
        switch event {
        case .viewDidLoad: break
            presenter?.present(response: .reloadData)
        }
    }

    func handle(action: ___VARIABLE_sceneName___Scene.UserAction) {
        //assert(worker != nil, "___VARIABLE_sceneName___SceneWorker is not loaded.")
        //worker?.doSomeWork()
        //presenter?.present(response: .deselectRow(at: ...))
    }
}
