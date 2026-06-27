import SwiftUI

struct PrimaryButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .foregroundStyle(.white)
            .background(buttonBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: AuthTheme.accent.opacity(0.22), radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .opacity(isLoading ? 0.8 : 1)
    }

    private var buttonBackground: LinearGradient {
        LinearGradient(
            colors: [AuthTheme.accent, AuthTheme.fieldBorder, AuthTheme.accentBlue],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
