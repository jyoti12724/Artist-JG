import Foundation

final class AppCoordinator: ObservableObject {
    @Published var route: AppRoute = .login

    func showLogin() { route = .login }

    func showSignUp() { route = .signUp }

    func showHome(user: User?) { route = .home(user) }

    func logout() {
        AuthTokenStore().clear()
        route = .login
    }
}
