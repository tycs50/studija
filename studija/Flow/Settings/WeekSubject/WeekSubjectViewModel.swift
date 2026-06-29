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

    var customTypes: [SubjectType] = [] {
        didSet {
            if let encoded = try? JSONEncoder().encode(customTypes) {
                UserDefaults.standard.set(encoded, forKey: "custom_subject_types")
            }
        }
    }

    init(weekSubject: WeekSubject? = nil, weekday: Int? = nil) {
        self.weekSubject = weekSubject
        self.weekday = weekday

        if let data = UserDefaults.standard.data(forKey: "custom_subject_types"),
           let decoded = try? JSONDecoder().decode([SubjectType].self, from: data) {
            self.customTypes = decoded
        }

        if let weekSubject = weekSubject {

            self.selectedSubject = weekSubject.subject
            self.classroom = weekSubject.classroom ?? ""
            self.teacher = weekSubject.teacher ?? ""

            self.startTime = weekSubject.startAsDate
            self.endTime = weekSubject.endAsDate

            self.isStartTimeSet = true
            self.isEndTimeSet = true

            self.weekday = Int(weekSubject.weekday)

            if let name = weekSubject.typeName,
               let icon = weekSubject.typeIcon,
               let hex = weekSubject.typeColorHex {
                self.selectedType = SubjectType(name: name, iconName: icon, colorHex: hex)
            }
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

        if let type = selectedType {
            object.typeName = type.name
            object.typeIcon = type.iconName
            object.typeColorHex = type.colorHex
        } else {
            object.typeName = nil
            object.typeIcon = nil
            object.typeColorHex = nil
        }

        try? context.save()
    }

    func delete(context: NSManagedObjectContext) {
        guard let object = weekSubject else { return }
        context.delete(object)
        try? context.save()
    }
}
