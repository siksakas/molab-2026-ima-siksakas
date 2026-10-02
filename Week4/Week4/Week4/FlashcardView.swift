//
//  FlashcardView.swift
//  Week4
//
//  Created by Siksaka Suriyasat on 10/1/26.
//
import SwiftUI
import AVFoundation

struct FlashcardView: View {
    var flashcard: Flashcard
    
    @State var currentSide = true
    let audioPlayer = AVSpeechSynthesizer()
    
    var canCheckAnswer: Bool
    
    var body: some View {
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
    FlashcardView(flashcard: Flashcard(front: "สวัสดี", back: "Hello"), canCheckAnswer: true)
}
