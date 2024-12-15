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
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State var uiImage: UIImage? = nil
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
                }
            }
        } detail: {
            Text(LocalizedStringKey("Select an item"))
        }
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

struct ItemDetailView: View {
    let item: Item
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    @State private var isShowAlert = false
    
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
            
            if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
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
        .toolbar {
            ToolbarItem {
                Button {
                    saveImageToPhotos()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.white)
                }
                .alert(isPresented: $isShowAlert) {
                    Alert(title: Text(LocalizedStringKey("Image saved successfully!")))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
    
    private func saveImageToPhotos() {
        guard let imageData = item.imageData, let uiImage = UIImage(data: imageData) else {
            return
        }
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: uiImage)
        isShowAlert = true
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
