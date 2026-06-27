import Foundation

struct RegistrationOTPRequest: Encodable {
    let email: String
    let phoneNumber: String
    let role: String
}

struct RegisterRequest: Encodable {
    let email: String
    let phoneNumber: String
    let password: String
    let firstName: String
    let lastName: String
    let role: String
    let emailOtp: String
    let phoneOtp: String
}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct AuthResponse: Decodable {
    let message: String?
    let token: String?
    let accessToken: String?
    let data: AuthData?
    let user: User?

    var resolvedToken: String? {
        token ?? accessToken ?? data?.token ?? data?.accessToken
    }

    var resolvedUser: User? {
        user ?? data?.user
    }
}

struct AuthData: Decodable {
    let token: String?
    let accessToken: String?
    let user: User?
}

struct User: Decodable, Identifiable {
    let id: String?
    let email: String?
    let phoneNumber: String?
    let firstName: String?
    let lastName: String?
    let role: String?

    var displayName: String {
        let name = [firstName, lastName]
            .compactMap { $0 }
            .joined(separator: " ")

        return name.isEmpty ? (email ?? "User") : name
    }
}

struct EmptyRequest: Encodable {}
