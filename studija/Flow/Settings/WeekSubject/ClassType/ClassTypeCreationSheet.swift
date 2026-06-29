import SwiftUI

struct CustomTypeCreationSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var typeName: String = ""
    @State private var selectedIcon: String = "book.fill"
    @State private var selectedColorHex: String = "#FF3B30"

    var onSave: (SubjectType) -> Void

    private let icons = [
        "book.fill", "graduationcap.fill", "pencil.and.outline", "flask.fill",
        "globe.desk", "chart.bar.xaxis", "briefcase.fill", "theatermasks.fill",
        "sportscourt.fill", "waveform.path", "function", "brain.head.profile"
    ]

    private let colors = [
        "#FF3B30", "#FF9F0A", "#FFCC00", "#34C759",
        "#00C7BE", "#30B0C7", "#32ADE6", "#007AFF",
        "#5856D6", "#AF52DE", "#FF2D55", "#A2845E"
    ]

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {

                        VStack(spacing: 8) {
                            Text("Preview")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.4))

                            HStack(spacing: 6) {
                                Image(systemName: selectedIcon)
                                    .frame(width: 28, height: 28, alignment: .center)
                                Text(typeName.isEmpty ? "TYPE NAME" : typeName.uppercased())
                            }
                            .font(.system(size: 14, weight: .bold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color(hex: selectedColorHex).opacity(0.15))
                            .foregroundColor(Color(hex: selectedColorHex))
                            .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(white: 0.07))
                        .cornerRadius(16)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6))

                            TextField("e.g. Consultation, Exam", text: $typeName)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(Color(white: 0.11))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select Icon")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6))

                            LazyVGrid(columns: columns, spacing: 14) {
                                ForEach(icons, id: \.self) { icon in
                                    let isSelected = selectedIcon == icon
                                    Image(systemName: icon)
                                        .font(.system(size: 20))
                                        .foregroundColor(isSelected ? Color(hex: selectedColorHex) : .white.opacity(0.6))
                                        .frame(maxWidth: .infinity, minHeight: 50)
                                        .background(isSelected ? Color(hex: selectedColorHex).opacity(0.1) : Color(white: 0.11))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(isSelected ? Color(hex: selectedColorHex) : Color.clear, lineWidth: 1.5)
                                        )
                                        .onTapGesture {
                                            selectedIcon = icon
                                        }
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select Color")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6))

                            LazyVGrid(columns: columns, spacing: 14) {
                                ForEach(colors, id: \.self) { hex in
                                    let isSelected = selectedColorHex == hex
                                    Circle()
                                        .fill(Color(hex: hex))
                                        .frame(width: 34, height: 34)
                                        .frame(maxWidth: .infinity, minHeight: 50)
                                        .background(Color(white: 0.11))
                                        .cornerRadius(12)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: isSelected ? 2 : 0)
                                                .frame(width: 22, height: 22)
                                        )
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.2)) {
                                                selectedColorHex = hex
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white.opacity(0.6))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        let newType = SubjectType(name: typeName, iconName: selectedIcon, colorHex: selectedColorHex)
                        onSave(newType)
                        dismiss()
                    }
                    .disabled(typeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .foregroundColor(typeName.isEmpty ? .gray : Color(hex: selectedColorHex))
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(white: 0.05), for: .navigationBar)
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium, .large]) // Красиво открывается наполовину экрана
    }
}
