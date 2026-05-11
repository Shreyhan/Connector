//
//  ConnectorApp.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 5/5/26.
//

import SwiftUI
import SwiftData

@main
struct ConnectorApp: App {
    var body: some Scene {
        WindowGroup {
            LevelView()
                .modelContainer(for: LevelManager.self)
        }
    }
}
