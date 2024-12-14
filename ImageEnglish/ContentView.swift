//
//  ContentView.swift
//  ImageEnglish
//
//  Created by えみり on 2024/12/14.
//

import SwiftUI
import SwiftData
import ImagePlayground

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State var newText: String = ""
    @State private var showSheet = false
    @State private var createdImageURL: URL? = nil
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground

    var body: some View {
        NavigationSplitView {
            TextField("enterItem", text: $newText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding()
            
            List {
                ForEach(items) { item in
                    NavigationLink {
                        // 画像の表示
                        if let url = item.imageUrl, let uiImage = UIImage(contentsOfFile: url.path) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            Image(systemName: "photo") // 画像がない場合のプレースホルダー
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .foregroundColor(.gray)
                        }
                    } label: {
                        Text("\(item.text)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                
                ToolbarItem {
                    Button {
                        showSheet = true
                    } label: {
                        Label("Sheet Image", systemImage: "apple.image.playground")
                    }
                    .imagePlaygroundSheet(
                        isPresented: $showSheet,
                        concept: newText) { url in
                            createdImageURL = url
                            addItem()
                        }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(text: newText, imageUrl: createdImageURL)
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
