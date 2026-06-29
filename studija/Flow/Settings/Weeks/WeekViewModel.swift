import SwiftUI
import CoreData

@Observable
class WeekViewModel {
    private let schedule: Schedule
    var weekName: String = ""
    var isCurrentWeek: Bool = false
    let characterLimit = 50
    var editingWeek: Week?

    init(schedule: Schedule) {
        self.schedule = schedule
    }

    func prepareCreate() {
        editingWeek = nil
        weekName = ""
        isCurrentWeek = false
    }

    func prepareEdit(for week: Week, manager: ScheduleManager) {
        editingWeek = week
        weekName = week.title ?? ""
        isCurrentWeek = (manager.currentWeekID == week.id?.uuidString)
    }

    func save(context: NSManagedObjectContext, manager: ScheduleManager) {
        let weekToSave: Week

        if let existing = editingWeek {
            weekToSave = existing
        } else {
            weekToSave = Week(context: context)
            weekToSave.id = UUID()
            weekToSave.schedule = schedule

            let maxIndex = (schedule.weeks as? Set<Week>)?
                .map { $0.weekIndex }
                .max() ?? -1
            weekToSave.weekIndex = maxIndex + 1
        }

        weekToSave.title = weekName

        try? context.save()
    }

    func makeCurrent(manager: ScheduleManager) {
        guard let id = editingWeek?.id?.uuidString else { return }
        manager.currentWeekID = id
        isCurrentWeek = true
    }

    func delete(week: Week, context: NSManagedObjectContext, manager: ScheduleManager) {
        if manager.currentWeekID == week.id?.uuidString {
            manager.currentWeekID = nil
        }

        context.delete(week)
        try? context.save()

        reindexWeeks(context: context)
    }

    private func reindexWeeks(context: NSManagedObjectContext) {
        let sortedWeeks = (schedule.weeks as? Set<Week>)?
            .sorted(by: { $0.weekIndex < $1.weekIndex }) ?? []

        for (index, week) in sortedWeeks.enumerated() {
            week.weekIndex = Int16(index)
        }
        try? context.save()
    }
}
