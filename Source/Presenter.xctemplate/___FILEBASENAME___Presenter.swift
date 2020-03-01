import UIKit

protocol ___VARIABLE_sceneName___DisplayLogic: class {
    func display(viewModel: ___VARIABLE_sceneName___.ViewModel)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

class ___VARIABLE_sceneName___Presenter {
    weak var viewController: ___VARIABLE_sceneName___DisplayLogic?
}

// MARK: - Presentation Logic

extension ___VARIABLE_sceneName___Presenter: ___VARIABLE_sceneName___PresentationLogic {
    func present(response: ___VARIABLE_sceneName___.Response) {
        let viewModel = ___VARIABLE_sceneName___.ViewModel()
        viewController?.display(viewModel: viewModel)
    }
}
