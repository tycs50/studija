import SwiftUI
import CoreData

struct TasksListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: NavigationPath

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: true)],
        animation: .default
    ) private var tasks: FetchedResults<Task>

    @State private var searchText = ""
    let showCompleted: Bool

    var filteredTasks: [Task] {
        if searchText.isEmpty {
            return Array(tasks)
        } else {
            return tasks.filter { ($0.title ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }

    init(navPath: Binding<NavigationPath>, showCompleted: Bool = false) {
        self._navPath = navPath
        self.showCompleted = showCompleted

        let predicate = NSPredicate(format: "isCompleted == %d", showCompleted)

        self._tasks = FetchRequest<Task>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: true)],
            predicate: predicate,
            animation: .default
        )
    }

    var groupedTasks: [(Date?, [Task])] {
        let filtered = filteredTasks
        let grouped = Dictionary(grouping: filtered) { task -> Date? in
            guard let dl = task.deadline else { return nil }
            return Calendar.current.startOfDay(for: dl)
        }

        return grouped.sorted {
            switch ($0.key, $1.key) {
            case (let d1?, let d2?): return d1 < d2
            case (nil, _): return false
            case (_, nil): return true
            }
        }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 12) {
                    SearchField(searchText: $searchText)

                    if !showCompleted {
                        SettingsRow(title: "Completed",
                                    icon: "checkmark",
                                    route: .completedTasks,
                                    navPath: $navPath)
                    }

                    if filteredTasks.isEmpty {
                        EmptyListView(text: "No tasks")
                    } else {
                        VStack(spacing: 12) {
                            ForEach(groupedTasks, id: \.0) { date, tasks in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(formatSectionTitle(for: date))
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white.opacity(0.5))
                                        .padding(.horizontal, 4)
                                        .textCase(.uppercase)

                                    VStack(spacing: 12) {
                                        ForEach(tasks) { task in
                                            TaskRow(task: task) {
                                                toggleCompletion(for: task)
                                            } onTap: {
                                                navPath.append(AppPaths.taskEditor(task))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle(Text("\(showCompleted ? "Completed " : "")Tasks"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !showCompleted {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        navPath.append(AppPaths.taskEditor(nil))
                    }) {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }

    private func formatSectionTitle(for date: Date?) -> String {
        guard let date = date else { return "No Deadline" }
        if Calendar.current.isDateInToday(date) { return "Today" }
        if Calendar.current.isDateInTomorrow(date) { return "Tomorrow" }
        return date.formatted(.dateTime.day().month(.wide).year())
    }

    private func toggleCompletion(for task: Task) {
        task.isCompleted.toggle()

        do {
            try viewContext.save()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        } catch {
            print("Failed to toggle completion: \(error)")
        }
    }
}
