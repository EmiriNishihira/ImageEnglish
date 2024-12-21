//
//  PreviewContainer.swift
//  AIWordImage
//
//  Created by えみり on 2024/12/21.
//

import SwiftUI
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
  do {
    let container = try ModelContainer(
        for: Item.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let modelContext = container.mainContext

      if try modelContext.fetch(FetchDescriptor<Item>()).isEmpty {
        SampleData.items.forEach { modelContext.insert($0) }
    }

    return container
  } catch {
    fatalError("Failed to create container")
  }
}()

struct SampleData {
    static var items: [Item] = [
        Item(text: "Apple", imageData: nil),
        Item(text: "Orange", imageData: nil)
    ]
}
