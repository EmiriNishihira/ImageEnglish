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
            HStack {
                TextField(LocalizedStringKey("Enter Keywords, Press Button"), text: $newText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "apple.image.playground")
                        .font(.title2)
                        .foregroundStyle(.linearGradient(Gradient(colors: [.purple, .cyan, .orange]), startPoint: .top, endPoint: .bottom))
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .imagePlaygroundSheet(
                    isPresented: $showSheet,
                    concept: newText) { url in
                        addItem(url: url)
                    }
            }
            .padding()
            .background(
                Color(.systemBackground).opacity(0.8)
            )
            .frame(maxWidth: .infinity, maxHeight: 80)
            .cornerRadius(12)
            .shadow(radius: 10)
            
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
                        .cornerRadius(12)
                        .shadow(radius: 10)
                    } label: {
                        Text("\(item.text)")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    EditButton()
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .orange],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
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
            .scrollContentBackground(.hidden)
        }
        .padding()
    }
    
    private func addItem(url: URL) {
        do {
            let imageData = try Data(contentsOf: url)
            withAnimation {
                let newItem = Item(text: newText, imageData: imageData)
                modelContext.insert(newItem)
                try? modelContext.save()
            }
        } catch {
            print("Failed to fetch image data: \(error)")
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
        .modelContainer(previewContainer)
}
