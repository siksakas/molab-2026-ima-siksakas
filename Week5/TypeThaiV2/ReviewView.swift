//
//  ReviewView.swift
//  TypeThaiV2
//
//  Created by Siksaka Suriyasat on 10/15/26.
//

import SwiftUI

struct ReviewView: View {
    
    let words: [VocabWord] = loadWords()
    @AppStorage("thaiFirst") var thaiFirst = true
    
    
    var body: some View {
        NavigationStack {
            LazyVStack {
                ForEach(words) { word in
                    NavigationLink {
                        FlashcardView(flashcard:Flashcard(front:word.thai,back:word.english),canCheckAnswer: true,currentSide: $thaiFirst)
                    } label: {
                        Text(word.thai)
                    }
                    .buttonStyle(ChunkyButtonStyle())
                }
            }
            .padding(.horizontal,24)
            .background(.homeBackground)
            
        }
    }
}

#Preview {
    ReviewView()
}
