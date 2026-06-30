import SwiftUI

struct EmptyListView: View {
    var text: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "moon.stars")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.25))
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.3))
        }
    }
}
