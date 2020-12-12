import UIKit

protocol ___VARIABLE_sceneName___SceneDisplayLogic: class {
    /// Whole view update handler.
    func display(viewModel: ___VARIABLE_sceneName___Scene.ViewModel)
    /// Generic method for handling small updates
    func display(update: ___VARIABLE_sceneName___Scene.Update)

    // More specialized update method. More complex update logic should be implemented in the separate method
    //func display(update: ___VARIABLE_sceneName___Scene.Update.SomeUpdate)

    /// This method is implemented by the UIVIewController, and might be used for simplicity. However in accordance with the programming art it's the ruter who should be responsible for navigation
    //func dismiss(animated: Bool, completion: (() -> Void)?)
}

protocol ___VARIABLE_sceneName___SceneRouting: class {
    func route(to destination: ___VARIABLE_sceneName___Scene.Destination)
}

class ___VARIABLE_sceneName___SceneViewModel: ___VARIABLE_sceneName___SceneDataStoring {
    weak var router: ___VARIABLE_sceneName___SceneRouting?
    /// UIViewController or UIView  implementing the Display Logic protocol
    weak var view: ___VARIABLE_sceneName___SceneDisplayLogic?

    // MARK: - Dependencies (services, managers, helpers, formatters, workers, etc.)

    //var worker: ___VARIABLE_sceneName___SceneWorker?

    // MARK: - Data Storing

    //var name: String = ""
}

// MARK: - Business Logic

extension ___VARIABLE_sceneName___SceneViewModel: ___VARIABLE_sceneName___SceneBusinessLogic {
    func handle(event: ___VARIABLE_sceneName___Scene.LifecycleEvent) {
        switch event {
        case .viewDidLoad:
            let viewModel = ___VARIABLE_sceneName___Scene.ViewModel()
            view?.display(viewModel: viewModel)

        //case let .deselectRow(at: indexPath):
        //    view?.display(update: .deselectRow(at: indexPath, animated: true))

        //default: break
        }
    }

    func handle(action: ___VARIABLE_sceneName___Scene.UserAction) {
        //assert(worker != nil, "___VARIABLE_sceneName___SceneWorker is not loaded.")
        //worker?.doSomeWork()
        //presenter?.present(response: .deselectRow(at: ...))
    }
}
