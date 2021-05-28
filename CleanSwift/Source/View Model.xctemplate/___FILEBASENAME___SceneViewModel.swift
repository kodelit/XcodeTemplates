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

class ___VARIABLE_sceneName___SceneViewModel: ___VARIABLE_sceneName___SceneDataStoring {
    weak var router: ___VARIABLE_sceneName___SceneRouting?
    /// UIViewController or UIView  implementing the Display Logic protocol
    weak var view: ___VARIABLE_sceneName___SceneDisplayLogic?

    // MARK: - Dependencies (services, managers, helpers, formatters, workers, etc.)

    // ...

    // MARK: - Data Storing

    var screenTitle: String?
    /// Indicates that the data should be reloaded from the local storage
    var isReloadRequired: Bool = false
    /// Indicates that the data should be updated from the remote storage
    var isUpdateRequired: Bool = false

    // MARK: - Lifecycle

    typealias SceneData = <#Data#>
    private var data: SceneData?

    private func viewDidLoad() {
        //guard let view = view else {
        //    assertionFailure("[___VARIABLE_sceneName___SceneViewModel] View not set.")
        //    return
        //}
        guard let view = view.assertExistence(propertyName: "view") else { return }
        let initialSetup = ___VARIABLE_sceneName___Scene.InitialSetup(screenTitle: screenTitle)
        view.display(initialSetup)
        refresh(fromRemoteStorage: true)
    }

    private func viewWillAppear() {
        if isReloadRequired || isUpdateRequired {
            refresh(fromRemoteStorage: isUpdateRequired)
        }
    }

    private func refresh(fromRemoteStorage: Bool) {

    }

    private func didReceiveData(_ data: SceneData) {
        // display data
    }
}

// MARK: - Business Logic

extension ___VARIABLE_sceneName___SceneViewModel: ___VARIABLE_sceneName___SceneBusinessLogic {
    func handle(event: ___VARIABLE_sceneName___Scene.LifecycleEvent) {
        switch event {
        case .viewDidLoad: viewDidLoad()
        case .viewWillAppear: viewWillAppear()
        }
    }

    func handle(action: ___VARIABLE_sceneName___Scene.UserAction) {
        switch action {
        case .refresh: refresh(fromRemoteStorage: true)
        case .backButton: router?.route(to: .exit)
        }
    }
}
