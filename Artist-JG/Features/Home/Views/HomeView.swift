import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel = ArtistListViewModel()
    let user: User?

    var body: some View {
        NavigationStack {
            ZStack {
                AuthTheme.background
                    .ignoresSafeArea()

                VStack(spacing: 18) {
                    header

                    if viewModel.isLoading && viewModel.artists.isEmpty {
                        Spacer()
                        ProgressView()
                            .tint(AuthTheme.fieldBorder)
                        Spacer()
                    } else if viewModel.artists.isEmpty {
                        Spacer()
                        emptyState
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(viewModel.artists) { artist in
                                    ArtistCardView(artist: artist)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 24)
                        }
                        .refreshable {
                            viewModel.loadArtists()
                        }
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                viewModel.loadArtists()
            }
            .alert(
                "Message",
                isPresented: Binding(
                    get: { viewModel.alertMessage != nil },
                    set: { if !$0 { viewModel.alertMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage ?? "")
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Artists")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(AuthTheme.title)

                    Text("Welcome, \(user?.displayName ?? "User")")
                        .font(.subheadline)
                        .foregroundStyle(AuthTheme.secondaryText)
                }

                Spacer()

                Button("Logout") {
                    coordinator.logout()
                }
                .buttonStyle(.plain)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AuthTheme.fieldBorder)
            }

            Text("\(viewModel.artists.count) artists available")
                .font(.footnote.weight(.medium))
                .foregroundStyle(AuthTheme.secondaryText)
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("No artists found")
                .font(.headline)
                .foregroundStyle(AuthTheme.title)

            PrimaryButton(title: "Retry", isLoading: viewModel.isLoading) {
                viewModel.loadArtists()
            }
            .padding(.horizontal, 20)
        }
    }
}

private struct ArtistCardView: View {
    let artist: Artist

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                artistAvatar

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(artist.name)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(AuthTheme.title)

                        if artist.isVerified {
                            Text("Verified")
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .foregroundStyle(.white)
                                .background(AuthTheme.accentBlue)
                                .clipShape(Capsule())
                        }

                        if artist.isVip {
                            Text("VIP")
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .foregroundStyle(.white)
                                .background(AuthTheme.accent)
                                .clipShape(Capsule())
                        }
                    }

                    Text("\(artist.category) • \(artist.city)")
                        .font(.subheadline)
                        .foregroundStyle(AuthTheme.secondaryText)

                    Text("Rating \(artist.ratingText) • \(artist.totalReviews) reviews")
                        .font(.caption)
                        .foregroundStyle(AuthTheme.secondaryText)
                }

                Spacer()
            }

            Divider()
                .background(AuthTheme.fieldBorder.opacity(0.2))

            HStack(spacing: 12) {
                pricingItem(title: "Base", value: artist.basePrice.priceText)
                pricingItem(title: "Hourly", value: artist.hourlyRate.priceText)
                pricingItem(title: "Full day", value: artist.fullDayRate.priceText)
            }

            if !artist.availabilityNotes.isEmpty {
                Text(artist.availabilityNotes)
                    .font(.footnote)
                    .foregroundStyle(AuthTheme.secondaryText)
            }

            Text(artist.travelsOutsideCity ? "Travels outside city" : "City bookings only")
                .font(.caption.weight(.semibold))
                .foregroundStyle(artist.travelsOutsideCity ? AuthTheme.accentBlue : AuthTheme.accent)
        }
        .padding(16)
        .background(AuthTheme.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(AuthTheme.fieldBorder.opacity(0.35), lineWidth: 1)
        }
        .shadow(color: AuthTheme.fieldBorder.opacity(0.08), radius: 12, x: 0, y: 6)
    }

    private var artistAvatar: some View {
        ZStack {
            LinearGradient(
                colors: [AuthTheme.accent, AuthTheme.fieldBorder, AuthTheme.accentBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Text(String(artist.name.prefix(1)).uppercased())
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
        }
        .frame(width: 54, height: 54)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func pricingItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(AuthTheme.secondaryText)

            Text(value)
                .font(.footnote.weight(.bold))
                .foregroundStyle(AuthTheme.title)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension Artist {
    var ratingText: String {
        String(format: "%.1f", rating)
    }
}

private extension Double {
    var priceText: String {
        String(format: "Rs %.0f", self)
    }
}
