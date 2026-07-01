import SwiftUI
import CoreData

struct TaskRow: View {
    @ObservedObject var task: Task
    var onToggle: () -> Void
    var onTap: () -> Void
    private var isOverdue: Bool {
        guard let deadline = task.deadline, !task.isCompleted else { return false }
        let start = Calendar.current.startOfDay(for: deadline)
        return start < Calendar.current.startOfDay(for: Date())
    }

    var body: some View {
        HStack(spacing: 0) {
            Button(action: onToggle) {
                Group {
                    if task.isCompleted {
                        ZStack {
                            Circle()
                                .fill(priorityColor)
                                .frame(width: 22, height: 22)

                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .bold))
                        }
                    } else {
                        Circle()
                            .stroke(priorityColor, lineWidth: 2)
                            .frame(width: 22, height: 22)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.trailing, 14)

            Button(action: onTap) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(task.title ?? "")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(task.isCompleted ? .secondary : (isOverdue ? .red : .primary))
                            .strikethrough(task.isCompleted, color: .secondary)
                            .multilineTextAlignment(.leading)

                        if let deadline = task.deadline {
                            Text("\(deadline.formatted(.dateTime.month(.abbreviated).day().year()))")
                            // • \(deadline.formatted(.dateTime.hour(.twoDigits(amPM: .omitted)).minute(.twoDigits)))")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(isOverdue ? .red : .secondary)
                        }

                        if let subject = task.subject {
                            Text(subject.title ?? "")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: subject.color ?? "").opacity(task.isCompleted ? 0.4 : 1.0))
                        }
                    }

                    Spacer()

                    Text(priorityIconText)
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(priorityColor.opacity(task.isCompleted ? 0.4 : 1.0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .roundedBackground()
    }

    private var priorityColor: Color {
        switch task.priority {
        case 1: return .yellow
        case 2: return .red
        default: return .gray
        }
    }

    private var priorityIconText: String {
        switch task.priority {
        case 0: return "!"
        case 1: return "!!"
        case 2: return "!!!"
        default: return "!"
        }
    }
}
