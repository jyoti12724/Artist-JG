import Foundation

protocol AuthTokenStoreProtocol {
    var token: String? { get set }
    func clear()
}

final class AuthTokenStore: AuthTokenStoreProtocol {
    private enum Keys {
        static let authToken = "auth_token"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var token: String? {
        get { userDefaults.string(forKey: Keys.authToken) }
        set { userDefaults.set(newValue, forKey: Keys.authToken) }
    }

    func clear() {
        userDefaults.removeObject(forKey: Keys.authToken)
    }
}
