import SwiftUI

struct WeekSubjectView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: NavigationPath
    @State private var viewModel: WeekSubjectViewModel
    private let currentWeek: Week?

    init(navPath: Binding<NavigationPath>, currentWeek: Week? = nil, weekday: Int? = nil, weekSubject: WeekSubject? = nil) {
        self._navPath = navPath
        self.currentWeek = currentWeek
        self._viewModel = State(initialValue: WeekSubjectViewModel(weekSubject: weekSubject, weekday: weekday))
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
//                    subjectSelectorSection
                    SubjectSelectionView(navPath: $navPath,
                                         navDestination: .subjectList(context: .init(
                                            onSelect: { subject in
                                                viewModel.selectedSubject = subject
                                            }
                                         )),
                                         selectedSubject: $viewModel.selectedSubject)

                    SubjectTypeSelection(viewModel: viewModel)
                        .padding(.horizontal, -20)

                    timeSelectionRow

                    inputField(placeholder: "Building, classroom", text: $viewModel.classroom, icon: "map")

                    inputField(placeholder: "Teacher", text: $viewModel.teacher, icon: "graduationcap")

                    if viewModel.weekSubject != nil {
                        DeleteButton {
                            viewModel.delete(context: viewContext)
                            navPath.removeLast()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
        }
        .navigationTitle(Text(viewModel.weekSubject == nil ? "New class" : "Class"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.save(context: viewContext, currentWeek: currentWeek)
                    navPath.removeLast()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 15, weight: .semibold))
                }
                .disabled(viewModel.isSaveDisabled)
                .opacity(viewModel.isSaveDisabled ? 0.35 : 1)
            }
        }
        .background(Color.appBackground)
    }

    @ViewBuilder
    private var subjectSelectorSection: some View {
        Button(action: {
            navPath.append(AppPaths.subjectList(context: .init(onSelect: { subject in
                viewModel.selectedSubject = subject
            })))
        }) {
            Group {
                if let subject = viewModel.selectedSubject {
                    SubjectCard(subject, navPath: $navPath)
                        .buttonStyle(BounceButtonStyle())
                        .disabled(true)
                } else {
                    HStack {
                        Spacer()
                        Text("Select Subject")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.vertical, 22)
                    .background(Color.appBackground)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.lightSelection, lineWidth: 2)
                    )
                }
            }
        }
    }

    private var timeSelectionRow: some View {
        return HStack(spacing: 12) {
            ZStack {
                HStack(spacing: 10) {
                    Image(systemName: "timer")
                        .foregroundColor(.secondary)
                        .font(.system(size: 18))

                    Text(viewModel.isStartTimeSet ? timeFormatter.string(from: viewModel.startTime) : "Start")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(viewModel.isStartTimeSet ? .primary : .secondary)
                    Spacer()
                }
//                .padding(.horizontal, 16)
//                .padding(.vertical, 16)
//                .background(Color(white: 0.11))
//                .cornerRadius(14)
                .modifier(RoundedBackground())

                DatePicker("", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scaleEffect(x: 2, y: 1)
                    .colorMultiply(.clear)
                    .onChange(of: viewModel.startTime) { _, newStartTime in
                        viewModel.isStartTimeSet = !(viewModel.isEndTimeSet && newStartTime >= viewModel.endTime)
                    }
            }

            ZStack {
                HStack(spacing: 10) {
                    Image(systemName: "timer")
                        .foregroundColor(.secondary)
                        .font(.system(size: 18))

                    Text(viewModel.isEndTimeSet ? timeFormatter.string(from: viewModel.endTime) : "End")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(viewModel.isEndTimeSet ? .primary : .secondary)
                    Spacer()
                }
//                .padding(.horizontal, 16)
//                .padding(.vertical, 16)
//                .background(Color(white: 0.11))
//                .cornerRadius(14)
                .modifier(RoundedBackground())

                DatePicker("", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scaleEffect(x: 2, y: 1)
                    .colorMultiply(.clear)
                    .onChange(of: viewModel.endTime) { _, newEndTime in
                        viewModel.isEndTimeSet = !(viewModel.isStartTimeSet && newEndTime <= viewModel.startTime)
                    }
            }
        }
    }

    private func inputField(placeholder: String, text: Binding<String>, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .font(.system(size: 18))
                .frame(width: 24)

            TextField(placeholder, text: text)
                .font(.system(size: 16))
                .autocorrectionDisabled()
        }
        .modifier(RoundedBackground())
    }
}
