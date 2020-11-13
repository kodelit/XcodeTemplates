import UIKit

protocol ___VARIABLE_sceneName___DisplayLogic: class {
    func display(viewModel: ___VARIABLE_sceneName___.ViewModel)
    func display(update: ___VARIABLE_sceneName___.Update)
    func display(update: ___VARIABLE_sceneName___.Update.SomeUpdate)
    /// This method is implemented by the UIVIewController, and might be used for simplicity. However in accordance with the programming art it's the ruter who should be responsible for navigation
    //func dismiss(animated: Bool, completion: (() -> Void)?)
}

protocol ___VARIABLE_sceneName___Routing {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

class ___VARIABLE_sceneName___Presenter {
    typealias Router = (___VARIABLE_sceneName___Routing & ___VARIABLE_sceneName___DataPassing)
    var router: Router?
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
