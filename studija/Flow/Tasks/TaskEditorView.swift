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
    private let notesLimit = 120

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
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                priorityButton
                LimitedTextField(text: $title,
                                 placeholder: "What needs to be done?",
                                 limit: titleLimit,
                                 font: .system(size: 20, weight: .bold))
            }

            LimitedTextField(text: $notes,
                             placeholder: "Notes",
                             limit: notesLimit,
                             font: .system(size: 22, weight: .semibold))

            deadlineSection

            SubjectSelectionView(navPath: $navPath,
                                 navDestination: .subjectList(context: .init(
                                    onSelect: { subject in
                                        self.selectedSubject = subject
                                    }
                                 )),
                                 selectedSubject: $selectedSubject,
                                 text: "Select Subject (Optional)",
                                 allowCancelation: true)

            if taskToEdit != nil {
                DeleteButton {
                    deleteTask()
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
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
        .background(Color.appBackground)
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
                        }
                        .bounceStyle()
                        .zIndex(3)
                    }
                }
                .foregroundColor(.secondary)
//                .padding(.horizontal, 16)
//                .frame(height: 54)
//                .background(Color(white: 0.11))
//                .cornerRadius(14)
                .roundedBackground()

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

    private var priorityColor: Color {
        switch priority {
        case 1: return .yellow
        case 2: return .red
        default: return .secondary
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
