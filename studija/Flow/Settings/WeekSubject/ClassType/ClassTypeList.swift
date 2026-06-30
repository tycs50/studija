import SwiftUI
import CoreData

struct ClassTypeList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.isCustom, order: .forward),
            SortDescriptor(\.name, order: .forward)
        ]
    ) private var subjectTypes: FetchedResults<SubjectType>

    @State private var showingCustomSheet = false
    @State private var selectedType: SubjectType? = nil

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                if subjectTypes.isEmpty {
                    EmptyListView(text: "No types")
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                        ForEach(subjectTypes) { type in
                            typeGridCell(for: type)
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationTitle("Class Types")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingCustomSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showingCustomSheet) {
            CustomTypeCreationSheet(typeToEdit: nil)
        }
        .sheet(item: $selectedType) { type in
            CustomTypeCreationSheet(typeToEdit: type)
        }
    }

    @ViewBuilder
    private func typeGridCell(for type: SubjectType) -> some View {
        let color = Color(hex: type.colorHex ?? "#FFFFFF")

        VStack(spacing: 10) {
            Image(systemName: type.iconName ?? "book.fill")
                .font(.system(size: 24))

            Text((type.name ?? "UNKNOWN").uppercased())
                .font(.system(size: 13, weight: .bold))
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, minHeight: 75)
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .background(color.opacity(0.15))
        .foregroundColor(color)
        .cornerRadius(16)
        .overlay(alignment: .topTrailing) {
            if !type.isCustom {
                Image(systemName: "lock.fill")
                    .font(.system(size: 14))
                    .foregroundColor(color.opacity(0.4))
                    .padding(12)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if type.isCustom {
                selectedType = type
            } else {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            }
        }
        .contextMenu {
            if type.isCustom {
                Button(role: .destructive) {
                    deleteType(type)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }

    private func deleteType(_ type: SubjectType) {
        guard type.isCustom else { return }
        viewContext.delete(type)

        do {
            try viewContext.save()
        } catch {
            print("Failed to delete class type: \(error)")
        }
    }
}
