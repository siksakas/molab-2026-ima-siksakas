//: [Previous](@previous)

import Foundation
import UIKit

let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1024, height: 1024))

let image = renderer.image { context in
    
    UIColor.white.setFill()
    context.fill(CGRect(x: 0, y: 0, width: 1024, height: 1024))

    UIColor.black.setFill()
    context.fill(CGRect(x: 200, y: 200, width: 64, height: 64))
    context.fill(CGRect(x: 64, y: 64, width: 64, height: 64))
    context.fill(CGRect(x: 400, y: 500, width: 64, height: 64))
}

let path = Bundle.main.path(forResource: "asciiHorse.txt", ofType: nil)
let str = try String(contentsOfFile: path!, encoding: .utf8)
print(str)

func load(_ file :String) -> String {
  let path = Bundle.main.path(forResource: file, ofType: nil)
  let str = try? String(contentsOfFile: path!, encoding: .utf8)
  return str ?? ""
}

let cat1 = load("cat1.txt")
let cat2 = load("cat2.txt")

let cat1Lines = cat1.split(separator: "\n", omittingEmptySubsequences: false)
let cat2Lines = cat2.split(separator: "\n", omittingEmptySubsequences: false)

// width of the left drawing
let cat1MaxWidth = cat1Lines.map { $0.count }.max() ?? 0
let spacing = 4

let totalLines = max(cat1Lines.count, cat2Lines.count)

for index in 0..<totalLines {
    var left = ""
    var right = ""

    if index < cat1Lines.count {
        left = String(cat1Lines[index])
    }

    if index < cat2Lines.count {
        right = String(cat2Lines[index])
    }

    let paddedLeft = left + String(repeating: " ", count: cat1MaxWidth - left.count + spacing)
    print(paddedLeft + right)
}
