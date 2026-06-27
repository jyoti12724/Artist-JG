import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel = AuthViewModel()
    @State private var currentStep: SignUpStep = .contact

    var body: some View {
        NavigationStack {
            ZStack {
                AuthTheme.background
                    .ignoresSafeArea()

                signupContent
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .alert(
                "Message",
                isPresented: Binding(
                    get: { viewModel.alertMessage != nil },
                    set: { if !$0 { viewModel.alertMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage ?? "")
            }
        }
    }

    private var signupContent: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 24) {
                    header
                        .padding(.top, 58)

                    stepIndicator

                    Group {
                        switch currentStep {
                        case .contact:
                            contactStep
                        case .details:
                            detailsStep
                        }
                    }

                    Spacer(minLength: 18)

                    Button(AppStrings.Auth.goToLoginTitle) {
                        coordinator.showLogin()
                    }
                    .buttonStyle(.plain)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AuthTheme.fieldBorder)
                }
                .frame(maxWidth: 520)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .frame(maxWidth: .infinity)
                .frame(minHeight: proxy.size.height)
            }
            .scrollContentBackground(.hidden)
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Text(AppStrings.Auth.signUpTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(AuthTheme.title)

            Text(currentStep.subtitle)
                .font(.subheadline)
                .foregroundStyle(AuthTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
    }

    private var stepIndicator: some View {
        HStack(spacing: 10) {
            Capsule()
                .fill(AuthTheme.accent)
                .frame(width: currentStep == .contact ? 38 : 18, height: 6)

            Capsule()
                .fill(currentStep == .details ? AuthTheme.accentBlue : AuthTheme.fieldBorder.opacity(0.25))
                .frame(width: currentStep == .details ? 38 : 18, height: 6)
        }
        .animation(.easeInOut(duration: 0.2), value: currentStep)
    }

    private var contactStep: some View {
        VStack(spacing: 16) {
            AuthTextField(
                title: AppStrings.Auth.emailPlaceholder,
                text: $viewModel.email,
                keyboardType: .email
            )

            AuthTextField(
                title: AppStrings.Auth.phonePlaceholder,
                text: $viewModel.phoneNumber,
                keyboardType: .phone
            )

            PrimaryButton(
                title: AppStrings.Auth.sendOtpButtonTitle,
                isLoading: viewModel.isLoading
            ) {
                viewModel.sendRegistrationOTP {
                    currentStep = .details
                }
            }
            .padding(.top, 4)
        }
    }

    private var detailsStep: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                AuthTextField(title: AppStrings.Auth.firstNamePlaceholder, text: $viewModel.firstName)
                AuthTextField(title: AppStrings.Auth.lastNamePlaceholder, text: $viewModel.lastName)
                AuthTextField(
                    title: AppStrings.Auth.passwordPlaceholder,
                    text: $viewModel.password,
                    isSecure: true
                )
                AuthTextField(
                    title: AppStrings.Auth.emailOtpPlaceholder,
                    text: $viewModel.emailOtp,
                    keyboardType: .number
                )
                AuthTextField(
                    title: AppStrings.Auth.phoneOtpPlaceholder,
                    text: $viewModel.phoneOtp,
                    keyboardType: .number
                )
            }

            PrimaryButton(
                title: AppStrings.Auth.signUpButtonTitle,
                isLoading: viewModel.isLoading
            ) {
                viewModel.register { user in
                    coordinator.showHome(user: user)
                }
            }

            Button("Back") {
                currentStep = .contact
            }
            .buttonStyle(.plain)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(AuthTheme.accent)
        }
    }
}

private enum SignUpStep {
    case contact
    case details

    var subtitle: String {
        switch self {
        case .contact:
            return "Enter email and phone number"
        case .details:
            return "Complete your details"
        }
    }
}
