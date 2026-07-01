import SwiftUI
import CoreData

@Observable
class HomeViewModel {
    var selectedDate = Date()
    var selectedDayIndex: Int = 0

    private let calendar = Calendar.current

    func date(for offset: Int) -> Date {
        calendar.date(byAdding: .day, value: offset, to: calendar.startOfDay(for: Date()))!
    }

    func dayOffset(for date: Date) -> Int {
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTarget = calendar.startOfDay(for: date)
        let comps = calendar.dateComponents([.day], from: startOfToday, to: startOfTarget)
        return comps.day ?? 0
    }

    func activeWeek(for date: Date, manager: ScheduleManager, allWeeks: [Week]) -> Week? {
        guard !allWeeks.isEmpty else { return nil }
        let filteredWeeks = allWeeks.filter { $0.schedule?.id?.uuidString == manager.selectedScheduleID }

        guard let currentWeekIndex = filteredWeeks.firstIndex(where: { $0.id?.uuidString == manager.currentWeekID }) else {
            return allWeeks.first
        }

        let startOfTodayWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        let startOfTargetWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? date

        let weekComponents = calendar.dateComponents([.weekOfYear], from: startOfTodayWeek, to: startOfTargetWeek)
        let weekDifference = weekComponents.weekOfYear ?? 0

        let totalWeeks = filteredWeeks.count
        let targetIndex = (currentWeekIndex + (weekDifference % totalWeeks) + totalWeeks) % totalWeeks

        return filteredWeeks[targetIndex]
    }

    func classes(for date: Date, allWeekSubjects: [WeekSubject], manager: ScheduleManager, allWeeks: [Week]) -> [WeekSubject] {
        let weekday = (calendar.component(.weekday, from: date) + 5) % 7

        guard let targetWeek = activeWeek(for: date, manager: manager, allWeeks: allWeeks) else {
            return []
        }

        return allWeekSubjects.filter { item in
            let matchesWeekday = item.weekday == Int16(weekday)
            let matchesWeek = item.week?.id == targetWeek.id

            return matchesWeekday && matchesWeek
        }
    }

    func dayLabel(for date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "EEEE"
        return f.string(from: date)
    }

    func dateLabel(for date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "d MMMM"
        return f.string(from: date).lowercased()
    }
}
