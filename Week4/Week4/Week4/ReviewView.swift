//
//  ReviewView.swift
//  Week4
//
//  Created by Siksaka Suriyasat on 10/1/26.
//
import SwiftUI

struct ReviewView: View {
    @State private var index: Int = 0
    
    var body: some View {
        
        VStack {
            FlashcardView(flashcard: flashcards[index],canCheckAnswer: true)
            
            indexButtons
        }
    }
    
    private var indexButtons: some View {
        HStack {
            Button {
                if(index>0){
                    index -= 1
                } else {
                    index = flashcards.count-1
                }
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundStyle(Color.bgDarker)
                    .font(Font.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: 75)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.bg)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.bgDark)
                            .offset(y:6)
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
                    .foregroundStyle(Color.bgDarker)
                    .font(Font.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: 75)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.bg)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.bgDark)
                            .offset(y:6)
                    )
            }
        }
        .padding(20)
    }
}

#Preview {
    ReviewView()
}
