//: [Previous](@previous)

import Foundation
import UIKit

let path = Bundle.main.path(forResource: "ascii.txt", ofType: nil)
let str = try String(contentsOfFile: path!, encoding: .utf8)
print(str)

let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1024, height: 1024))

let image = renderer.image { context in
    UIColor.white.setFill()
    context.fill(CGRect(x: 0, y: 0, width: 1024, height: 1024))

    UIColor.black.setFill()
    context.fill(CGRect(x: 200, y: 200, width: 200, height: 200))
    context.fill(CGRect(x: 600, y: 200, width: 200, height: 200))
    context.fill(CGRect(x: 400, y: 500, width: 200, height: 200))
}
