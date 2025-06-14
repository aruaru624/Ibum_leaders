//
//  ModelContainer.swift
//  Ibum
//
//  Created by tanaka niko on 2025/06/15.
//

import Foundation
import SwiftData

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Quest.self,Photo.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
