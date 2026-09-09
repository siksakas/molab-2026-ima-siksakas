
//: [Previous](@previous)

import Foundation

let sayHello = { (_ name: String) -> String in
    "Hi \(name)!"
}

//var myArr: [Int] = []
//    for i in original {
//        if !(i % 2 == 0) {
//            myArr.append(i)
//        }
//    }

let sayHelloSimple = {
    print("Hi there!")
}

sayHello("blah blah")

let luckyNumbers = [7, 4, 38, 21, 16, 15, 12, 33, 31, 49]

func checkpoint5 (_ original: [Int]) -> [String] {
    
    var myArr: [String] = []
    var odds = original.filter({$0 % 2 != 0})
    
    odds.sort(by:{ $0 < $1 })
    odds.map({ myArr.append(String($0) + " is a lucky number.") })
    
    return myArr
}

var myNewArr = checkpoint5(luckyNumbers)
for luckyNumber in myNewArr {
    print(luckyNumber)
}

func checkpoint5Even(_ original: [Int]) -> [String]{
    
    var myArr: [String] = []
    var evens = original.filter({$0 % 2 == 0})
    
    // sort in ascending order
    evens.sort(by: {$0 < $1})
    evens.map({myArr.append(String($0) + " is an even luckier number.")})
    
    return myArr
}

var myNewerArr = checkpoint5Even(luckyNumbers)
for luckyNumber in myNewerArr {
    print(luckyNumber)
}
