import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                AuthTheme.background
                    .ignoresSafeArea()

                VStack(spacing: 28) {
                    VStack(spacing: 10) {
                        Text(AppStrings.Auth.loginTitle)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(AuthTheme.title)

                        Text("Welcome back")
                            .font(.subheadline)
                            .foregroundStyle(AuthTheme.secondaryText)
                    }
                    .padding(.top, 58)

                    VStack(spacing: 14) {
                        AuthTextField(
                            title: AppStrings.Auth.emailPlaceholder,
                            text: $viewModel.email,
                            keyboardType: .email
                        )

                        AuthTextField(
                            title: AppStrings.Auth.passwordPlaceholder,
                            text: $viewModel.password,
                            isSecure: true
                        )
                    }

                    Spacer(minLength: 18)

                    PrimaryButton(
                        title: AppStrings.Auth.loginButtonTitle,
                        isLoading: viewModel.isLoading
                    ) {
                        viewModel.login { user in
                            coordinator.showHome(user: user)
                        }
                    }

                    Spacer(minLength: 18)

                    Button(AppStrings.Auth.goToSignUpTitle) {
                        coordinator.showSignUp()
                    }
                    .buttonStyle(.plain)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AuthTheme.fieldBorder)
                }
                .frame(maxWidth: 520)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
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
}
