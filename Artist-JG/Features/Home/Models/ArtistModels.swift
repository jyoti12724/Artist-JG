import Foundation

struct ArtistListResponse: Decodable {
    let items: [Artist]
    let totalCount: Int
    let page: Int
    let pageSize: Int
    let totalPages: Int
}

struct Artist: Decodable, Identifiable {
    let id: String
    let name: String
    let category: String
    let city: String
    let rating: Double
    let totalReviews: Int
    let basePrice: Double
    let isVerified: Bool
    let planCode: String
    let planBillingModel: String
    let planCommissionPercent: Double
    let planRankingBoost: Int
    let isVip: Bool
    let bookingPricingMode: String
    let hourlyRate: Double
    let fullDayRate: Double
    let minimumBookingHours: Double
    let includedTravelKm: Double
    let travelFeePerKm: Double
    let maxTravelDistanceKm: Double
    let travelsOutsideCity: Bool
    let availabilityNotes: String
    let profileImageUrl: String
}
