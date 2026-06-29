import Foundation

struct SubjectType: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var iconName: String
    var colorHex: String

    static let defaults: [SubjectType] = [
        SubjectType(name: "Lecture", iconName: "brain", colorHex: "#FF9F0A"),   // Orange
        SubjectType(name: "Seminar", iconName: "person.3.fill", colorHex: "#30D158"), // Green
        SubjectType(name: "Lab", iconName: "microbe.fill", colorHex: "#5E5CE6")       // Purple
    ]
}
