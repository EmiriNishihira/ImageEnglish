//
//  ImageEnglishApp.swift
//  ImageEnglish
//
//  Created by えみり on 2024/12/14.
//

import SwiftUI
import SwiftData

@main
struct ImageEnglishApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
