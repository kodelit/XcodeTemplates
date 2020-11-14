import UIKit

extension ___VARIABLE_sceneName___ {
    // MARK: - Request (UI -> interactor)

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

    /// User's request / action
    ///
    /// - note: Provides cases for simple requests but also is a namespace for data structures of more complex requests.
    enum UserRequest {
        //case someButtonAction
    }

    // MARK: - Response (interactor -> presenter)

    /// Received notification to display.
    ///
    /// Notification is a Response without the Request. It pushes the info to the presenter.
    /// It might be triggered with:
    /// - remote/local notification
    /// - notification about some event/change reported by the system like authorization status change of some service
    /// - notification about change of some observed value
    ///
    /// - note: Provides cases for simple notifications but also is a namespace for data structures of more complex notifications.
    enum Notification {
        //case invitation(displayName: String, accept: (Bool) -> Void)
    }

    /// The response of the Interactor on a `LifecycleEvent` or the `UserRequest`
    enum ResponseForUser {
        case reloadData
        //case deselectRow(at: IndexPath)
    }

    // MARK: - View Model (presenter -> UI)

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

    // MARK: - Module Comunication (Module / scene root <-> interactor)

    enum ModuleRequest {
    }

    /// The response of the Interactor on the `ModuleRequest`
    enum ResponseForModule {
    }

    // MARK: Routing

    /// Routing destination descriptor.
    ///
    /// - note: Provides cases for simple navigation but also is a namespace for data structures of more complex navigation.
    enum Destination {
    }
}
