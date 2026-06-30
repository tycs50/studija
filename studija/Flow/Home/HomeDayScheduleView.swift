import SwiftUI
import CoreData

struct HomeDayScheduleView: View {
    let date: Date
    let viewModel: HomeViewModel
    @Binding var navPath: NavigationPath

    @Environment(ScheduleManager.self) private var manager
    @FetchRequest private var classes: FetchedResults<WeekSubject>

    init(date: Date, manager: ScheduleManager, allWeeks: [Week], viewModel: HomeViewModel, navPath: Binding<NavigationPath>) {
        self.date = date
        self.viewModel = viewModel
        self._navPath = navPath

        let calendar = Calendar.current
        let weekday = (calendar.component(.weekday, from: date) + 5) % 7

        if let targetWeek = viewModel.activeWeek(for: date, manager: manager, allWeeks: allWeeks),
           let weekID = targetWeek.id {
            let predicate = NSPredicate(format: "weekday == %d AND week.id == %@", Int16(weekday), weekID as NSUUID)

            self._classes = FetchRequest<WeekSubject>(
                sortDescriptors: [NSSortDescriptor(keyPath: \WeekSubject.startTime, ascending: true)],
                predicate: predicate,
                animation: .default
            )
        } else {
            self._classes = FetchRequest<WeekSubject>(
                sortDescriptors: [],
                predicate: NSPredicate(value: false),
                animation: .default
            )
        }
    }

    var body: some View {
        let firstStart = classes.first?.formattedStartTime

        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    statCard(title: "Classes", value: "\(classes.count)")
                    statCard(title: "Start", value: firstStart ?? "—")
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 14)

                LazyVStack(spacing: 10) {
                    if classes.isEmpty {
                        EmptyListView(text: "No classes today")
                            .padding(.top, 40)
                    } else {
                        ForEach(classes) { item in
                            WeekSubjectCard(item: item, navPath: $navPath)
                                .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .padding(.top, 2)
            .padding(.bottom, 100)
        }
    }

    private func statCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(Color(white: 0.13))
        .cornerRadius(16)
    }
}
