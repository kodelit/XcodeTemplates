import UIKit

protocol ___VARIABLE_sceneName___DisplayLogic: class {
    func display(viewModel: ___VARIABLE_sceneName___.ViewModel)
    func display(update: ___VARIABLE_sceneName___.Update)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

class ___VARIABLE_sceneName___Presenter {
    weak var viewController: ___VARIABLE_sceneName___DisplayLogic?
}

// MARK: - Presentation Logic

extension ___VARIABLE_sceneName___Presenter: ___VARIABLE_sceneName___PresentationLogic {
    func present(response: ___VARIABLE_sceneName___.Response) {
        switch response {
        case .reloadData:
            let viewModel = ___VARIABLE_sceneName___.ViewModel()
            viewController?.display(viewModel: viewModel)

        //case let .deselectRow(at: indexPath):
        //    viewController?.display(update: .deselectRow(at: indexPath, animated: true))

        //default: break
        }
    }

    func present(notification: ___VARIABLE_sceneName___.Notification) {
    }
}
