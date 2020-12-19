import UIKit

enum ___VARIABLE_sceneName___Scene {
    // MARK: - View Model (Presenter/ViewModel -> UI)

    /// Model to display
    struct ViewModel {
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

    // MARK: Use cases

    // Models encapsulated in the use case
    //enum Something {
    //    struct Request {
    //    }
    //    struct Response {
    //    }
    //    struct ViewModel {
    //    }
    //}

    // MARK: - Request (UI -> Interactor/ViewModel)

    /// UI Lifecycle event forwarding
    enum LifecycleEvent {
        case viewDidLoad
    }

    /// Table view lifecycle event (data source or delegate forwarding)
    //enum TableEvent {
    //    /// Forwarding of the UITableViewDataSource `func tableView(_:commit:forRowAt:)`.
    //    /// Indicates that data source (view model) has to be updated
    //    case commit(editingStyle: UITableViewCell.EditingStyle, indexPath: IndexPath)
    //    /// Forwarding of the UITableViewDataSource `func tableView(_:moveRowAt:to:)`.
    //    /// Indicates that data source (view model) has to be updated
    //    case move(rowAt: IndexPath, to: IndexPath)
    //
    //    case didSelectRow(at: IndexPath)
    //    case didDeselectRow(at: IndexPath)
    //}

    /// User Interface request
    ///
    /// - note: Provides cases for simple requests but also is a namespace for data structures of more complex requests.
    enum UserAction {
        //case buttonAction
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
        case reloadData
        //case deselectRow(at: IndexPath)

        //struct ExampleResponse {
        //}

        // MARK: The responses of the Interactor on the mudule `___VARIABLE_moduleName___.Request`

        //struct ExampleResponseForModuleRequest {
        //}
    }

    // MARK: - Request (Interactor/ViewModel -> Module)

    /// Request for the module.
    enum Request {
    }

    // MARK: - Routing (Interactor/ViewModel -> Router)

    /// Routing destination descriptor.
    ///
    /// - note: Provides cases for simple navigation but also is a namespace for data structures of more complex navigation.
    enum Destination {
        // Represents end of the scene or navigation backward
        case exit
    }
}
