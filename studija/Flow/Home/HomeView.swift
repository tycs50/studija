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
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                headerView

                InfinitePageView(selection: $viewModel.selectedDayIndex) { dayOffset in
                    HomeDayScheduleView(date: viewModel.date(for: dayOffset),
                                        manager: manager,
                                        allWeeks: Array(allWeeks.filter { $0.schedule?.id?.uuidString == manager.selectedScheduleID }),
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

                    let activeWeekTitle = viewModel.activeWeek(for: viewModel.selectedDate, manager: manager, allWeeks: Array(allWeeks))?.title ?? ""
                    Text("\(viewModel.dateLabel(for: viewModel.selectedDate)) \(activeWeekTitle.isEmpty ? "" : "• \(activeWeekTitle.lowercased())")")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)

                    ZStack {
                        HStack {
                            Text("Select Manually")
                                .font(.system(size: 16, weight: .semibold))

                            Image(systemName: "chevron.down")
                                .font(.system(size: 13))
                        }
                        .foregroundStyle(Color.accentColor)

                        DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .scaleEffect(1.5)
                            .colorMultiply(.clear)
                    }
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
                                    .font(.system(size: 22, weight: .medium))
                            )
                    }.buttonStyle(BounceButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)

            WeekPickerView(selectedDate: $viewModel.selectedDate)
                .padding(.horizontal, 12)
                .padding(.bottom, 16)
        }
    }
}

#Preview {
    ContentView()
}
