//
//  TextListView.swift
//  AIWordImage
//
//  Created by えみり on 2024/12/21.
//

import SwiftUI
import SwiftData
import ImagePlayground

struct TextListView: View {
    @Query private var items: [Item]
    @State var newText: String = ""
    @State private var showSheet = false
    @Binding var isFlipped: Bool
    @Environment(\.modelContext) private var modelContext
    @State var uiImage: UIImage? = nil
    
    var body: some View {
        VStack {
            TextField(LocalizedStringKey("Enter Keywords, Press Button"), text: $newText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding()
            
            List {
                ForEach(items) { item in
                    NavigationLink {
                        VStack {
                            if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                                ItemDetailView(item: item)
                                    .onAppear {
                                        self.uiImage = uiImage
                                    }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                        
                    } label: {
                        Text("\(item.text)")
                    }
                    
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                
                ToolbarItem {
                    Button {
                        showSheet = true
                    } label: {
                        Image(systemName: "apple.image.playground")
                            .foregroundStyle(.linearGradient(Gradient(colors: [.purple, .cyan, .orange]), startPoint: .top, endPoint: .bottom))
                    }
                    .imagePlaygroundSheet(
                        isPresented: $showSheet,
                        concept: newText) { url in
                            addItem(url: url)
                        }
                }
                
                ToolbarItem {
                    EditButton()
                        .foregroundStyle(UIDevice.current.userInterfaceIdiom == .pad ? Color.black : Color.white)
                }
                
                ToolbarItem {
                    Button {
                        withAnimation {
                            isFlipped.toggle()
                        }
                    } label: {
                        Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                            .foregroundStyle(.orange)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(UIDevice.current.userInterfaceIdiom == .pad ? Color(.secondarySystemBackground) : Color.black)
        }
        .background(UIDevice.current.userInterfaceIdiom == .pad ? Color(.secondarySystemBackground) : Color.black)
    }
    
    private func addItem(url: URL) {
        do {
            // URL から Data を生成
            let imageData = try Data(contentsOf: url)
            
            withAnimation {
                let newItem = Item(text: newText, imageData: imageData)
                modelContext.insert(newItem)
                try? modelContext.save()
            }
        } catch {
            // エラー発生時のハンドリング
            print("画像データの取得に失敗しました: \(error)")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
            try? modelContext.save()
        }
    }
}

#Preview {
    TextListView(isFlipped: .constant(false))
        .modelContainer(for: Item.self, inMemory: true)
}
