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
                Color.black.ignoresSafeArea()

                Group {
                    switch selectedTab {
                    case .home:
                        HomeView(navPath: $navPath)
                            .environment(scheduleManager)
                    case .tasks:
                        Text("Tasks Screen").foregroundColor(.white)
                    case .calendar:
                        Text("Calendar Screen").foregroundColor(.white)
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
                case AppPaths.newSubject:
                    SubjectView()
                        .environment(\.managedObjectContext, viewContext)
                case AppPaths.newWeekSubject(let week, let weekday):
                    WeekSubjectView(navPath: $navPath, currentWeek: week, weekday: weekday)
                        .environment(\.managedObjectContext, viewContext)
                case AppPaths.newSchedule:
                    ScheduleView(schedule: nil, manager: scheduleManager)
                case AppPaths.scheduleList:
                    ScheduleList(navPath: $navPath)
                case AppPaths.subjectList(let context):
                    SubjectList(navPath: $navPath, context: context)
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
    case home, tasks, calendar, settings

    var iconName: String {
        switch self {
        case .home: return "house"
        case .tasks:    return "list.bullet"
        case .calendar: return "calendar"
        case .settings: return "gearshape"
        }
    }

    var label: String {
        switch self {
        case .home: return "Schedule"
        case .tasks:    return "Tasks"
        case .calendar: return "Calendar"
        case .settings: return "Settings"
        }
    }
}


#Preview {
    ContentView()
}
