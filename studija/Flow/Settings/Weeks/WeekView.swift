import SwiftUI

struct WeekView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(ScheduleManager.self) private var manager

    @Bindable var viewModel: WeekViewModel
    @Binding var isShowing: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    TextField("Name", text: $viewModel.weekName, axis: .vertical)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .tint(.white)
                        .lineLimit(1...10)
                        .onChange(of: viewModel.weekName) { _, newValue in
                            if newValue.count > viewModel.characterLimit {
                                viewModel.weekName = String(newValue.prefix(viewModel.characterLimit))
                            }
                        }

                    Text("\(viewModel.weekName.count)/\(viewModel.characterLimit)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }

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
                    Button(action: {
                        viewModel.delete(week: currentWeek, context: viewContext, manager: manager)
                        isShowing = false
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
            .padding(.top, 20)
        }
        .navigationTitle(viewModel.editingWeek == nil ? "New week" : "Edit week")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.save(context: viewContext, manager: manager)
                    isShowing = false
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }
                .disabled(viewModel.weekName.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(viewModel.weekName.isEmpty ? 0.5 : 1)
            }
        }
    }
}
