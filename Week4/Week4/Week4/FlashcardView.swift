//
//  FlashcardView.swift
//  Week4
//
//  Created by Siksaka Suriyasat on 10/1/26.
//
import SwiftUI
import SwiftData
import AVFoundation

struct FlashcardView: View {
    @Query var savedWords: [SavedWords]
    @Environment(\.modelContext) var modelContext
    
    var flashcard: Flashcard
    var canCheckAnswer: Bool
    
    let audioPlayer = AVSpeechSynthesizer()
    
    @Binding var currentSide: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        modelContext.insert(SavedWords(savedFront: flashcard.front, savedBack: flashcard.back))
                        print(savedWords)
                    } label: {
                        Image(systemName: "bookmark")
                    }
        
                }
                Spacer()
            }
            .padding(30)
            
            VStack {
                Text(currentSide ? flashcard.front : flashcard.back)
                    .font(Font.largeTitle.weight(.bold))
                    .padding(20)
                    .fontDesign(.rounded)
                    
                
                Button {
                    let utterance = AVSpeechUtterance(string: currentSide ? flashcard.front : flashcard.back)
                    // if the current side is thai it sets the speech locale to th
                    if (currentSide) {
                        utterance.voice = AVSpeechSynthesisVoice(language: "th-TH")
                    }
                    utterance.rate = 0.3
                    audioPlayer.speak(utterance)
                } label: {
                    Image(systemName: "speaker.wave.3")
                        .foregroundStyle(Color.bgDarker)
                }
            }
            
        }
        
        
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.bg)
                .shadow(
                    color: .black.opacity(0.08),
                    radius: 5,
                    x: 0,
                    y: 3
                )
        )
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.bgDark)
                .offset(y:6)
        )
        .padding(.horizontal,20)
        .onTapGesture {
            if canCheckAnswer {
                currentSide.toggle()
            }
        }
        
        
    }
}

#Preview {
    @Previewable @State var tempBool: Bool = false
    FlashcardView(flashcard: Flashcard(front: "สวัสดี", back: "Hello"), canCheckAnswer: true,currentSide: $tempBool)
    
}
