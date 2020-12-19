import Foundation

public protocol ___VARIABLE_moduleName___ModuleRouting {
    /// Set to handle navigation backward/dismissing the root scene of the module.
    var sceneExitHandler: ((_ rootViewController: UIViewController) -> Void)? { get set }

    /// Root scene view controller instance.
    ///
    /// - note: There is only one instance of the scene per module router,
    /// and there is only one module router instance per module access controller.
    func startScene() -> UIViewController?

    /// Allows to pass data to the module if scenes has been loaded from storyboard
    //func start(with data: ___VARIABLE_moduleName___Module.InputData)
}

extension ___VARIABLE_moduleName___SceneRouter: ___VARIABLE_moduleName___ModuleRouting {
    func startScene() -> UIViewController? {
        return getSceneViewController()
    }

    func start(with data: ResidentsModule.InputData) {
        //self.dataStore?.someValue = data.someValue
    }
}
