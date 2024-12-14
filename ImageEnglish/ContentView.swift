//
//  ContentView.swift
//  ImageEnglish
//
//  Created by えみり on 2024/12/14.
//

import SwiftUI
import SwiftData
import ImagePlayground
import AVFoundation

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
    @State private var isSplidView = false
    
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
                    // 画像一覧
                    if isFlipped {
                        VStack {
                            ScrollView {
                                if isSplidView {
                                    // ２分割
                                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                                        ForEach(items) { item in
                                            NavigationLink(destination: ItemDetailView(item: item)) {
                                                if let url = item.imageUrl, let uiImage = UIImage(contentsOfFile: url.path) {
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
                                                    if let url = item.imageUrl, let uiImage = UIImage(contentsOfFile: url.path) {
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
                                        .foregroundStyle(.white)
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
                        
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                    } else {
                        
                        // 文字一覧
                        VStack {
                            TextField("Enter Keywords, Press Button", text: $newText)
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
                                            createdImageURL = url
                                            addItem()
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

struct ItemDetailView: View {
    let item: Item
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    speakText()
                } label: {
                    Image(systemName: "play.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                Text(item.text)
                    .font(.title)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding()
            
            if let url = item.imageUrl, let uiImage = UIImage(contentsOfFile: url.path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Item Details")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
    
    func speakText() {
        let utterance = AVSpeechUtterance(string: item.text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
