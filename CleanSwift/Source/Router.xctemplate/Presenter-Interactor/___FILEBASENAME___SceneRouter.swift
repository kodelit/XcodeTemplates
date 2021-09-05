import UIKit

class ___VARIABLE_productName___SceneRouter: NSObject {
    weak var viewController: UIViewController?
    var dataStore: ___VARIABLE_productName___SceneDataStoring?

    /// Loads or returns already loaded controller.
    func getSceneViewController() -> ___VARIABLE_productName___SceneViewController? {
        if let viewController = self.viewController as? ___VARIABLE_productName___SceneViewController {
            return viewController
        }
        //let storyboardName = "___VARIABLE_productName___Scene"
        //let viewControllerId = "___VARIABLE_productName___SceneViewController"
        //let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        //guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerId) as? ___VARIABLE_productName___SceneViewController else {
        //    assertionFailure("Could not load ___VARIABLE_productName___SceneViewController with identifier: \(viewControllerId), from storybard: \(storyboardName)")
        //    return nil
        //}
        // or
        let viewController = ___VARIABLE_productName___SceneViewController(nibName: nil, bundle: nil)

        // Assembling
        viewController.assembler = self
        viewController.assembleIfNeeded()
        return viewController
    }

    /// Set to handle navigation backward/dismissing the scene.
    var sceneExitHandler: ((_ rootViewController: UIViewController) -> Void)?
}

// MARK: - ___VARIABLE_productName___SceneAssembling

extension ___VARIABLE_productName___SceneRouter: ___VARIABLE_productName___SceneAssembling {
    /// Assembles the scene by creating and assigning all components of the scene and its dependencies if not done already.
    func assembleIfNeeded(_ viewController: ___VARIABLE_productName___SceneViewController, isAssembled: inout Bool) {
        guard !isAssembled else { return }
        isAssembled = true

        // Basic assembling
        let router = self
        viewController.router = router // strong
        router.viewController = viewController // weak

        let interactor = ___VARIABLE_sceneName___SceneInteractor()
        let presenter = ___VARIABLE_sceneName___ScenePresenter()
        interactor.presenter = presenter // strong
        presenter.view = viewController // weak
        presenter.router = router // weak
        viewController.interactor = interactor // strong
        router.dataStore = interactor // strong
    }
}

// MARK: - ___VARIABLE_productName___Scene Routing Logic

protocol ___VARIABLE_productName___SceneDataStoring {
    var screenTitle: String? { get set }

    /// Indicates that the data should be reloaded from the local storage
    var isReloadRequired: Bool { get set }
    /// Indicates that the data should be updated from the remote storage
    var isUpdateRequired: Bool { get set }
}

extension ___VARIABLE_productName___SceneRouter: ___VARIABLE_productName___SceneRouting {
    func route(to destination: ___VARIABLE_productName___Scene.Destination) {
        switch destination {
        case .exit:
            guard let viewController = viewController else { return }
            sceneExitHandler?(viewController)
        }
    }

    //func route(to destination: ___VARIABLE_productName___Scene.Destination.<#Destination#>) {
    //    let targetRouter = <#Destination#>SceneRouter()
    //    guard let sourceDataStore = dataStore,
    //          // Load the view controller first to be sure that the target data strore is loaded
    //          let targetViewController = targetRouter.getSceneViewController(),
    //          var targetDataStore = targetRouter.dataStore else {
    //        return
    //    }
    //    // Data Passing
    //    targetDataStore.someValue = destination.value
    //
    //    targetRouter.sceneExitHandler = { [weak self] _ in
    //        self?.viewController?.navigationController?.popViewController(animated: true)
    //        // or
    //        //self?.viewController?.dismiss(animated: true, completion: nil)
    //    }
    //    viewController?.navigationController?.pushViewController(targetViewController, animated: true)
    //    // or
    //    //viewController?.present(targetViewController, animated: true, completion: nil)
    //}
}

// MARK: - ___VARIABLE_productName___Scene Storyboard Routing

//protocol ___VARIABLE_productName___SceneDataPassing {
//    /// ___VARIABLE_productName___Scene data store.
//    var dataStore: ___VARIABLE_productName___SceneDataStoring? { get }
//}
//
//extension ___VARIABLE_productName___SceneRouter: ___VARIABLE_productName___SceneStoryboardRouting, ___VARIABLE_productName___SceneDataPassing {
//    func routeToSomewhere(segue: UIStoryboardSegue?) {
//      if let segue = segue {
//        let destinationVC = segue.destination as! <#Destination#>ViewController
//        var destinationDS = destinationVC.router!.dataStore!
//        passData(source: dataStore!, destination: &destinationDS)
//      } else {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let destinationVC = storyboard.instantiateViewController(withIdentifier: "<#Destination#>ViewController") as! <#Destination#>ViewController
//        var destinationDS = destinationVC.router!.dataStore!
//        passData(source: dataStore!, destination: &destinationDS)
//        navigate(source: viewController!, destination: destinationVC)
//      }
//    }
//
//     MARK: Navigation
//
//    func navigate(source: ___VARIABLE_productName___SceneViewController, destination: <#Destination#>ViewController) {
//      source?.present(destination, animated: true, completion: nil)
//    }
//
//     MARK: Passing data
//
//    func passData(source: ___VARIABLE_productName___SceneDataStoring, destination: inout <#Destination#>DataStore) {
//      destination.name = source.name
//    }
//}
