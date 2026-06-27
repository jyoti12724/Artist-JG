import SwiftUI

struct RootView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        switch coordinator.route {
        case .login:
            LoginView()
        case .signUp:
            SignUpView()
        case .home(let user):
            HomeView(user: user)
        }
    }
}
