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
    @State var uiImage: UIImage? = nil
    @State private var isShowAlert = false
    @State private var isFlipped = false
    
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
                        VStack {
                            Text("CollectionViewで画像表示する")
                                .font(.title)
                                .foregroundColor(.green)
                                .padding()
                        }
                        .toolbar {
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
                        
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                    } else {
                        VStack {
                            TextField("Enter Keywords", text: $newText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                                .padding()
                            
                            List {
                                ForEach(items) { item in
                                    NavigationLink {
                                        VStack {
                                            if let url = item.imageUrl, let uiImage = UIImage(contentsOfFile: url.path) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                                        .toolbar {
                                            ToolbarItem {
                                                Button {
                                                    saveImageToPhotos()
                                                } label: {
                                                    Image(systemName: "square.and.arrow.down")
                                                        .foregroundColor(.white)
                                                }
                                                .alert(isPresented: $isShowAlert) {
                                                    Alert(title: Text("Image saved successfully!"))
                                                }
                                            }
                                        }
                                        
                                    } label: {
                                        Text("\(item.text)")
                                    }
                                    
                                }
                                .onDelete(perform: deleteItems)
                            }
                            .scrollContentBackground(.hidden)
                            .background(Color.black)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    EditButton()
                                        .foregroundStyle(.white)
                                }
                                
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
                                            createdImageURL = url
                                            addItem()
                                        }
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
                        }
                        .background(.black)
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
            try? modelContext.save()
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
    
    private func saveImageToPhotos() {
        guard let uiImage = uiImage else { return }
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: uiImage)
        isShowAlert = true
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
