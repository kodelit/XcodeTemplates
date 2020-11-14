import UIKit

protocol ___VARIABLE_sceneName___DisplayLogic: class {
    /// Whole view update handler.
    func display(viewModel: ___VARIABLE_sceneName___.ViewModel)
    /// Generic method for handling small updates
    func display(update: ___VARIABLE_sceneName___.Update)

    // More specialized update method. More complex update logic should be implemented in the separate method
    //func display(update: ___VARIABLE_sceneName___.Update.SomeUpdate)

    /// This method is implemented by the UIVIewController, and might be used for simplicity. However in accordance with the programming art it's the ruter who should be responsible for navigation
    //func dismiss(animated: Bool, completion: (() -> Void)?)
}

protocol ___VARIABLE_sceneName___Routing: class {
    func route(to destination: Destination)
}

class ___VARIABLE_sceneName___Presenter {
    weak var router: ___VARIABLE_sceneName___Routing?
    /// UIViewController or UIView  implementing the Display Logic protocol
    weak var view: ___VARIABLE_sceneName___DisplayLogic?
}

// MARK: - Presentation Logic

extension ___VARIABLE_sceneName___Presenter: ___VARIABLE_sceneName___PresentationLogic {
    func present(response: ___VARIABLE_sceneName___.Response) {
        switch response {
        case .reloadData:
            let viewModel = ___VARIABLE_sceneName___.ViewModel()
            view?.display(viewModel: viewModel)

        //case let .deselectRow(at: indexPath):
        //    view?.display(update: .deselectRow(at: indexPath, animated: true))

        //default: break
        }
    }

    func present(notification: ___VARIABLE_sceneName___.Notification) {
    }
}
