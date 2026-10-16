//
//  PracticeView.swift
//  TypeThaiV2
//
//  Created by Siksaka Suriyasat on 10/15/26.
//

import SwiftUI

struct PracticeView: View {
    
    let words: [VocabWord] = loadWords()
    @State var index = 0
    @AppStorage("thaiFirst") var thaiFirst = true
    @State var setTo = true
    
    var body: some View {
        VStack {
            
            Spacer()
            
            toggle
            
            FlashcardView(flashcard: Flashcard(front: words[index].thai, back: words[index].english), canCheckAnswer: true, currentSide: $thaiFirst)
            
            navButtons
            
            Spacer()
        }
        .background(.homeBackground)
    }
    
    var navButtons: some View {
        HStack (spacing: 10){
            Button {
                if(index>0){
                    index -= 1
                } else {
                    index = words.count-1
                }
                
                thaiFirst = setTo
            } label: {
                Image(systemName: "arrow.left")
            }
            .buttonStyle(ChunkyButtonStyle())
            
            Button {
                if(index<words.count-1){
                    index += 1
                } else {
                    index = 0
                }
                
                thaiFirst = setTo
            } label: {
                Image(systemName: "arrow.right")
            }
            .buttonStyle(ChunkyButtonStyle())
        }
        .padding(24)
    }
    
    var toggle: some View {
        HStack {
            Button {
                thaiFirst.toggle()
                setTo = thaiFirst
            } label: {
                HStack {
                    Text("Show thai first?  ")
                    
                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                        .foregroundStyle(Color.black)
                        .font(Font.largeTitle)
                }
            }
            .buttonStyle(ChunkyButtonStyle())
        }
        .padding(.horizontal,24)
    }
}

#Preview {
    PracticeView()
}
