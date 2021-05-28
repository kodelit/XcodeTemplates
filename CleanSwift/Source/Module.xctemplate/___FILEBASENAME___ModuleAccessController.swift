import Foundation

// MARK: - Module Access Controller (module interface)

/// Module access controller protocol.
///
/// An interface of an instance of the module controller allowing data access and loading/managing the scenes of the module
public protocol ___VARIABLE_moduleName___ModuleAccessController {
    /// Router allowing to manage the module scenes from outside of the module.
    ///
    /// - note: There is only one module router instance per module access controller.
    var moduleRouter: ___VARIABLE_moduleName___ModuleRouting { get }
    //var dataUpdateHandler: ((SomeData) -> Void)? { get set }

    // /// Requests data from the local storage.
    //func requestLocalData(completion: @escaping (SomeData?) -> Void)
    // /// Requests data by sending the request to the `___VARIABLE_moduleName___DataSource` if data soruce was set with the `___VARIABLE_moduleName___Module.configure(dataSource:)` method.
    //func requestDataUpdate(completion: ((SomeData?) -> Void)?)
    //func update(data: SomeData)
}

// MARK: - Module Interface Implementation (Default Module Access Controller)

protocol ___VARIABLE_moduleName___ModuleDelegate: ___VARIABLE_rootSceneName___SceneDelegate {}

/// Default implementation of the module controller.
internal class ___VARIABLE_moduleName___Controller {
    static let sharedSceneDelegate: ___VARIABLE_moduleName___SceneDelegate = ___VARIABLE_moduleName___Controller()

    private let service: ___VARIABLE_moduleName___ModuleBusinessLogic
    weak var moduleDelegate: ___VARIABLE_moduleName___ModuleDelegate?

    convenience init() {
        let router = ___VARIABLE_moduleName___SceneRouter()
        self.init(rootSceneRouter: router)
        router.sceneDelegate = self
    }

    init(rootSceneRouter: ___VARIABLE_moduleName___ModuleRouting) {
        guard let service = ___VARIABLE_moduleName___Module.businessLogic else {
            fatalError("[___VARIABLE_moduleName___DefaultController] Module not configured.")
        }
        self.service = service
        self.moduleRouter = rootSceneRouter
        self.moduleDelegate = ___VARIABLE_moduleName___Module.delegate
    }

    // MARK: - ___VARIABLE_moduleName___ModuleAccessController

    public let moduleRouter: ___VARIABLE_moduleName___ModuleRouting
    //public var dataUpdateHandler: (() -> Void)?
}

extension ___VARIABLE_moduleName___Controller: ___VARIABLE_moduleName___ModuleAccessController {
}

extension ___VARIABLE_moduleName___Controller: ___VARIABLE_moduleName___SceneDelegate {
    func handle(_ request: ___VARIABLE_rootSceneName___Scene.Request.Data) {
        let data = self.service.getData()
        request.reload(data, !request.shouldRequestRemoteData)

        if request.shouldRequestRemoteData {
            guard let dataSource = self.moduleDelegate else {
                request.canceled?()
                return
            }
            request.setLoadingIndicator?(true)

            typealias DataRequest = ___VARIABLE_moduleName___Module.Request.Data
            let dataRequest = DataRequest() { [weak self] data in
                self?.update(with: data)
                request.reload(data, true)
                request.setLoadingIndicator?(false)
            } failure: {
                request.canceled?()
                request.setLoadingIndicator?(false)
            }
            dataSource.handle(dataRequest)
        }
    }
}
