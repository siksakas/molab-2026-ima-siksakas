//
//  SavedView.swift
//  Week4
//
//  Created by Siksaka Suriyasat on 10/9/26.
//

import SwiftUI
import SwiftData

struct SavedView: View {
    @Query var savedWords: [SavedWords]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        List {
            ForEach(savedWords) { word in
                HStack{
                    Text(word.savedFront)
                }
            }
        }
    }
}

#Preview {
    SavedView()
        .modelContainer(for: SavedWords.self,inMemory: true)
}
