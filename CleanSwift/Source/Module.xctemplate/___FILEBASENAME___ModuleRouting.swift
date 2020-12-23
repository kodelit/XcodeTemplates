import Foundation

public protocol ___VARIABLE_moduleName___ModuleRouting {
    /// Set to handle navigation backward/dismissing the root scene of the module.
    var sceneExitHandler: ((_ rootViewController: UIViewController) -> Void)? { get set }

    /// Root scene view controller instance.
    ///
    /// - note: There is only one instance of the scene per module router,
    /// and there might be only one module router instance per module access controller instance.
    func startScene() -> UIViewController?

    // /// Allows to pass data to the module if the scene has been loaded from storyboard
    //func configure(with data: ___VARIABLE_moduleName___Module.InputData)
}

extension ___VARIABLE_moduleName___SceneRouter: ___VARIABLE_moduleName___ModuleRouting {
    func startScene() -> UIViewController? {
        return getSceneViewController()
    }

    //func configure(with data: ResidentsModule.InputData) {
    //    //self.dataStore?.someValue = data.someValue
    //}
}
