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
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 14) {
                        subjectSelectorSection

                        timeSelectionRow

                        inputField(placeholder: "Building, classroom", text: $viewModel.classroom, icon: "mappin")

                        inputField(placeholder: "Teacher", text: $viewModel.teacher, icon: "graduationcap")

                        if viewModel.weekSubject != nil {
                            Button(role: .destructive) {
                                viewModel.delete(context: viewContext)
                                navPath.removeLast()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "trash")
                                    Text("Remove")
                                }
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(white: 0.11))
                                .cornerRadius(14)
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                }
            }
        }
        .navigationTitle(Text(viewModel.weekSubject == nil ? "New subject" : "Subject"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.save(context: viewContext, currentWeek: currentWeek)
                    navPath.removeLast()
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

    @ViewBuilder
    private var subjectSelectorSection: some View {
        Button(action: {
            navPath.append(AppPaths.subjectList(context: .init(onSelect: { subject in
                viewModel.selectedSubject = subject
            })))
        }) {
            Group {
                if let subject = viewModel.selectedSubject {
                    SubjectCard(item: subject, navPath: $navPath)
                        .disabled(true)
                } else {
                    HStack {
                        Spacer()
                        Text("Click to select a subject")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                    }
                    .padding(.vertical, 22)
                    .background(Color.black)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(white: 0.3), lineWidth: 2)
                    )
                }
            }
        }
    }

    private var timeSelectionRow: some View {
        let placeholderColor = Color.white.opacity(0.35)

        return HStack(spacing: 12) {
            ZStack {
                HStack(spacing: 10) {
                    Image(systemName: "timer")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 18))

                    Text(viewModel.isStartTimeSet ? timeFormatter.string(from: viewModel.startTime) : "Start")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(viewModel.isStartTimeSet ? .white.opacity(0.9) : placeholderColor)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color(white: 0.11))
                .cornerRadius(14)

                DatePicker("", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .colorMultiply(.clear)
                    .onChange(of: viewModel.startTime) { _, newStartTime in
                        viewModel.isStartTimeSet = !(viewModel.isEndTimeSet && newStartTime >= viewModel.endTime)
                    }
            }

            ZStack {
                HStack(spacing: 10) {
                    Image(systemName: "timer")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 18))

                    Text(viewModel.isEndTimeSet ? timeFormatter.string(from: viewModel.endTime) : "End")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(viewModel.isEndTimeSet ? .white.opacity(0.9) : placeholderColor)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color(white: 0.11))
                .cornerRadius(14)

                DatePicker("", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                .foregroundColor(.white.opacity(0.4))
                .font(.system(size: 18))
                .frame(width: 24)

            ZStack(alignment: .leading) {
                if text.wrappedValue.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.white.opacity(0.35))
                        .font(.system(size: 16))
                }
                TextField("", text: text)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .autocorrectionDisabled()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color(white: 0.11))
        .cornerRadius(14)
    }
}
