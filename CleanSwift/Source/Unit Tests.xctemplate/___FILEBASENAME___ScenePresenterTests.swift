@testable import ___PROJECTNAMEASIDENTIFIER___
import XCTest

class ___VARIABLE_sceneName___ScenePresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: ___VARIABLE_sceneName___ScenePresenter!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setup___VARIABLE_sceneName___ScenePresenter()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setup___VARIABLE_sceneName___ScenePresenter() {
        sut = ___VARIABLE_sceneName___ScenePresenter()
    }

    // MARK: Test doubles

    class ___VARIABLE_sceneName___SceneDisplayLogicSpy: ___VARIABLE_sceneName___SceneDisplayLogic {
        var displaySomethingCalled = false

        func display(viewModel: ___VARIABLE_sceneName___Scene.Something.ViewModel) {
            displaySomethingCalled = true
        }
    }

    // MARK: Tests

    func testPresentSomething() {
        // Given
        let spy = ___VARIABLE_sceneName___SceneDisplayLogicSpy()
        sut.viewController = spy
        let response = ___VARIABLE_sceneName___Scene.Something.Response()

        // When
        sut.present(response: response)

        // Then
        XCTAssertTrue(spy.displaySomethingCalled, "presentSomething(response:) should ask the view controller to display the result")
    }
}
