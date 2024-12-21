//
//  ContentView.swift
//  ImageEnglish
//
//  Created by えみり on 2024/12/14.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var isFlipped = false
    
    init() {
      UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        NavigationSplitView {
            ZStack {
                Rectangle()
                    .rotation3DEffect(
                        .degrees(isFlipped ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                
                VStack {
                    if isFlipped {
                        ImageListView(isFlipped: $isFlipped)
                    } else {
                        TextListView(isFlipped: $isFlipped)
                    }
                }
            }
        } detail: {
            Text(LocalizedStringKey("Select an item"))
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
