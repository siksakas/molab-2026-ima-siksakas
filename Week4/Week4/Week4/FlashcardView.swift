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
    
    var body: some View {
        VStack {
            Text(currentSide ? flashcard.front : flashcard.back)
                .font(Font.largeTitle.weight(.bold))
                .padding(20)
                .onTapGesture {
                    currentSide.toggle()
                }
            
            Button {
                let utterance = AVSpeechUtterance(string: currentSide ? flashcard.front : flashcard.back)
                // if the current side is thai it sets the speech locale to th
                if (currentSide) {
                    utterance.voice = AVSpeechSynthesisVoice(language: "th-TH")
                }
                utterance.rate = 0.3
                audioPlayer.speak(utterance)
            } label: {
                Image(systemName: "speaker.fill")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.bg)
        )
        
    }
}

#Preview {
    FlashcardView(flashcard: Flashcard(front: "สวัสดี", back: "Hello"))
}
