import UIKit

protocol ___VARIABLE_sceneName___Assembling {
    func resolve(_ :___VARIABLE_sceneName___ViewController)
}

@objc protocol ___VARIABLE_sceneName___RoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ___VARIABLE_sceneName___BusinessLogic {
    func handle(request: ___VARIABLE_sceneName___.Something.Request)
}

class ___VARIABLE_sceneName___ViewController: ___VARIABLE_viewControllerSubclass___, ___VARIABLE_sceneName___DisplayLogic {
    var assembler: ___VARIABLE_sceneName___Assembling = ___VARIABLE_sceneName___Assembler()
    var interactor: ___VARIABLE_sceneName___BusinessLogic?
    var router: (NSObjectProtocol & ___VARIABLE_sceneName___RoutingLogic & ___VARIABLE_sceneName___DataPassing)?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    /// Invoked at the end of init methods.
    ///
    /// Resolves view controller with given `assembler`.
    /// Resposible for post init configuration of the controller, before view is loaded.
    func setup() {
        assembler.resolve(self)
    }

    // MARK: Routing

    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    if let scene = segue.identifier {
    //        let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
    //        if let router = router, router.responds(to: selector) {
    //            router.perform(selector, with: segue)
    //        }
    //    }
    //}

    //@IBAction func goSomewhere(_ sender: UIButton) {
    //    router?.routeToSomewhere(segue: nil)
    //}

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
//        doSomething()
    }

    // MARK: Do something

    //@IBOutlet weak var nameTextField: UITextField!

    //func doSomething() {
    //    let request = ___VARIABLE_sceneName___.Something.Request()
    //    interactor?.handle(request: request)
    //}

    // MARK: - DisplayLogic

    func display(viewModel: ___VARIABLE_sceneName___.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}


// MARK: - Xcode Preview
// Works from Xcode 11 and macOS 10.15

//import SwiftUI
//
//struct ___VARIABLE_sceneName___ViewControllerRepresentable: UIViewControllerRepresentable {
//    @available(iOS 13.0, *)
//    func makeUIViewController(context: UIViewControllerRepresentableContext<___VARIABLE_sceneName___ViewControllerRepresentable>) -> ___VARIABLE_sceneName___ViewController {
//        // let bundle = Bundle(for: ___VARIABLE_sceneName___ViewController.self)
//        // let storyboard = UIStoryboard(name: "Main", bundle: bundle)
//        // return storyboard.instantiateViewController(identifier: "___VARIABLE_sceneName___ViewController")
//        return ___VARIABLE_sceneName___ViewController(nibName: nil, bundle: nil)
//    }
//
//    @available(iOS 13.0, *)
//    func updateUIViewController(_ uiViewController: ___VARIABLE_sceneName___ViewController, context: UIViewControllerRepresentableContext<___VARIABLE_sceneName___ViewControllerRepresentable>) {
//
//    }
//}
//
//struct UIKit___VARIABLE_sceneName___ViewControllerProvider: PreviewProvider {
//    static var previews: ___VARIABLE_sceneName___ViewControllerRepresentable {
//        ___VARIABLE_sceneName___ViewControllerRepresentable()
//    }
//}
