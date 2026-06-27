import Combine
import Foundation

final class ArtistListViewModel: ObservableObject {
    @Published private(set) var artists: [Artist] = []
    @Published private(set) var isLoading = false
    @Published var alertMessage: String?

    private let artistService: ArtistServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(artistService: ArtistServiceProtocol = ArtistService()) {
        self.artistService = artistService
    }

    func loadArtists() {
        guard !isLoading else { return }

        isLoading = true

        artistService.fetchArtists()
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.alertMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.artists = response.items
            }
            .store(in: &cancellables)
    }
}
