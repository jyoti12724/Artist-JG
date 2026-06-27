import Foundation

enum AppConstants {
    enum API {
        static let baseURL = "http://139.84.173.186"
        static let timeoutInterval: TimeInterval = 30
    }

    enum Auth {
        static let defaultRole = "user"
        static let bearerPrefix = "Bearer"
    }
}
