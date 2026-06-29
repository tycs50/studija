import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(ScheduleManager.self) private var manager

    @Binding var navPath: NavigationPath

    @State private var viewModel = HomeViewModel()

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Week.title, ascending: true)],
        animation: .default
    ) private var allWeeks: FetchedResults<Week>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WeekSubject.startTime, ascending: true)],
        animation: .default
    ) private var allWeekSubjects: FetchedResults<WeekSubject>

    private let calendar = Calendar.current

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                headerView

                InfinitePageView(selection: $viewModel.selectedDayIndex) { dayOffset in
//                    classesList(for: viewModel.date(for: dayOffset))
                    HomeDayScheduleView(date: viewModel.date(for: dayOffset),
                                        manager: manager,
                                        allWeeks: Array(allWeeks),
                                        viewModel: viewModel,
                                        navPath: $navPath)
                }
                .onChange(of: viewModel.selectedDayIndex) { newOffset in
                    let targetDate = viewModel.date(for: newOffset)
                    if !calendar.isDate(viewModel.selectedDate, inSameDayAs: targetDate) {
                        viewModel.selectedDate = targetDate
                    }
                }
                .onChange(of: viewModel.selectedDate) { newDate in
                    let targetOffset = viewModel.dayOffset(for: newDate)
                    if viewModel.selectedDayIndex != targetOffset {
                        viewModel.selectedDayIndex = targetOffset
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }

    private var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.dayLabel(for: viewModel.selectedDate))
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)

                    let activeWeekTitle = viewModel.activeWeek(for: viewModel.selectedDate, manager: manager, allWeeks: Array(allWeeks))?.title ?? ""
                    Text("\(viewModel.dateLabel(for: viewModel.selectedDate)) \(activeWeekTitle.isEmpty ? "" : "• \(activeWeekTitle.lowercased())")")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.5))
                }
                Spacer()

                if !calendar.isDateInToday(viewModel.selectedDate) {
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            viewModel.selectedDate = Date()
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(red: 0.38, green: 0.82, blue: 0.44))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "calendar")
                                    .foregroundColor(.white)
                                    .font(.system(size: 22, weight: .medium))
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)

            WeekPickerView(selectedDate: $viewModel.selectedDate)
                .padding(.horizontal, 12)
                .padding(.bottom, 16)
        }
    }

//    @ViewBuilder
//    private func classesList(for date: Date) -> some View {
//        let classes = viewModel.classes(for: date,
//                                        allWeekSubjects: Array(allWeekSubjects),
//                                        manager: manager,
//                                        allWeeks: Array(allWeeks))
//        let firstStart = classes.first?.formattedStartTime
//
//        ScrollView {
//            VStack(spacing: 0) {
//                HStack(spacing: 12) {
//                    statCard(title: "Classes", value: "\(classes.count)")
//                    statCard(title: "Start", value: firstStart ?? "—")
//                }
//                .padding(.horizontal, 20)
//                .padding(.bottom, 14)
//
//                HStack {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(.white.opacity(0.35))
//                    Text("Search")
//                        .foregroundColor(.white.opacity(0.35))
//                        .font(.system(size: 16))
//                    Spacer()
//                }
//                .padding(.horizontal, 16)
//                .padding(.vertical, 13)
//                .background(Color(white: 0.11))
//                .cornerRadius(14)
//                .padding(.horizontal, 20)
//                .padding(.bottom, 14)
//
//                LazyVStack(spacing: 10) {
//                    if classes.isEmpty {
//                        VStack(spacing: 12) {
//                            Image(systemName: "moon.stars")
//                                .font(.system(size: 40))
//                                .foregroundColor(.white.opacity(0.25))
//                            Text("No classes today")
//                                .font(.system(size: 16))
//                                .foregroundColor(.white.opacity(0.3))
//                        }
//                        .padding(.top, 40)
//                    } else {
//                        ForEach(classes) { item in
//                            WeekSubjectCard(item: item, navPath: $navPath)
//                                .padding(.horizontal, 20)
//                        }
//                    }
//                }
//            }
//            .padding(.top, 2)
//        }
//    }

//    private func statCard(title: String, value: String) -> some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text(title)
//                .font(.system(size: 16, weight: .semibold))
//                .foregroundColor(.white)
//            Text(value)
//                .font(.system(size: 22, weight: .bold))
//                .foregroundColor(.white)
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding(.horizontal, 18)
//        .padding(.vertical, 16)
//        .background(Color(white: 0.13))
//        .cornerRadius(16)
//    }
}

#Preview {
    ContentView()
}
