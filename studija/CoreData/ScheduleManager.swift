import SwiftUI
import CoreData

@Observable
class ScheduleManager {
    var selectedScheduleID: String? {
        didSet { UserDefaults.standard.set(selectedScheduleID, forKey: "selectedScheduleID") }
    }
    var currentWeekID: String? {
        didSet { UserDefaults.standard.set(currentWeekID, forKey: "selectedWeekID") }
    }

    init() {
        self.selectedScheduleID = UserDefaults.standard.string(forKey: "selectedScheduleID")
        self.currentWeekID = UserDefaults.standard.string(forKey: "selectedWeekID")
    }

    func checkAndRotateWeekIfNeeded(context: NSManagedObjectContext) {
        guard let scheduleID = selectedScheduleID else { return }

        let calendar = Calendar.current
        let now = Date()

        let lastRotation = UserDefaults.standard.object(forKey: "lastWeekRotationDate") as? Date ?? now

        let currentWeekOfYear = calendar.component(.weekOfYear, from: now)
        let lastWeekOfYear = calendar.component(.weekOfYear, from: lastRotation)
        let currentYear = calendar.component(.year, from: now)
        let lastYear = calendar.component(.year, from: lastRotation)

        if currentWeekOfYear != lastWeekOfYear || currentYear != lastYear {
            rotateToNextWeek(scheduleID: scheduleID, context: context)
            UserDefaults.standard.set(now, forKey: "lastWeekRotationDate")
        } else if UserDefaults.standard.object(forKey: "lastWeekRotationDate") == nil {
            UserDefaults.standard.set(now, forKey: "lastWeekRotationDate")
        }
    }

    private func rotateToNextWeek(scheduleID: String, context: NSManagedObjectContext) {
        let scheduleFetch: NSFetchRequest<Schedule> = Schedule.fetchRequest()
        scheduleFetch.predicate = NSPredicate(format: "id == %@", scheduleID)

        guard let schedule = try? context.fetch(scheduleFetch).first,
              let weeksSet = schedule.weeks as? Set<Week> else { return }

        let sortedWeeks = weeksSet.sorted { $0.weekIndex < $1.weekIndex }
        guard !sortedWeeks.isEmpty else { return }

        if let currentIdx = sortedWeeks.firstIndex(where: { $0.id?.uuidString == currentWeekID }) {
            let nextIdx = (currentIdx + 1) % sortedWeeks.count
            self.currentWeekID = sortedWeeks[nextIdx].id?.uuidString
        } else {
            self.currentWeekID = sortedWeeks.first?.id?.uuidString
        }

        try? context.save()
    }
}
