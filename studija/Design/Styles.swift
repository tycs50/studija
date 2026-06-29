import SwiftUI

struct RoundedBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 18)
            .background(Color(white: 0.12))
            .cornerRadius(16)
    }
}

struct PressButtonStyle: ButtonStyle {
    @State var isPressed = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .brightness(isPressed ? -0.06 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: isPressed)
            .onChange(of: configuration.isPressed) { newValue in
                isPressed = newValue
            }
    }
}
