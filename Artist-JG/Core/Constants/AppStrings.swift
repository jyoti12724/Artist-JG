import Foundation

enum AppStrings {
    enum Auth {
        static let loginTitle = "Login"
        static let signUpTitle = "Sign Up"
        static let emailPlaceholder = "Email"
        static let phonePlaceholder = "Phone Number"
        static let passwordPlaceholder = "Password"
        static let firstNamePlaceholder = "First Name"
        static let lastNamePlaceholder = "Last Name"
        static let emailOtpPlaceholder = "Email OTP"
        static let phoneOtpPlaceholder = "Phone OTP"
        static let loginButtonTitle = "Login"
        static let signUpButtonTitle = "Create Account"
        static let sendOtpButtonTitle = "Send OTP"
        static let goToSignUpTitle = "Create new account"
        static let goToLoginTitle = "Already have an account?"
    }

    enum Error {
        static let invalidURL = "Invalid API URL."
        static let invalidResponse = "Invalid server response."
        static let emptyFields = "Please fill all required fields."
        static let unknown = "Something went wrong. Please try again."
    }
}
