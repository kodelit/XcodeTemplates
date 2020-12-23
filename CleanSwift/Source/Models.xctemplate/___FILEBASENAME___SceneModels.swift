import UIKit

enum ___VARIABLE_sceneName___Scene {
    // MARK: - Request (Interactor/ViewModel -> Module/Outside)

    /// External request for the module/outside the scene.
    enum Request {
        struct Data {
            // Some params here
            // ...

            let success: () -> Void
            let failure: () -> Void?
        }
    }

    // MARK: - Routing (Interactor/ViewModel -> Router)

    //enum ExitReason {
    //    case none
    //}

    //enum ExitResult {
    //    case none
    //}

    /// Routing destination descriptor.
    ///
    /// - note: Provides cases for simple navigation but also is a namespace for data structures of more complex navigation.
    enum Destination {
        // Represents end of the scene or navigation backward
        case exit
        //case exit(reason: ExitReason = .none)
        //case exit(result: ExitResult = .none)
    }

    // MARK: - View Model (Presenter/ViewModel -> UI)

    /// Model to display
    struct InitialSetup {
    }

    /// Update of the part of the UI
    ///
    /// - note: Provides cases for simple updates but also is a namespace for data structures of more complex updates.
    enum Update {
        //case deselectRow(at: IndexPath, animated: Bool)

        // Update use case triggering more complex update logic
        //struct SomeUpdate {
        //    let someFlag: Bool
        //}
    }

    // MARK: - Request (UI -> Interactor/ViewModel)

    /// UI Lifecycle event forwarding
    enum LifecycleEvent {
        case viewDidLoad, viewWillAppear
    }

    /// User Interface request
    ///
    /// - note: Provides cases for simple requests but also is a namespace for data structures of more complex requests.
    enum UserAction {
        case backButton
        //case didSelectRow(at: IndexPath)
    }

    // MARK: - Response (Interactor -> Presenter)

    /// Received notification to display.
    ///
    /// Notification is a Response without the Request. It pushes the info to the presenter.
    /// It might be triggered with:
    /// - remote/local notification
    /// - NotificationCenter notification
    /// - notification about some event/change reported by the system like authorization status change of some service
    /// - notification about change of some observed value
    ///
    /// - note: Provides cases for simple notifications but also is a namespace for data structures of more complex notifications.
    enum Notification {
        //case invitation(displayName: String, accept: (Bool) -> Void)
    }

    enum Response {
        // MARK: The responses of the Interactor on the `LifecycleEvent` or on the `UserAction`
        case initialSetup
        //case deselectRow(at: IndexPath)
    }
}
