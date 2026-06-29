import SwiftUI
import CoreData

struct HomeDayScheduleView: View {
    let date: Date
    let allWeekSubjects: [WeekSubject]
    let allWeeks: [Week]
    let viewModel: HomeViewModel
    @Binding var navPath: NavigationPath

    @Environment(ScheduleManager.self) private var manager

    var body: some View {
        let classes = viewModel.classes(for: date, allWeekSubjects: allWeekSubjects, manager: manager, allWeeks: allWeeks)
        let firstStart = classes.first?.formattedStartTime

        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    statCard(title: "Classes", value: "\(classes.count)")
                    statCard(title: "Start", value: firstStart ?? "—")
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 14)

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.35))
                    Text("Search")
                        .foregroundColor(.white.opacity(0.35))
                        .font(.system(size: 16))
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 13)
                .background(Color(white: 0.11))
                .cornerRadius(14)
                .padding(.horizontal, 20)
                .padding(.bottom, 14)

                LazyVStack(spacing: 10) {
                    if classes.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "moon.stars")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.25))
                            Text("No classes today")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.3))
                        }
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
