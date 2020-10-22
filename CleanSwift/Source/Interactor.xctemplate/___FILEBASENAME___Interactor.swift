import UIKit

protocol ___VARIABLE_sceneName___PresentationLogic {
    func present(response: ___VARIABLE_sceneName___.Response)
    func present(notification: ___VARIABLE_sceneName___.Notification)
}

class ___VARIABLE_sceneName___Interactor: ___VARIABLE_sceneName___DataStoring {
    var presenter: ___VARIABLE_sceneName___PresentationLogic?

    // MARK: - Dependencies (services, managers, helpers, formatters, workers, etc.)

    //var worker: ___VARIABLE_sceneName___Worker?

    // MARK: - Data Storing

    //var name: String = ""
}

// MARK: - Business Logic

extension ___VARIABLE_sceneName___Interactor: ___VARIABLE_sceneName___BusinessLogic {
    func handle(event: ___VARIABLE_sceneName___.Event) {
        switch event {
        case .viewDidLoad: break
            presenter?.present(response: .reloadData)
        }
    }

    func handle(request: ___VARIABLE_sceneName___.Request) {
        //assert(worker != nil, "___VARIABLE_sceneName___Worker is not loaded.")
        //worker?.doSomeWork()
        //presenter?.present(response: .deselectRow(at: ...))
    }
}
