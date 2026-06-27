import Foundation

enum AuthEndpoint: APIEndpoint {
    case registrationOTP
    case register
    case login
    case me
    case adminUsers

    var path: String {
        switch self {
        case .registrationOTP:
            return "/api/auth/registration-otp"
        case .register:
            return "/api/auth/register"
        case .login:
            return "/api/auth/login"
        case .me:
            return "/api/auth/me"
        case .adminUsers:
            return "/api/auth/admin/users"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .registrationOTP, .register, .login, .adminUsers:
            return .post
        case .me:
            return .get
        }
    }
}
