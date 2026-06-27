import Foundation

struct APIMessageResponse: Decodable {
    let message: String?
    let success: Bool?
    let error: String?
    let detail: String?
    let details: String?

    var resolvedMessage: String? {
        message ?? error ?? detail ?? details
    }
}
