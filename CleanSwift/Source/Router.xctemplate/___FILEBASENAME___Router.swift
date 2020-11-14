import UIKit

protocol ___VARIABLE_sceneName___DataStoring {
    //var name: String { get set }
}

protocol ___VARIABLE_sceneName___DataPassing {
    var dataStore: ___VARIABLE_sceneName___DataStoring? { get }
}

class ___VARIABLE_sceneName___Router: NSObject, ___VARIABLE_sceneName___Routing, ___VARIABLE_sceneName___DataPassing {
    private weak var viewController: UIViewController?
    var dataStore: ___VARIABLE_sceneName___DataStoring?

    // MARK: - Routing Logic

    func route(to destination: Destination) {
    }

    //func routeToSomewhere(segue: UIStoryboardSegue?) {
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}

    // MARK: Navigation

    //func navigateToSomewhere(source: ___VARIABLE_sceneName___ViewController, destination: SomewhereViewController) {
    //  source.show(destination, sender: nil)
    //}

    // MARK: Passing data

    //func passDataToSomewhere(source: ___VARIABLE_sceneName___DataStoring, destination: inout SomewhereDataStore) {
    //  destination.name = source.name
    //}
}
