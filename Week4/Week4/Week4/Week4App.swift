//
//  Week4App.swift
//  Week4
//
//  Created by Siksaka Suriyasat on 10/1/26.
//

import SwiftUI
import SwiftData

@main
struct Week4App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: SavedWords.self)
        }
    }
}
