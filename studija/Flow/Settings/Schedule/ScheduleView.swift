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
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Schedule", text: $viewModel.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .onChange(of: viewModel.title) { _, newValue in
                                if newValue.count > viewModel.characterLimit {
                                    viewModel.title = String(newValue.prefix(viewModel.characterLimit))
                                }
                            }

                        Text("\(viewModel.title.count)/\(viewModel.characterLimit)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
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
                        Button(action: {
                            viewModel.delete(context: viewContext, manager: manager)
                            dismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "trash")
                                Text("Remove")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.3))
                            .frame(maxWidth: .infinity)
                            .modifier(RoundedBackground())
                        }
                        .padding(.bottom, 16)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
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
    }
}
