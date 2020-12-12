import UIKit

protocol ___VARIABLE_sceneName___SceneAssembling {
    func assembleIfNeeded(_: ___VARIABLE_sceneName___SceneViewController)
}

protocol ___VARIABLE_sceneName___SceneBusinessLogic {
    func handle(event: ___VARIABLE_sceneName___Scene.LifecycleEvent)
    func handle(action: ___VARIABLE_sceneName___Scene.UserAction)
}

@objc protocol ___VARIABLE_sceneName___SceneStoryboardRouting {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

class ___VARIABLE_sceneName___SceneViewController: ___VARIABLE_viewControllerSubclass___ {
    /// Assembler of the whole scene and its dependencies.
    ///
    /// Assembling is performed at the beginning of the `viewDidLoad()` or on demand with `assembleIfNeeded()` method. However assembler might not be set if you need to perform the assembling somewhere else.
    var assembler: ___VARIABLE_sceneName___SceneAssembling?
    var interactor: ___VARIABLE_sceneName___SceneBusinessLogic?
    // or in simple applications, ViewModel can replace Presenter and Interactor put together
    //var viewModel: ___VARIABLE_sceneName___SceneBusinessLogic?

    typealias Router = NSObjectProtocol & ___VARIABLE_sceneName___SceneStoryboardRouting
    /// Router in the view controller is used only in case of routing with UIStoryboardSegue (optional), in other cases view controller should send request to the interactor/viewModel.
    var router: Router?

    //@IBOutlet weak var nameTextField: UITextField!

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

    /// Assembles the scene by creating and assigning all components of the scene and its dependencies if not done already.
    func assembleIfNeeded() {
        // !!!: Remove the following line if you don't need assembler, because you perform the assembling somewhere else
        assert(assembler != nil, "Assembler not set.")
        assembler?.assembleIfNeeded(self)
    }

    /// Invoked at the end of init methods.
    ///
    /// Resposible for post init configuration of the controller, before view is loaded.
    func setup() {
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

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        assembleIfNeeded()
        loadSubviews()
        interactor?.handle(event: .viewDidLoad)
        //viewModel?.handle(event: .viewDidLoad)
    }

    // MARK: Actions

    //@IBAction func onSomeButton(_ sender: UIButton) {
    //    interactor?.handle(action: .someButtonAction)
    //}
}

// MARK: - Loading subviews & layout

extension ___VARIABLE_sceneName___SceneViewController {

    /// Loads subviews after the view is loaded.
    ///
    /// Inveked in `viewDidLoad()` before the interactor will handle the `.viewDidLoad` event
    func loadSubviews() {
        //let button = UIButton(type: .custom)
        //button.translatesAutoresizingMaskIntoConstraints = false
        //view.addSubview(button)
        //self.button = button

        setupLayout()
    }

    /// Performs initial setup of the loaded subviews.
    ///
    /// Invoked at the end of the `loadSubviews()` method
    func setupSubviews() {
        // button.isEnabled = false

        setupLayout()
    }

    /// Performs initial setup of all nessesery layout.
    ///
    /// Invoked at the end of the `setupSubviews()` method
    func setupLayout() {
        //guard let view = viewController.view else { return }
    }
}

// MARK: - DisplayLogic

extension ___VARIABLE_sceneName___SceneViewController: ___VARIABLE_sceneName___SceneDisplayLogic {
    func display(viewModel: ___VARIABLE_sceneName___Scene.ViewModel) {
        //tableData = viewModel
        //tableView.reloadData()
    }

    func display(update: ___VARIABLE_sceneName___Scene.Update) {
        //nameTextField.text = update.name
        //switch update {
        //case let .deselectRow(at: indexPath, animated: animated):
        //    break
        //default: break
        //}
    }
}

// MARK: - Xcode Preview
// Works from Xcode 11 and macOS 10.15

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//@available(iOS 13.0, tvOS 13.0, *)
//struct ___VARIABLE_sceneName___SceneViewControllerRepresentable: UIViewControllerRepresentable {
//    typealias ViewController = ___VARIABLE_sceneName___SceneViewController
//
//    func makeUIViewController(context: Context) -> ViewController {
//        // let bundle = Bundle(for: ___VARIABLE_sceneName___SceneViewController.self)
//        // let storyboard = UIStoryboard(name: "Main", bundle: bundle)
//        // return storyboard.instantiateViewController(identifier: "___VARIABLE_sceneName___SceneViewController")
//        return ViewController(nibName: nil, bundle: nil)
//    }
//
//    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
//}
//
//@available(iOS 13.0, tvOS 13.0, *)
//struct UIKit___VARIABLE_sceneName___SceneViewControllerProvider: PreviewProvider {
//    static var previews: ___VARIABLE_sceneName___SceneViewControllerRepresentable {
//        ___VARIABLE_sceneName___SceneViewControllerRepresentable()
//    }
//}
//#endif
