//
//  VocabWord.swift
//  TypeThaiV2
//
//  Created by Siksaka Suriyasat on 10/9/26.
//
import Foundation

struct VocabWord: Identifiable, Codable {
    let id: String
    let thai: String
    let english: String
    let type: String
}

func loadWords() -> [VocabWord] {

    guard let url = Bundle.main.url(
        forResource: "vocabWords",
        withExtension: "json"
    ) else {
        print("could not find file")
        return []
    }

    guard let data = try? Data(contentsOf: url) else {
        return []
    }

    guard let words = try? JSONDecoder().decode(
        [VocabWord].self,
        from: data
    ) else {
        return []
    }

    return words
}
