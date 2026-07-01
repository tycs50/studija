import SwiftUI

struct SubjectView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: SubjectViewModel

    init(subject: Subject? = nil) {
        self._viewModel = State(initialValue: SubjectViewModel(subject: subject))
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                ColorPicker("", selection: $viewModel.accentColor)
                    .labelsHidden()

                LimitedTextField(text: $viewModel.subjectName, placeholder: "Name", limit: viewModel.limit)
            }
            .padding(.top, 16)

            if viewModel.isEditing {
                DeleteButton {
                    viewModel.delete(context: viewContext)
                    dismiss()
                }
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationTitle(viewModel.isEditing ? "Edit Subject" : "New Subject")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.save(context: viewContext)
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 15, weight: .semibold))
                }
                .disabled(viewModel.isSaveDisabled)
                .opacity(viewModel.isSaveDisabled ? 0.35 : 1)
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview {
    SubjectView()
        .preferredColorScheme(.dark)
}
