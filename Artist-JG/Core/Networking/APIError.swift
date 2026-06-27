import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case server(message: String, statusCode: Int, correlationID: String?)
    case decoding(Error)
    case request(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return AppStrings.Error.invalidURL
        case .invalidResponse:
            return AppStrings.Error.invalidResponse
        case .server(let message, let statusCode, let correlationID):
            var description = "\(message) (Status \(statusCode))"
            if let correlationID {
                description += "\nRequest ID: \(correlationID)"
            }
            return description
        case .decoding:
            return AppStrings.Error.unknown
        case .request(let error):
            return error.localizedDescription
        }
    }
}
