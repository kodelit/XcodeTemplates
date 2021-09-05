import UIKit

enum ___VARIABLE_sceneName___Scene {
    // MARK: - Routing (ViewModel -> Router)

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

    // MARK: - View Model (ViewModel -> UI)

    /// Model to display
    struct InitialSetup {
        var screenTitle: String?
    }

    enum SubviewModel {
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

    // MARK: - Request (UI -> ViewModel)

    /// UI Lifecycle event forwarding
    enum LifecycleEvent {
        case viewDidLoad, viewWillAppear
    }

    /// User Interface request
    ///
    /// - note: Provides cases for simple requests but also is a namespace for data structures of more complex requests.
    enum UserAction {
        case backButton, refresh
        //case didSelectRow(at: IndexPath)
    }
}

// MARK: - ___VARIABLE_sceneName___ table subview model

extension ___VARIABLE_sceneName___Scene.SubviewModel {
    //struct Table: SimpleTableViewModel {
    //    struct Row {
    //        let id: String
    //        let title: String
    //        let detail: String
    //    }
    //
    //    struct Section {}
    //
    //    private(set) var sections: [Section]
    //    private(set) var rows: [[Row]]
    //}
}
