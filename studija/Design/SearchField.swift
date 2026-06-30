import SwiftUI

struct SearchField: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.4))

            TextField("Search", text: $searchText)
                .foregroundColor(.white)
                .tint(.white)

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.4))
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 46)
        .background(Color(white: 0.11))
        .cornerRadius(12)
    }
}
