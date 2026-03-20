//
//  GhibliAppApp.swift
//  GhibliApp
//
//  Created by Кирилл on 20.03.2026.
//

import SwiftUI
import CoreData

@main
struct GhibliAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
