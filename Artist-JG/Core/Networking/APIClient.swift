import Combine
import Foundation

protocol APIClientProtocol {
    func request<T: Decodable, Body: Encodable>(
        endpoint: APIEndpoint,
        body: Body?,
        token: String?
    ) -> AnyPublisher<T, APIError>
}

final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    func request<T: Decodable, Body: Encodable>(
        endpoint: APIEndpoint,
        body: Body? = nil,
        token: String? = nil
    ) -> AnyPublisher<T, APIError> {
        guard let url = endpoint.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url, timeoutInterval: AppConstants.API.timeoutInterval)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        if let token {
            request.setValue(
                "\(AppConstants.Auth.bearerPrefix) \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }

        if let body {
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                return Fail(error: APIError.request(error)).eraseToAnyPublisher()
            }
        }

        return session.dataTaskPublisher(for: request)
            .mapError(APIError.request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    let apiMessage = try? self.decoder.decode(APIMessageResponse.self, from: data)
                    let fallbackMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    let correlationID = httpResponse.value(forHTTPHeaderField: "X-Correlation-ID")
                    throw APIError.server(
                        message: apiMessage?.resolvedMessage ?? fallbackMessage,
                        statusCode: httpResponse.statusCode,
                        correlationID: correlationID
                    )
                }

                return data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if let apiError = error as? APIError {
                    return apiError
                }
                if error is DecodingError {
                    return APIError.decoding(error)
                }
                return APIError.request(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
