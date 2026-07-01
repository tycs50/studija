import SwiftUI
import CoreData

struct CustomTypeCreationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    let typeToEdit: SubjectType?
    var onDelete: (() -> Void)? = nil

    @State private var typeName: String = ""
    @State private var selectedIcon: String = "book.fill"
    @State private var selectedColorHex: String = "#FF3B30"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    HStack(spacing: 6) {
                        Image(systemName: selectedIcon)
                            .frame(width: 28, height: 28, alignment: .center)
                        if !typeName.isEmpty {
                            Text(typeName.uppercased())
                        } else {
                            Text("NAME").italic()
                        }
                    }
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(hex: selectedColorHex).opacity(0.15))
                    .foregroundColor(Color(hex: selectedColorHex))
                    .cornerRadius(8)

                    LimitedTextField(text: $typeName, placeholder: "Name", limit: nameLimit)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Icon")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)

                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(icons, id: \.self) { icon in
                                let isSelected = selectedIcon == icon
                                Image(systemName: icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(isSelected ? Color(hex: selectedColorHex) : .secondary)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(isSelected ? Color(hex: selectedColorHex).opacity(0.1) : Color.cardBackground)
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
                            .foregroundColor(.secondary)

                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(colors, id: \.self) { hex in
                                let isSelected = selectedColorHex == hex
                                Circle()
                                    .fill(Color(hex: hex))
                                    .frame(width: 34, height: 34)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(Color.cardBackground)
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

                    if typeToEdit != nil {
                        DeleteButton {
                            deleteType()
                            dismiss()
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle(typeToEdit == nil ? "New Type" : "Edit Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(typeToEdit == nil ? "Done" : "Save") {
                        saveType()
                    }
                    .disabled(typeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .foregroundColor(typeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .secondary : Color(hex: selectedColorHex))
                }
            }
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium, .large])
        .onAppear {
            if let typeToEdit {
                typeName = typeToEdit.name ?? ""
                selectedIcon = typeToEdit.iconName ?? icons[0]
                selectedColorHex = typeToEdit.colorHex ?? colors[0]
            }
        }
        .background(Color.appBackground)
    }

    private func saveType() {
        let entity = typeToEdit ?? SubjectType(context: viewContext)

        entity.name = typeName
        entity.iconName = selectedIcon
        entity.colorHex = selectedColorHex

        if typeToEdit == nil {
            entity.id = UUID()
            entity.isCustom = true
        }

        do {
            if viewContext.hasChanges {
                try viewContext.save()
            }
            dismiss()
        } catch {
            print("Error saving class type: \(error)")
        }
    }

    private func deleteType() {
        guard let type = typeToEdit else { return }
        viewContext.delete(type)
        try? viewContext.save()

        onDelete?()
        dismiss()
    }

    private let icons = [
        "book.fill", "graduationcap.fill", "pencil.and.outline", "bolt.fill",
        "globe.desk", "chart.bar.xaxis", "briefcase.fill", "theatermasks.fill",
        "sportscourt.fill", "waveform.path", "function", "paintpalette.fill"
    ]

    private let colors = [
        "#FF3B30", "#FF9F0A", "#FFCC00", "#34C759",
        "#00C7BE", "#30B0C7", "#32ADE6", "#007AFF",
        "#5856D6", "#AF52DE", "#FF2D55", "#A2845E"
    ]

    private let nameLimit = 15
    private let columns = Array(repeating: GridItem(.flexible()), count: 4)
}
