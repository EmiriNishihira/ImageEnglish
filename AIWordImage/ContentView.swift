//
//  ContentView.swift
//  ImageEnglish
//
//  Created by えみり on 2024/12/14.
//

import SwiftUI
import SwiftData
import GoogleMobileAds

struct ContentView: View {
    @State var isFlipped = false
    
    init() {
      UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        NavigationSplitView {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
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
                    
//                    AdaptiveBannerWrapper()
//                        .frame(maxWidth: .infinity, maxHeight: 61)
                }
            }
            .background(
                LinearGradient(
                    colors: [
                        Color.black,
                        Color.purple.opacity(0.8),
                        Color.blue.opacity(0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .edgesIgnoringSafeArea(.bottom)
        } detail: {
            Text(LocalizedStringKey("Select an item"))
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
