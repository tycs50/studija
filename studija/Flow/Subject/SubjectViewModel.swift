import SwiftUI
import CoreData

@Observable
class SubjectViewModel {
    var subjectName: String = ""
    var accentColor: Color = Color(white: 0.45)
    let limit = 30

    let subject: Subject?

    var isEditing: Bool {
        subject != nil
    }

    var isSaveDisabled: Bool {
        subjectName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    init(subject: Subject? = nil) {
        self.subject = subject

        if let subject = subject {
            self.subjectName = subject.title ?? ""
            if let hex = subject.color {
                self.accentColor = Color(hex: hex)
            }
        }
    }

    func handleNameChange(_ newValue: String) {
        if newValue.count > limit {
            subjectName = String(newValue.prefix(limit))
        }
    }

    func save(context: NSManagedObjectContext) {
        let object = subject ?? Subject(context: context)
        
        if subject == nil {
            object.id = UUID()
        }

        object.title = subjectName
        object.color = accentColor.toHex()

        try? context.save()
    }

    func delete(context: NSManagedObjectContext) {
        guard let object = subject else { return }
        context.delete(object)
        try? context.save()
    }
}
