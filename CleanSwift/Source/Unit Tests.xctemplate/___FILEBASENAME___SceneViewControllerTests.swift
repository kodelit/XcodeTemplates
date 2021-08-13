@testable import ___PROJECTNAMEASIDENTIFIER___
import XCTest

class ___VARIABLE_sceneName___SceneViewControllerTests: XCTestCase {
    // MARK: Subject under test

    var sut: ___VARIABLE_sceneName___SceneViewController!
    var window: UIWindow!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setup___VARIABLE_sceneName___SceneViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setup___VARIABLE_sceneName___SceneViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "___VARIABLE_sceneName___SceneViewController") as! ___VARIABLE_sceneName___SceneViewController
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Test doubles

    class ___VARIABLE_sceneName___SceneBusinessLogicSpy: ___VARIABLE_sceneName___SceneBusinessLogic {
        var handleSomethingCalled = false

        func handle(request: ___VARIABLE_sceneName___Scene.Something.Request) {
            handleSomethingCalled = true
        }
    }

    // MARK: Tests

    func testShouldDoSomethingWhenViewIsLoaded() {
        // Given
        let spy = ___VARIABLE_sceneName___SceneBusinessLogicSpy()
        sut.interactor = spy

        // When
        loadView()

        // Then
        XCTAssertTrue(spy.handleSomethingCalled, "viewDidLoad() should ask the interactor to do something")
    }

    func testDisplaySomething() {
        // Given
        let viewModel = ___VARIABLE_sceneName___Scene.Something.ViewModel()

        // When
        loadView()
        sut.display(viewModel: viewModel)

        // Then
        //XCTAssertEqual(sut.nameTextField.text, "", "displaySomething(viewModel:) should update the name text field")
    }
}
