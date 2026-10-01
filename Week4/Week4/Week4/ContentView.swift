//
//  ContentView.swift
//  Week4
//
//  Created by Siksaka Suriyasat on 10/1/26.
//

import SwiftUI

struct ContentView: View {
    @State var index = 0
    
    let flashcards: [Flashcard] = [
        Flashcard(front: "สวัสดี", back: "Hello"),
        Flashcard(front: "ขอบคุณ", back: "Thank you"),
        Flashcard(front: "ขอโทษ", back: "Sorry")
    ]
    
    var body: some View {
        VStack {
            Text("Flashcard Practice")
                .font(Font.largeTitle.bold())
            
            FlashcardView(flashcard: flashcards[index])
            
            HStack {
                Button {
                    if(index>0){
                        index -= 1
                    } else {
                        index = flashcards.count-1
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .font(Font.largeTitle)
                        .frame(maxWidth: .infinity, maxHeight: 75)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.bg)
                        )
                }
                
                Button {
                    if(index<flashcards.count-1){
                        index += 1
                    } else {
                        index = 0
                    }
                } label: {
                    Image(systemName: "arrow.right")
                        .font(Font.largeTitle)
                        .frame(maxWidth: .infinity, maxHeight: 75)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.bg)
                        )
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
