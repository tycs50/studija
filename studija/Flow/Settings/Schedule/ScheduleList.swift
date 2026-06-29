import SwiftUI
import CoreData

struct ScheduleList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(ScheduleManager.self) private var manager
    @Environment(\.dismiss) private var dismiss

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Schedule.title, ascending: true)],
        animation: .default
    ) private var schedules: FetchedResults<Schedule>

    @State private var searchText = ""

    var filteredSchedules: [Schedule] {
        if searchText.isEmpty {
            return Array(schedules)
        } else {
            return schedules.filter { ($0.title ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }

    @Binding var navPath: NavigationPath

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $searchText)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .frame(height: 50)
                .background(Color(white: 0.15))
                .cornerRadius(12)
                .padding(.horizontal, 16)

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredSchedules) { schedule in
                            scheduleCard(for: schedule)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .navigationTitle(Text("Schedules"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    navPath.append(AppPaths.newSchedule)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }

    @ViewBuilder
    private func scheduleCard(for schedule: Schedule) -> some View {
        let isCurrent = (manager.selectedScheduleID == schedule.id?.uuidString)

        Button {
            navPath.append(schedule)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(schedule.title ?? "Untitled")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)

                    if isCurrent {
                        Text("Current schedule")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                HStack(spacing: 16) {
                    Button(action: { /* TODO: */ }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.white)
                    }

                    NavigationLink(destination: ScheduleView(schedule: schedule, manager: manager)) {
                        Image(systemName: "pencil")
                            .foregroundColor(.white)
                    }
                }
            }.modifier(RoundedBackground())
        }
    }
}
