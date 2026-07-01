import SwiftUI

struct WeekView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(ScheduleManager.self) private var manager

    @Bindable var viewModel: WeekViewModel
    @Binding var isShowing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LimitedTextField(text: $viewModel.weekName, placeholder: "Name", limit: viewModel.characterLimit)

            if !viewModel.isCurrentWeek {
                Button {
                    viewModel.makeCurrent(manager: manager)
                } label: {
                    Text("Set As Current")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .modifier(RoundedBackground())
                }
            }

            if let currentWeek = viewModel.editingWeek {
                DeleteButton {
                    viewModel.delete(week: currentWeek, context: viewContext, manager: manager)
                    isShowing = false
                }
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .navigationTitle(viewModel.editingWeek == nil ? "New week" : "Edit week")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.save(context: viewContext, manager: manager)
                    isShowing = false
                } label: {
                    Image(systemName: "checkmark")
                }
                .disabled(viewModel.weekName.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(viewModel.weekName.isEmpty ? 0.5 : 1)
            }
        }
        .background(Color.appBackground)
    }
}
