import SwiftUI
import CoreData

@Observable
class ScheduleViewModel {
    var title: String = ""
    var isCurrent: Bool = false
    let characterLimit = 50
    var schedule: Schedule?

    init(schedule: Schedule? = nil, manager: ScheduleManager) {
        self.schedule = schedule
        if let schedule = schedule {
            self.title = schedule.title ?? ""
            self.isCurrent = (manager.selectedScheduleID == schedule.id?.uuidString)
        }
    }

    func save(context: NSManagedObjectContext, manager: ScheduleManager) {
        let targetSchedule: Schedule

        if let existing = schedule {
            targetSchedule = existing
        } else {
            targetSchedule = Schedule(context: context)
            targetSchedule.id = UUID()

            let firstWeek = Week(context: context)
            firstWeek.id = UUID()
            firstWeek.title = "Week 1"
            firstWeek.weekIndex = 0
            targetSchedule.addToWeeks(firstWeek)
        }

        targetSchedule.title = title

        if manager.selectedScheduleID == nil {
            manager.selectedScheduleID = targetSchedule.id?.uuidString
            if let firstWeek = (targetSchedule.weeks as? Set<Week>)?.sorted(by: { $0.weekIndex < $1.weekIndex }).first {
                manager.currentWeekID = firstWeek.id?.uuidString
            }
            isCurrent = true
        }

        try? context.save()
    }

    func makeCurrent(manager: ScheduleManager) {
        guard let currentSchedule = schedule, let id = currentSchedule.id?.uuidString else { return }
        manager.selectedScheduleID = id

        if let firstWeek = (currentSchedule.weeks as? Set<Week>)?.sorted(by: { $0.weekIndex < $1.weekIndex }).first {
            manager.currentWeekID = firstWeek.id?.uuidString
        }
        isCurrent = true
    }

    func delete(context: NSManagedObjectContext, manager: ScheduleManager) {
        guard let schedule = schedule else { return }

        if manager.selectedScheduleID == schedule.id?.uuidString {
            manager.selectedScheduleID = nil
            manager.currentWeekID = nil
        }

        context.delete(schedule)
        try? context.save()
    }
}
