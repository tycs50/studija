import SwiftUI
import CoreData

struct TaskEditorView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    let taskToEdit: Task?
    @Binding var navPath: NavigationPath

    @State private var title: String
    @State private var notes: String
    @State private var priority: Int16
    @State private var deadline: Date?
    @State private var selectedSubject: Subject?

    private let titleLimit = 30
    private let bodyLimit = 120

    init(taskToEdit: Task? = nil, navPath: Binding<NavigationPath>) {
        self.taskToEdit = taskToEdit
        self._navPath = navPath
        _title = State(initialValue: taskToEdit?.title ?? "")
        _notes = State(initialValue: taskToEdit?.notes ?? "")
        _priority = State(initialValue: taskToEdit?.priority ?? 0)
        _deadline = State(initialValue: taskToEdit?.deadline)
        _selectedSubject = State(initialValue: taskToEdit?.subject)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    HStack(alignment: .top, spacing: 12) {
                        priorityButton
                        titleInputSection
                    }

                    bodyInputSection

                    deadlineSection

                    subjectSelectorSection
                }

                if taskToEdit != nil {
                    Button(role: .destructive) {
                        deleteTask()
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
                }

                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle(Text(taskToEdit == nil ? "New task" : "Task"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    saveTask()
                    dismiss()
                }) {
                    Image(systemName: "checkmark")
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(title.isEmpty ? 0.5 : 1)
            }
        }
    }

    private var priorityButton: some View {
        Button(action: togglePriority) {
            Text(priorityIconText)
                .font(.system(size: 18, weight: .black))
                .foregroundColor(.black)
                .frame(width: 38, height: 38)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(priorityColor)
                )
        }
    }

    private var titleInputSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("What needs to be done?", text: $title, axis: .vertical)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .tint(.white)
                .lineLimit(1...5)
                .onChange(of: title) { _, newValue in
                    if newValue.count > titleLimit {
                        title = String(newValue.prefix(titleLimit))
                    }
                }

            Text("\(title.count)/\(titleLimit)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.4))
        }
    }

    private var bodyInputSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("Notes", text: $notes, axis: .vertical)
                .font(.title2)
                .fontWeight(.semibold)
                .tint(.white)
                .lineLimit(1...10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: notes) { _, newValue in
                    if newValue.count > bodyLimit {
                        notes = String(newValue.prefix(bodyLimit))
                    }
                }

            Text("\(notes.count)/\(bodyLimit)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.4))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 4)
    }

    private var deadlineSection: some View {
        HStack(spacing: 12) {
            ZStack {
                HStack(spacing: 12) {
                    Image(systemName: "calendar")
                        .font(.system(size: 16))

                    Text(deadline == nil ? "Deadline" : deadline!.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 16, weight: .medium))

                    Spacer()

                    if deadline != nil {
                        Button(action: { deadline = nil }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .zIndex(3)
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 54)
                .background(Color(white: 0.11))
                .foregroundColor(.white.opacity(0.7))
                .cornerRadius(14)

                DatePicker("", selection: Binding(
                    get: { deadline ?? Date() },
                    set: { deadline = $0 }
                ), displayedComponents: [.date])
                .datePickerStyle(.compact)
                .labelsHidden()
                .scaleEffect(x: 2, y: 1.75, anchor: .trailing)
                .colorMultiply(.clear)
            }

//            ZStack {
//                HStack(spacing: 12) {
//                    Image(systemName: "clock")
//                        .font(.system(size: 16))
//
//                    Text(deadline == nil ? "Time" : deadline!.formatted(date: .omitted, time: .shortened))
//                        .font(.system(size: 16, weight: .medium))
//
//                    Spacer()
//                }
//                .padding(.horizontal, 16)
//                .frame(height: 54)
//                .background(Color(white: 0.11))
//                .foregroundColor(.white.opacity(0.7))
//                .cornerRadius(14)
//
//                DatePicker("", selection: Binding(
//                    get: { deadline ?? Date() },
//                    set: { deadline = $0 }
//                ), displayedComponents: [.hourAndMinute])
//                .datePickerStyle(.compact)
//                .labelsHidden()
//                .scaleEffect(x: 2, y: 1.75, anchor: .trailing)
//                .colorMultiply(.clear)
//            }
        }
    }

    @ViewBuilder
    private var subjectSelectorSection: some View {
        Button(action: {
            navPath.append(AppPaths.subjectList(context: .init(onSelect: { subject in
                self.selectedSubject = subject
            })))
        }) {
            VStack {
                if let subject = selectedSubject {
                    SubjectCard(item: subject, navPath: $navPath)
                        .disabled(true)
                } else {
                    HStack {
                        Spacer()
                        Text("Select Subject (Optional)")
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

    private var priorityColor: Color {
        switch priority {
        case 1: return .yellow
        case 2: return .red
        default: return .gray
        }
    }

    private var priorityIconText: String {
        switch priority {
        case 0: return "!"
        case 1: return "!!"
        case 2: return "!!!"
        default: return "!"
        }
    }

    private func togglePriority() {
        priority = (priority + 1) % 3

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    private func saveTask() {
        let task = taskToEdit ?? Task(context: viewContext)

        if taskToEdit == nil {
            task.id = UUID()
        }

        task.title = title.trimmingCharacters(in: .whitespaces)
        task.notes = notes.trimmingCharacters(in: .whitespaces)
        task.priority = priority
        task.deadline = deadline
        task.subject = selectedSubject
        task.isCompleted = taskToEdit?.isCompleted ?? false

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Failed to save task: \(error)")
        }
    }

    private func deleteTask() {
        guard let task = taskToEdit else { return }

        viewContext.delete(task)

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
}
