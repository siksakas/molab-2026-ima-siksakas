//
//  TestingView.swift
//  Week4
//
//  Created by Siksaka Suriyasat on 10/1/26.
//
import SwiftUI

struct TestingView: View {
    @State private var index = 0
    var correctAnswerHasAppeared: Bool = false
    var currentCorrectAnswer = Int.random(in:0...2)
    
    var body: some View {
        VStack{
            FlashcardView(flashcard: flashcards[index],canCheckAnswer: false)
            
            answerButtons
        }
    }
    
    private var answerButtons: some View {
        VStack (spacing:20){
            Button {
                
            } label: {
                if currentCorrectAnswer == 0 {
                    Text(flashcards[index].back)
                        .foregroundStyle(Color.bgDarker)
                        .font(Font.title.bold())
                        .fontDesign(.rounded)
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
                } else {
                    let rand = getRandomFlashcard(index)
                    Text(flashcards[rand].back)
                        .foregroundStyle(Color.bgDarker)
                        .font(Font.title.bold())
                        .fontDesign(.rounded)
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
            
            Button {
                
            } label: {
                if currentCorrectAnswer == 1 {
                    Text(flashcards[index].back)
                        .foregroundStyle(Color.bgDarker)
                        .font(Font.title.bold())
                        .fontDesign(.rounded)
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
                } else {
                    let rand = getRandomFlashcard(index)
                    Text(flashcards[rand].back)
                        .foregroundStyle(Color.bgDarker)
                        .font(Font.title.bold())
                        .fontDesign(.rounded)
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
            
            Button {
                
            } label: {
                if currentCorrectAnswer == 2 {
                    Text(flashcards[index].back)
                        .foregroundStyle(Color.bgDarker)
                        .font(Font.title.bold())
                        .fontDesign(.rounded)
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
                } else {
                    let rand = getRandomFlashcard(index)
                    Text(flashcards[rand].back)
                        .foregroundStyle(Color.bgDarker)
                        .font(Font.title.bold())
                        .fontDesign(.rounded)
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
        }
        .padding(20)
    }
}

// later change to accept an arr of Ints so that there cannot be duplicate options
func getRandomFlashcard(_ cannotBe: Int) -> Int {
    var random = Int.random(in: 0...flashcards.count-1)
    if random == cannotBe {
        random = getRandomFlashcard(cannotBe)
    }
    return random
}


#Preview {
    TestingView()
}
