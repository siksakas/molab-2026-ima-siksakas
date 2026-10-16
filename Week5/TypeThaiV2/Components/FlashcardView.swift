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
                        modelContext.insert(SavedWords(front: flashcard.front, back: flashcard.back))
                        print("word added!")
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
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
        )
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.shadow)
                .offset(y:6)
        )
        .padding(.horizontal,24)
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
