//
//  To do list.swift
//
//  Created by Adam Byford on 17/05/2024.
//

import SwiftUI
import SwiftData

@main
struct ToDoList: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Task.self)
        }
    }
}
