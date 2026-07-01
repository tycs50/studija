import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(ScheduleManager.self) private var scheduleManager
    @State private var navPath = NavigationPath()
    @State private var selectedTab: Tab = .home

    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack(alignment: .bottom) {
                Color.appBackground.ignoresSafeArea()

                Group {
                    switch selectedTab {
                    case .home:
                        HomeView(navPath: $navPath)
                            .environment(scheduleManager)
                    case .tasks:
                        TasksListView(navPath: $navPath)
                    case .settings:
                        SettingsView(navPath: $navPath)
                            .environment(scheduleManager)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                CustomTabBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationDestination(for: AppPaths.self) { route in
                switch route {
                case .newSubject: SubjectView()
                case .newWeekSubject(let week, let weekday): WeekSubjectView(navPath: $navPath,
                                                                             currentWeek: week, weekday: weekday)
                case .newSchedule: ScheduleView(schedule: nil, manager: scheduleManager)
                case .scheduleList: ScheduleList(navPath: $navPath)
                case .subjectList(let context): SubjectList(navPath: $navPath, context: context)
                case .classesTypesList: ClassTypeList()
                case .taskEditor(let task): TaskEditorView(taskToEdit: task, navPath: $navPath)
                case .completedTasks: TasksListView(navPath: $navPath, showCompleted: true)
                }
            }
            .navigationDestination(for: WeekSubject.self) { subject in
                WeekSubjectView(navPath: $navPath, weekSubject: subject)
            }
            .navigationDestination(for: Schedule.self) { schedule in
                WeekListView(navPath: $navPath, schedule: schedule)
            }
            .navigationDestination(for: Week.self) { week in
                WeekDetailView(week: week, navPath: $navPath)
            }
            .navigationDestination(for: Subject.self) { subject in
                SubjectView(subject: subject)
            }
        }
    }
}

enum Tab: CaseIterable {
    case home, tasks, settings

    var iconName: String {
        switch self {
        case .home: return "house"
        case .tasks:    return "list.bullet"
        case .settings: return "gearshape"
        }
    }

    var label: String {
        switch self {
        case .home: return "Schedule"
        case .tasks:    return "Tasks"
        case .settings: return "Settings"
        }
    }
}


#Preview {
    ContentView()
}
