import SwiftUI

struct DeleteButton: View {
    var text: String = "Remove"
    let onDelete: () -> Void

    var body: some View {
        Button(role: .destructive) {
            onDelete()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "trash")
                Text(text)
            }
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .modifier(RoundedBackground())
        }
    }
}
