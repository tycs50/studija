import SwiftUI
import CoreData

@Observable
class WeekSubjectViewModel {
    let weekSubject: WeekSubject?
    var weekday: Int?

    var selectedSubject: Subject? = nil
    var startTime = Date()
    var endTime = Date()
    var classroom: String = ""
    var teacher: String = ""
    var selectedType: SubjectType? = nil

    var isStartTimeSet = false
    var isEndTimeSet = false

    var isSaveDisabled: Bool {
        selectedSubject == nil || !isStartTimeSet || !isEndTimeSet
    }

    init(weekSubject: WeekSubject? = nil, weekday: Int? = nil) {
        self.weekSubject = weekSubject
        self.weekday = weekday

        if let weekSubject = weekSubject {
            self.selectedSubject = weekSubject.subject
            self.classroom = weekSubject.classroom ?? ""
            self.teacher = weekSubject.teacher ?? ""

            self.startTime = weekSubject.startAsDate
            self.endTime = weekSubject.endAsDate

            self.isStartTimeSet = true
            self.isEndTimeSet = true

            self.weekday = Int(weekSubject.weekday)
            self.selectedType = weekSubject.type
        } else {
            self.weekday = weekday
        }
    }

    func save(context: NSManagedObjectContext, currentWeek: Week?) {
        let object = weekSubject ?? WeekSubject(context: context)

        if weekSubject == nil {
            object.id = UUID()
            object.week = currentWeek
        }

        object.classroom = classroom
        object.teacher = teacher
        object.subject = selectedSubject

        object.startAsDate = startTime
        object.endAsDate = endTime

        object.weekday = Int16(weekday ?? 0)
        object.type = selectedType

        try? context.save()
    }

    func delete(context: NSManagedObjectContext) {
        guard let object = weekSubject else { return }
        context.delete(object)
        try? context.save()
    }

    func deleteClassType(_ type: SubjectType, in context: NSManagedObjectContext) {
        guard type.isCustom else { return }
        selectedType = nil
        context.delete(type)
        try? context.save()
    }
}
