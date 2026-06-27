import Combine
import Foundation

protocol ArtistServiceProtocol {
    func fetchArtists() -> AnyPublisher<ArtistListResponse, APIError>
}

final class ArtistService: ArtistServiceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchArtists() -> AnyPublisher<ArtistListResponse, APIError> {
        apiClient.request(endpoint: ArtistEndpoint.list, body: Optional<EmptyRequest>.none, token: nil)
    }
}
