import UIKit

struct ___VARIABLE_sceneName___Assembler: ___VARIABLE_sceneName___Assembling {
    func resolve(_ viewController: ___VARIABLE_sceneName___ViewController) {
        let interactor = ___VARIABLE_sceneName___Interactor()
        let presenter = ___VARIABLE_sceneName___Presenter()
        let router = ___VARIABLE_sceneName___Router()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func loadSubviews(_ viewController: ___VARIABLE_sceneName___ViewController) {
        let view = viewController.view
        
        //let button = UIButton(type: .custom)
        //button.translatesAutoresizingMaskIntoConstraints = false
        //view?.addSubview(button)
        //viewController.button = button
        
        setupLayout(viewController)
    }
    
    func setupLayout(_ viewController: ___VARIABLE_sceneName___ViewController) {
        
    }
}
