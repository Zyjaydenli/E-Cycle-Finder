//
//  E_Cycle_FinderApp.swift
//  E-Cycle Finder
//
//  Created by Jayden Li on 2025-12-22.
//

import SwiftUI
import SwiftData

@main
struct E_Cycle_FinderApp: App {
    let container: ModelContainer

    init() {
        self.container = try! ModelContainer(for: Location.self)
        preloadIfNeeded(context: container.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    guard !isPreview else { return }
                    await LocationSeeder.refreshFromRemote(context: container.mainContext)
                }
        }
        .modelContainer(container)
    }

    private func preloadIfNeeded(context: ModelContext) {
        LocationSeeder.ensureSeeded(context: context)
    }

    private let isPreview: Bool = {
        let env = ProcessInfo.processInfo.environment
        return env["XCODE_RUNNING_FOR_PREVIEWS"] == "1" || env["XCODE_RUNNING_FOR_PLAYGROUNDS"] == "1"
    }()
}
