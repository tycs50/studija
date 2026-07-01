import SwiftUI

struct ScheduleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @Environment(ScheduleManager.self) private var manager

    @State private var viewModel: ScheduleViewModel
    private let isEditing: Bool

    init(schedule: Schedule?, manager: ScheduleManager) {
        self.isEditing = schedule != nil
        _viewModel = State(initialValue: ScheduleViewModel(schedule: schedule, manager: manager))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LimitedTextField(text: $viewModel.title, placeholder: "Schedule", limit: viewModel.characterLimit)
                .padding(.bottom, 20)

            if !viewModel.isCurrent {
                Button {
                    viewModel.makeCurrent(manager: manager)
                } label: {
                    Text("Set As Current")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .modifier(RoundedBackground())
                        .buttonStyle(.plain)
                }
            }

            if isEditing {
                DeleteButton {
                    viewModel.delete(context: viewContext, manager: manager)
                    dismiss()
                }
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationTitle(Text(isEditing ? "Schedule" : "New Schedule"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.save(context: viewContext, manager: manager)
                    dismiss()
                }) {
                    Image(systemName: "checkmark")
                }
                .disabled(viewModel.title.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(viewModel.title.isEmpty ? 0.5 : 1)
            }
        }
        .background(Color.appBackground)
    }
}
