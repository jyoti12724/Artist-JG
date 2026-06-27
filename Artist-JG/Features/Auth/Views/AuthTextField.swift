import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum AuthTheme {
    static let background = Color.white
    static let title = Color(red: 0.12, green: 0.10, blue: 0.18)
    static let secondaryText = Color(red: 0.42, green: 0.39, blue: 0.48)
    static let accent = Color(red: 0.89, green: 0.05, blue: 0.62)
    static let accentBlue = Color(red: 0.02, green: 0.62, blue: 0.92)
    static let fieldBorder = Color(red: 0.55, green: 0.16, blue: 0.88)
    static let fieldBackground = Color.white
}

enum AuthKeyboardType {
    case `default`
    case email
    case phone
    case number

    #if canImport(UIKit)
    var uiKeyboardType: UIKeyboardType {
        switch self {
        case .default:
            return .default
        case .email:
            return .emailAddress
        case .phone:
            return .phonePad
        case .number:
            return .numberPad
        }
    }
    #endif
}

struct AuthTextField: View {
    let title: String
    @Binding var text: String
    var isSecure = false
    var keyboardType: AuthKeyboardType = .default

    var body: some View {
        inputField
            .padding(.horizontal, 16)
            .frame(height: 54)
            .foregroundStyle(AuthTheme.title)
            .background(AuthTheme.fieldBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(AuthTheme.fieldBorder.opacity(0.8), lineWidth: 1.4)
            }
    }

    @ViewBuilder
    private var inputField: some View {
        if isSecure {
            SecureField(title, text: $text)
                .authTextInputStyle(.default)
        } else {
            TextField(title, text: $text)
                .authTextInputStyle(keyboardType)
        }
    }
}

private extension View {
    @ViewBuilder
    func authTextInputStyle(_ type: AuthKeyboardType) -> some View {
        #if canImport(UIKit)
        keyboardType(type.uiKeyboardType)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
        #else
        self
        #endif
    }
}
