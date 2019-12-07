## Scene

### UIViewController

*UIViewController*, *UITableViewController* and *UICollectionViewController* look the same.

```swift
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

```

### Interactor
```swift
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
```

### Presenter
```swift
import UIKit

protocol ___VARIABLE_sceneName___DisplayLogic: class {
    func display(viewModel: ___VARIABLE_sceneName___.Something.ViewModel)
}

class ___VARIABLE_sceneName___Presenter: ___VARIABLE_sceneName___PresentationLogic {
    weak var viewController: ___VARIABLE_sceneName___DisplayLogic?

    // MARK: - Presentation Logic

    func present(response: ___VARIABLE_sceneName___.Something.Response) {
        let viewModel = ___VARIABLE_sceneName___.Something.ViewModel()
        viewController?.display(viewModel: viewModel)
    }
}
```

### Router
```swift
import UIKit

protocol ___VARIABLE_sceneName___DataStore {
    //var name: String { get set }
}

protocol ___VARIABLE_sceneName___DataPassing {
    var dataStore: ___VARIABLE_sceneName___DataStore? { get }
}

class ___VARIABLE_sceneName___Router: NSObject, ___VARIABLE_sceneName___RoutingLogic, ___VARIABLE_sceneName___DataPassing {
    weak var viewController: ___VARIABLE_sceneName___ViewController?
    var dataStore: ___VARIABLE_sceneName___DataStore?

    // MARK: - Routing Logic

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

    //func passDataToSomewhere(source: ___VARIABLE_sceneName___DataStore, destination: inout SomewhereDataStore) {
    //  destination.name = source.name
    //}
}
```

### Models
```swift
import UIKit

enum ___VARIABLE_sceneName___ {
    // MARK: Use cases

    enum Something {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
}
```

### Worker
```swift
import UIKit

class ___VARIABLE_sceneName___Worker {
    func doSomeWork() {
    }
}
```

### Header Comment
```swift
//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift CUSTOMIZED Xcode Templates (http://clean-swift.com)
//  Template: https://github.com/kodelit/CleanSwiftTemplates
//
```

## Unit Tests

### ViewControllerTests
```swift
@testable import ___PROJECTNAMEASIDENTIFIER___
import XCTest

class ___VARIABLE_sceneName___ViewControllerTests: XCTestCase {
    // MARK: Subject under test

    var sut: ___VARIABLE_sceneName___ViewController!
    var window: UIWindow!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setup___VARIABLE_sceneName___ViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setup___VARIABLE_sceneName___ViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "___VARIABLE_sceneName___ViewController") as! ___VARIABLE_sceneName___ViewController
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Test doubles

    class ___VARIABLE_sceneName___BusinessLogicSpy: ___VARIABLE_sceneName___BusinessLogic {
        var handleSomethingCalled = false

        func handle(request: ___VARIABLE_sceneName___.Something.Request) {
            handleSomethingCalled = true
        }
    }

    // MARK: Tests

    func testShouldDoSomethingWhenViewIsLoaded() {
        // Given
        let spy = ___VARIABLE_sceneName___BusinessLogicSpy()
        sut.interactor = spy

        // When
        loadView()

        // Then
        XCTAssertTrue(spy.handleSomethingCalled, "viewDidLoad() should ask the interactor to do something")
    }

    func testDisplaySomething() {
        // Given
        let viewModel = ___VARIABLE_sceneName___.Something.ViewModel()

        // When
        loadView()
        sut.display(viewModel: viewModel)

        // Then
        //XCTAssertEqual(sut.nameTextField.text, "", "displaySomething(viewModel:) should update the name text field")
    }
}
```

### PresenterTests
```swift
@testable import ___PROJECTNAMEASIDENTIFIER___
import XCTest

class ___VARIABLE_sceneName___PresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: ___VARIABLE_sceneName___Presenter!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setup___VARIABLE_sceneName___Presenter()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setup___VARIABLE_sceneName___Presenter() {
        sut = ___VARIABLE_sceneName___Presenter()
    }

    // MARK: Test doubles

    class ___VARIABLE_sceneName___DisplayLogicSpy: ___VARIABLE_sceneName___DisplayLogic {
        var displaySomethingCalled = false

        func display(viewModel: ___VARIABLE_sceneName___.Something.ViewModel) {
            displaySomethingCalled = true
        }
    }

    // MARK: Tests

    func testPresentSomething() {
        // Given
        let spy = ___VARIABLE_sceneName___DisplayLogicSpy()
        sut.viewController = spy
        let response = ___VARIABLE_sceneName___.Something.Response()

        // When
        sut.present(response: response)

        // Then
        XCTAssertTrue(spy.displaySomethingCalled, "presentSomething(response:) should ask the view controller to display the result")
    }
}
```

### InteractorTests
```swift
@testable import ___PROJECTNAMEASIDENTIFIER___
import XCTest

class ___VARIABLE_sceneName___InteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: ___VARIABLE_sceneName___Interactor!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setup___VARIABLE_sceneName___Interactor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setup___VARIABLE_sceneName___Interactor() {
        sut = ___VARIABLE_sceneName___Interactor()
    }

    // MARK: Test doubles

    class ___VARIABLE_sceneName___PresentationLogicSpy: ___VARIABLE_sceneName___PresentationLogic {
        var presentSomethingCalled = false

        func present(response: ___VARIABLE_sceneName___.Something.Response) {
            presentSomethingCalled = true
        }
    }

    // MARK: Tests

    func testDoSomething() {
        // Given
        let spy = ___VARIABLE_sceneName___PresentationLogicSpy()
        sut.presenter = spy
        let request = ___VARIABLE_sceneName___.Something.Request()

        // When
        sut.handle(request: request)

        // Then
        XCTAssertTrue(spy.presentSomethingCalled, "doSomething(request:) should ask the presenter to format the result")
    }
}
```

### WorkerTests
```swift
@testable import ___PROJECTNAMEASIDENTIFIER___
import XCTest

class ___VARIABLE_sceneName___WorkerTests: XCTestCase {
    // MARK: Subject under test

    var sut: ___VARIABLE_sceneName___Worker!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setup___VARIABLE_sceneName___Worker()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setup___VARIABLE_sceneName___Worker() {
        sut = ___VARIABLE_sceneName___Worker()
    }

    // MARK: Test doubles

    // MARK: Tests

    func testSomething() {
        // Given

        // When

        // Then
    }
}
```