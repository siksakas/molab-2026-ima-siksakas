//
//  ContentView.swift
//  Week4
//
//  Created by Siksaka Suriyasat on 10/1/26.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            NavigationLink{
                ReviewView()
            } label: {
                Text("Review Flashcards")
                    .foregroundStyle(Color.bgDarker)
                    .font(Font.body.bold())
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity,maxHeight: 75)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.bg)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.bgDark)
                            .offset(y:6)
                    )
                    .padding(.vertical, 5)
            }
            
            NavigationLink{
                TestingView()
            } label: {
                Text("Test Flashcards")
                    .foregroundStyle(Color.bgDarker)
                    .font(Font.body.bold())
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity,maxHeight: 75)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.bg)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.bgDark)
                            .offset(y:6)
                    )
                    .padding(.vertical, 5)
                    
                    .navigationTitle(Text("Learn Thai!"))
                    .navigationBarTitleDisplayMode(.inline)
            }
            
            NavigationLink{
                SavedView()
            } label: {
                Text("Saved Flashcards")
                    .foregroundStyle(Color.bgDarker)
                    .font(Font.body.bold())
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity,maxHeight: 75)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.bg)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.bgDark)
                            .offset(y:6)
                    )
                    .padding(.vertical, 5)
                    
                    .navigationTitle(Text("Learn Thai!"))
                    .navigationBarTitleDisplayMode(.inline)
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
