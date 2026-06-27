import Foundation

enum ArtistEndpoint: APIEndpoint {
    case list

    var path: String {
        switch self {
        case .list:
            return "/api/artists"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        }
    }
}
