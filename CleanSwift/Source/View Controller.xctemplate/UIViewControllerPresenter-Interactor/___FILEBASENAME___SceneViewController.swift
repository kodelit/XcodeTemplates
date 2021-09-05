import UIKit

protocol ___VARIABLE_sceneName___SceneAssembling {
    func assembleIfNeeded(_: ___VARIABLE_sceneName___SceneViewController, isAssembled: inout Bool)
}

protocol ___VARIABLE_sceneName___SceneBusinessLogic {
    func handle(event: ___VARIABLE_sceneName___Scene.LifecycleEvent)
    func handle(action: ___VARIABLE_sceneName___Scene.UserAction)
}

//@objc protocol ___VARIABLE_sceneName___SceneStoryboardRouting {
//    //func routeToSomewhere(segue: UIStoryboardSegue?)
//}

class ___VARIABLE_sceneName___SceneViewController: ___VARIABLE_viewControllerSubclass___ {
    /// Assembler of the whole scene and its dependencies.
    ///
    /// Assembling is performed at the beginning of the `viewDidLoad()` or on demand with `assembleIfNeeded()` method. However assembler might not be set if you need to perform the assembling somewhere else.
    var assembler: ___VARIABLE_sceneName___SceneAssembling?
    var interactor: ___VARIABLE_sceneName___SceneBusinessLogic?

    ///  Holds the instance of the root object of the scene.
    ///  If we don't use storyboard segues retaining the router reference is the only purpose of this property.
    var router: AnyObject?

    //@IBOutlet weak var nameTextField: UITextField!

    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private(set) var isAssembled = false

    /// Assembles the scene by creating and assigning all components of the scene and its dependencies if not done already.
    func assembleIfNeeded() {
        // !!!: Remove the following line if you don't need assembler, because you perform the assembling somewhere else
        assert(assembler != nil, "Assembler not set.")
        assembler?.assembleIfNeeded(self, isAssembled: &isAssembled)
    }

    /// Invoked at the end of init methods.
    ///
    /// Resposible for post init configuration of the controller, before view is loaded.
    func setup() {
        // default assembler, is required if the controller is created by the storyboard
        assembler = ___VARIABLE_sceneName___SceneRouter()
    }

    // MARK: Routing

    //typealias Router = NSObjectProtocol & ___VARIABLE_sceneName___SceneStoryboardRouting
    // /// Router in the view controller is used only in case of routing with UIStoryboardSegue (optional), in other cases view controller should send request to the interactor/viewModel.
    //var router: Router?
    //
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.handle(event: .viewWillAppear)
    }

    // MARK: Actions

    @IBAction func onBackButton() {
        interactor?.handle(action: .backButton)
    }
}

// MARK: - Loading subviews & layout

extension ___VARIABLE_sceneName___SceneViewController {

    /// Loads subviews after the view is loaded.
    ///
    /// The method is invoked in `viewDidLoad()` before the interactor will handle the `.viewDidLoad` event
    func loadSubviews() {

        setupSubviews()
    }

    /// Performs initial setup of the loaded subviews.
    ///
    /// The method is invoked at the end of the `loadSubviews()` method
    func setupSubviews() {

        setupLayout()
    }

    /// Performs initial setup of all nessesery layout.
    ///
    /// The method is invoked at the end of the `setupSubviews()` method
    func setupLayout() {

    }
}

// MARK: - DisplayLogic

extension ___VARIABLE_sceneName___SceneViewController: ___VARIABLE_sceneName___SceneDisplayLogic {
    func display(_ initialSetup: ___VARIABLE_sceneName___Scene.InitialSetup) {
        //tableView.reloadData()
    }

    func display(_ update: ___VARIABLE_sceneName___Scene.Update) {
    }
}

// MARK: - Xcode Preview
// swiftlint:disable type_name

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//@available(iOS 13.0, tvOS 13.0, *)
//struct ___VARIABLE_sceneName___SceneViewControllerRepresentable: UIViewControllerRepresentable {
//    typealias ViewController = ___VARIABLE_sceneName___SceneViewController
//
//    func makeUIViewController(context: Context) -> ViewController {
//        // let bundle = Bundle(for: ViewController.self)
//        // let storyboard = UIStoryboard(name: "___VARIABLE_sceneName___", bundle: bundle)
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

// swiftlint:enable type_name
