import Combine
import Foundation

final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var emailOtp = ""
    @Published var phoneOtp = ""

    @Published private(set) var isLoading = false
    @Published var alertMessage: String?

    private let authService: AuthServiceProtocol
    private var tokenStore: AuthTokenStoreProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        authService: AuthServiceProtocol = AuthService(),
        tokenStore: AuthTokenStoreProtocol = AuthTokenStore()
    ) {
        self.authService = authService
        self.tokenStore = tokenStore
    }

    func login(onSuccess: @escaping (User?) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = AppStrings.Error.emptyFields
            return
        }

        isLoading = true

        authService.login(request: LoginRequest(email: email, password: password))
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.alertMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.saveTokenIfAvailable(from: response)
                onSuccess(response.resolvedUser)
            }
            .store(in: &cancellables)
    }

    func sendRegistrationOTP(onSuccess: (() -> Void)? = nil) {
        guard !email.isEmpty, !phoneNumber.isEmpty else {
            alertMessage = AppStrings.Error.emptyFields
            return
        }

        isLoading = true

        let request = RegistrationOTPRequest(
            email: email,
            phoneNumber: phoneNumber,
            role: AppConstants.Auth.defaultRole
        )

        authService.sendRegistrationOTP(request: request)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.alertMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.alertMessage = response.message ?? "OTP sent successfully."
                onSuccess?()
            }
            .store(in: &cancellables)
    }

    func register(onSuccess: @escaping (User?) -> Void) {
        guard !email.isEmpty,
              !phoneNumber.isEmpty,
              !password.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !emailOtp.isEmpty,
              !phoneOtp.isEmpty else {
            alertMessage = AppStrings.Error.emptyFields
            return
        }

        isLoading = true

        let request = RegisterRequest(
            email: email,
            phoneNumber: phoneNumber,
            password: password,
            firstName: firstName,
            lastName: lastName,
            role: AppConstants.Auth.defaultRole,
            emailOtp: emailOtp,
            phoneOtp: phoneOtp
        )

        authService.register(request: request)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.alertMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.saveTokenIfAvailable(from: response)
                onSuccess(response.resolvedUser)
            }
            .store(in: &cancellables)
    }

    private func saveTokenIfAvailable(from response: AuthResponse) {
        if let token = response.resolvedToken {
            tokenStore.token = token
        }
    }
}
