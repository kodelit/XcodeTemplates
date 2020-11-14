import UIKit

protocol ___VARIABLE_sceneName___Assembling {
    func assemble(_: ___VARIABLE_sceneName___ViewController)
}

protocol ___VARIABLE_sceneName___BusinessLogic {
    func handle(event: ___VARIABLE_sceneName___.LifecycleEvent)
    func handle(request: ___VARIABLE_sceneName___.UserRequest)
}

@objc protocol ___VARIABLE_sceneName___StoryboardRouting {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

class ___VARIABLE_sceneName___ViewController: ___VARIABLE_viewControllerSubclass___ {
    /// Assembler of the whole scene and its dependencies.
    ///
    /// Assembling is performed at the beginning of the `viewDidLoad()` method. However assembler might not be set if you need to perform the assembling somewhere else.
    var assembler: ___VARIABLE_sceneName___Assembling?
    typealias Router = NSObjectProtocol & ___VARIABLE_sceneName___Routing
    var router: Router?
    var interactor: ___VARIABLE_sceneName___BusinessLogic?
    // or in simple applications, ViewModel can replace Presenter and Interactor put together
    //var viewModel: ___VARIABLE_sceneName___BusinessLogic?

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
        assembler.assemble(self)
        loadSubviews()
        interactor?.handle(event: .viewDidLoad)
    }

    // MARK: Actions

    //@IBAction func onSomeButton(_ sender: UIButton) {
    //    interactor?.handle(request: .someButtonAction)
    //}
}

// MARK: - Loading subviews & layout

extension ___VARIABLE_sceneName___ViewController {

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

extension ___VARIABLE_sceneName___ViewController: ___VARIABLE_sceneName___DisplayLogic {
    func display(viewModel: ___VARIABLE_sceneName___.ViewModel) {
        //nameTextField.text = viewModel.name
    }

    func display(update: ___VARIABLE_sceneName___.Update) {
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
//struct ___VARIABLE_sceneName___ViewControllerRepresentable: UIViewControllerRepresentable {
//    typealias ViewController = ___VARIABLE_sceneName___ViewController
//
//    func makeUIViewController(context: Context) -> ViewController {
//        // let bundle = Bundle(for: ___VARIABLE_sceneName___ViewController.self)
//        // let storyboard = UIStoryboard(name: "Main", bundle: bundle)
//        // return storyboard.instantiateViewController(identifier: "___VARIABLE_sceneName___ViewController")
//        return ViewController(nibName: nil, bundle: nil)
//    }
//
//    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
//}
//
//@available(iOS 13.0, tvOS 13.0, *)
//struct UIKit___VARIABLE_sceneName___ViewControllerProvider: PreviewProvider {
//    static var previews: ___VARIABLE_sceneName___ViewControllerRepresentable {
//        ___VARIABLE_sceneName___ViewControllerRepresentable()
//    }
//}
//#endif
