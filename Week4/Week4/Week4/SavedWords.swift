//
//  SavedWords.swift
//  Week4
//
//  Created by Siksaka Suriyasat on 10/9/26.
//

import SwiftData

@Model
final class SavedWords {
    var savedFront: String
    var savedBack: String
    
    init(savedFront: String, savedBack: String) {
        self.savedFront = savedFront
        self.savedBack = savedBack
    }
}
