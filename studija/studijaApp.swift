//
//  studijaApp.swift
//  studija
//
//  Created by Yefim on 26.06.26.
//

import SwiftUI
import CoreData

@main
struct studijaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
