import SwiftUI

struct SubjectView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: SubjectViewModel

    init(subject: Subject? = nil) {
        self._viewModel = State(initialValue: SubjectViewModel(subject: subject))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 14) {
                    ColorPicker("", selection: $viewModel.accentColor)
                        .labelsHidden()

                    VStack(alignment: .leading, spacing: 6) {
                        TextField("Name", text: $viewModel.subjectName, axis: .vertical)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .tint(.white)
                            .lineLimit(1...10)
                            .onChange(of: viewModel.subjectName) { _, newValue in
                                viewModel.handleNameChange(newValue)
                            }

                        Text("\(viewModel.subjectName.count)/\(viewModel.limit)")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color(white: 0.45))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer()

                if viewModel.isEditing {
                    Button(action: {
                        viewModel.delete(context: viewContext)
                        dismiss()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "trash")
                            Text("Delete Subject")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.3))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(white: 0.11))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
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
                        .foregroundStyle(.white)
                }
                .disabled(viewModel.isSaveDisabled)
                .opacity(viewModel.isSaveDisabled ? 0.35 : 1)
            }
        }
    }
}

#Preview {
    SubjectView()
        .preferredColorScheme(.dark)
}
