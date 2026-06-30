import Foundation

enum AppPaths: Hashable {
    case newWeekSubject(week: Week, weekday: Int)
    case newSchedule
    case newSubject
    case scheduleList
    case subjectList(context: SubjectSelectionContext?)
    case classesTypesList

    var route: String {
        switch self {
        case .newWeekSubject: "new_week_subject"
        case .newSchedule: "new_schedule"
        case .newSubject: "new_subject"
        case .scheduleList: "schedule_list"
        case .subjectList: "subject_list"
        case .classesTypesList: "classes_types_list"
        }
    }
}

class SubjectSelectionContext: Hashable {
    let onSelect: (Subject) -> Void

    init(onSelect: @escaping (Subject) -> Void) {
        self.onSelect = onSelect
    }

    static func == (lhs: SubjectSelectionContext, rhs: SubjectSelectionContext) -> Bool {
        lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
