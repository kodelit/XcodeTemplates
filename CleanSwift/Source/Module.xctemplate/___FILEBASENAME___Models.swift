import Foundation

// MARK: - General Purpose Models

public struct ___VARIABLE_moduleName___Data: Codable {
    public typealias Id = String

    //public var id: Id
    //public var name: String?
}

// MARK: - Module Specific Models

extension ___VARIABLE_moduleName___Module {

    public struct InputData {
        //public let title: String
    }

    /// Request to the external or internal delegate.
    ///
    /// - note: Provides cases for simple requests but also is a namespace for data structures of more complex requests.
    public enum Request {
        public struct ___VARIABLE_moduleName___Data {
            //public let id: String
            public let success: () -> Void
            public let failure: (() -> Void)?
        }
    }

    /// Notification is a Response without the Request. It pushes the info to the external or internal delegate.
    ///
    /// - note: Provides cases for simple notifications but also is a namespace for data structures of more complex notifications.
    public enum Notification {
        case reload(with id: String)
    }
}
