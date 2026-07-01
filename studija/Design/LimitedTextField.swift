import SwiftUI

struct LimitedTextField: View {
    @Binding var text: String
    var placeholder: String
    var limit: Int
    var font: Font = .system(size: 28, weight: .bold, design: .default)
    var limitFont: Font = .system(size: 13, weight: .regular, design: .default)

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            TextField(placeholder, text: $text, axis: .vertical)
                .font(font)
                .lineLimit(1...10)
                .onChange(of: text) { _, newValue in
                    if newValue.count > limit {
                        text = String(text.prefix(limit))
                    }
                }

            Text("\(text.count)/\(limit)")
                .font(limitFont)
                .foregroundStyle(.secondary)
        }
    }
}
