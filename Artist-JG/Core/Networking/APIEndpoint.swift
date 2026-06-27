import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
}

extension APIEndpoint {
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }

    var url: URL? {
        URL(string: AppConstants.API.baseURL + path)
    }
}
