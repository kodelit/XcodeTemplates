import UIKit

protocol ___VARIABLE_sceneName___PresentationLogic {
    func present(response: ___VARIABLE_sceneName___.Something.Response)
}

class ___VARIABLE_sceneName___Interactor: ___VARIABLE_sceneName___BusinessLogic, ___VARIABLE_sceneName___DataStore {
    var presenter: ___VARIABLE_sceneName___PresentationLogic?
    var worker: ___VARIABLE_sceneName___Worker?
    //var name: String = ""

    // MARK: - Business Logic

    func handle(request: ___VARIABLE_sceneName___.Something.Request) {
        worker = ___VARIABLE_sceneName___Worker()
        worker?.doSomeWork()

        let response = ___VARIABLE_sceneName___.Something.Response()
        presenter?.present(response: response)
    }
}
