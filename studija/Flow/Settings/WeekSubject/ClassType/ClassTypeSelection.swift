import SwiftUI

struct SubjectTypeSelection: View {
    @Environment(\.managedObjectContext) var context
    @Bindable var viewModel: WeekSubjectViewModel
    @State private var showCreatingSheet = false
    @State private var typeToEdit: SubjectType? = nil

    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.isCustom, order: .forward),
            SortDescriptor(\.name, order: .forward)
        ]
    ) private var allTypes: FetchedResults<SubjectType>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(allTypes) { type in
                    let isSelected = viewModel.selectedType?.name == type.name
                    let typeColor = Color(hex: type.colorHex ?? "")

                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            if isSelected {
                                viewModel.selectedType = nil
                            } else {
                                viewModel.selectedType = type
                            }
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: type.iconName ?? "")
                            Text(type.name ?? "")
                        }
                        .font(.system(size: 15, weight: .medium))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(isSelected ? typeColor.opacity(0.15) : Color(white: 0.11))
                        .foregroundColor(isSelected ? typeColor : .white.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isSelected ? typeColor : Color(white: 0.2), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .contextMenu {
                        if type.isCustom {
                            Button {
                                typeToEdit = type
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }

                            Button(role: .destructive) {
                                viewModel.deleteClassType(type, in: context)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }

                Button(action: {
                    showCreatingSheet = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("Custom")
                    }
                    .font(.system(size: 15, weight: .medium))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color(white: 0.11))
                    .foregroundColor(.white.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showCreatingSheet) {
            CustomTypeCreationSheet(typeToEdit: nil)
        }
        .sheet(item: $typeToEdit) { type in
            CustomTypeCreationSheet(typeToEdit: type) {
                viewModel.selectedType = nil
            }
        }
    }
}
