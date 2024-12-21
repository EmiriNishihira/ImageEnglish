//
//  ImageListView.swift
//  AIWordImage
//
//  Created by えみり on 2024/12/21.
//

import SwiftUI
import SwiftData
import AVFoundation
import Translation

struct ImageListView: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State private var isSplidView = false
    @Query private var items: [Item]
    @Binding var isFlipped: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                if isSplidView {
                    // ２分割
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                        ForEach(items) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                        .cornerRadius(10)
                                        .clipped()
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                } else {
                    // １分割
                    VStack(spacing: 20) {
                            ForEach(items) { item in
                                NavigationLink(destination: ItemDetailView(item: item)) {
                                    if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .cornerRadius(10)
                                            .clipped()
                                    } else {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                }
                
            }
            .padding()
        }
        .toolbar {
            ToolbarItem {
                Button {
                    withAnimation {
                        isSplidView.toggle()
                    }
                } label: {
                    Image(systemName: isSplidView ? "square.split.1x2": "square.split.2x2")
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }

            ToolbarItem {
                Button {
                    withAnimation {
                        isFlipped.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.green, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }

        }
        .background(Color.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

#Preview {
    ImageListView(isFlipped: .constant(false))
        .modelContainer(for: Item.self)
}
