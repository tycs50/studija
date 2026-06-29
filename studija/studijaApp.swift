import SwiftUI
import CoreData

@main
struct studijaApp: App {
    let persistenceController = PersistenceController.shared
    @State private var scheduleManager = ScheduleManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(scheduleManager)
                .onAppear {
                    scheduleManager.checkAndRotateWeekIfNeeded(context: persistenceController.container.viewContext)

                    if let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                        print("DB: \(url.path)")
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    scheduleManager.checkAndRotateWeekIfNeeded(context: persistenceController.container.viewContext)
                }
        }
    }
}
