import Foundation

extension WeekSubject {
    var startAsDate: Date {
        get {
            let hours = Int(startTime / 60)
            let minutes = Int(startTime % 60)
            return Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: Date()) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            self.startTime = Int16((components.hour ?? 0) * 60 + (components.minute ?? 0))
        }
    }

    var endAsDate: Date {
        get {
            let hours = Int(endTime / 60)
            let minutes = Int(endTime % 60)
            return Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: Date()) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            self.endTime = Int16((components.hour ?? 0) * 60 + (components.minute ?? 0))
        }
    }

    var formattedStartTime: String {
        let hours = startTime / 60
        let minutes = startTime % 60
        return String(format: "%02d:%02d", hours, minutes)
    }

    var formattedEndTime: String {
        let hours = endTime / 60
        let minutes = endTime % 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}
