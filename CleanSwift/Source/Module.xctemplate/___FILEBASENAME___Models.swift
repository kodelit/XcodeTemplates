import Foundation

// MARK: - Module Specific Models

extension ___VARIABLE_moduleName___Module {

    /// Request to the external or internal delegate.
    ///
    /// - note: Provides cases for simple requests but also is a namespace for data structures of more complex requests.
    public enum Request {
        // MARK: External Request (Module -> module delegate)

        // Example of the optional external request from the module to the oudside delegate (if applicable)
        //public struct ExampleExternalRequest {
        //}

        // MARK: Internal Request (Module -> Interactor (Scene))

        // Example of the optional internal request from the module to the Interactor (Scene)
        //internal struct ExampleRequest {
        //}
    }

    /// Notification is a Response without the Request. It pushes the info to the external or internal delegate.
    ///
    /// - note: Provides cases for simple notifications but also is a namespace for data structures of more complex notifications.
    public enum Notification {
        // MARK: External Notification (Module -> module delegate)

        // Example of the optional external notification from the module to the oudside delegate (if applicable)
        //public struct ExampleExternalNotification {
        //}

        // MARK: Internal Notification (Module -> Interactor (Scene))

        // Example of the optional internal notification from the module to the Interactor (Scene)
        //internal struct ExampleNotification {
        //}
    }

    /// Response for the external or internal delegate.
    ///
    /// - note: Provides cases for simple responses but also is a namespace for data structures of more complex responses.
    public enum Response {
        // MARK: External Response (Module -> module delegate)

        // Example of the optional external response from the module to the oudside delegate (if applicable)
        //public struct ExampleExternalResponse {
        //}

        // MARK: Internal Response (Module -> Interactor (Scene))

        // Example of the optional internal Response from the module to the Interactor (Scene)
        //internal struct ExampleResponse {
        //}
    }
}

extension ___VARIABLE_moduleName___Module.Request {
    //public struct ___VARIABLE_moduleName___Data {
    //    public let id: String
    //    public let success: ([Resident]) -> Void
    //    public let failure: () -> Void
    //}
}

// MARK: - General Purpose Models

public struct ___VARIABLE_moduleName___Data: Codable {
    //public var id: String
    //public var name: String?
}
