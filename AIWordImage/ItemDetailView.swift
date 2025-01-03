//
//  ItemDetailView.swift
//  AIWordImage
//
//  Created by えみり on 2024/12/21.
//

import SwiftUI
import AVFAudio

struct ItemDetailView: View {
    let item: Item
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    @State private var isShowAlert = false
    @State private var showsTranslate = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    speakText()
                } label: {
                    Image(systemName: "speaker.wave.2.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.purple)
                }
                .padding()
                
                Text(LocalizedStringKey(item.text))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                Button {
                    showsTranslate = true
                } label: {
                    Image(systemName: "translate")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.purple)
                }
                .translationPresentation(isPresented: $showsTranslate, text: item.text)
                .padding()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding()
            
            if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(width: 300, height: 300)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    saveImageToPhotos()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .alert(isPresented: $isShowAlert) {
                    Alert(title: Text(LocalizedStringKey("Image saved successfully!")))
                }
            }
        }
        .background(Color.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    ItemDetailView(item: Item(text: "Hello", imageData: nil))
}
