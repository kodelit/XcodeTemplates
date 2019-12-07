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
