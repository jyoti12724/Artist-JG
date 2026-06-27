import Combine
import Foundation

protocol AuthServiceProtocol {
    func sendRegistrationOTP(request: RegistrationOTPRequest) -> AnyPublisher<APIMessageResponse, APIError>
    func register(request: RegisterRequest) -> AnyPublisher<AuthResponse, APIError>
    func login(request: LoginRequest) -> AnyPublisher<AuthResponse, APIError>
    func fetchMe(token: String) -> AnyPublisher<User, APIError>
}

final class AuthService: AuthServiceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func sendRegistrationOTP(request: RegistrationOTPRequest) -> AnyPublisher<APIMessageResponse, APIError> {
        apiClient.request(endpoint: AuthEndpoint.registrationOTP, body: request, token: nil)
    }

    func register(request: RegisterRequest) -> AnyPublisher<AuthResponse, APIError> {
        apiClient.request(endpoint: AuthEndpoint.register, body: request, token: nil)
    }

    func login(request: LoginRequest) -> AnyPublisher<AuthResponse, APIError> {
        apiClient.request(endpoint: AuthEndpoint.login, body: request, token: nil)
    }

    func fetchMe(token: String) -> AnyPublisher<User, APIError> {
        apiClient.request(endpoint: AuthEndpoint.me, body: Optional<EmptyRequest>.none, token: token)
    }
}
