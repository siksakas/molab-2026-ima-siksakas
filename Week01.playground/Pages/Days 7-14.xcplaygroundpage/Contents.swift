
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

protocol Buildings {
    var rooms: Int { set get }
    var cost: Int { set get }
    var agent: String { set get }
    
    func printSalesSummary() -> String
}

extension Buildings {
    func printSalesSummary() -> String {
        return "\(rooms) rooms, cost: \(cost), agent: \(agent)"
    }
}

struct House: Buildings {
    var rooms: Int
    var cost: Int
    var agent: String
}

struct Office: Buildings {
    var rooms: Int
    var cost: Int
    var agent: String
}

let house = House(
    rooms: 4,
    cost: 500_000,
    agent: "Sarah"
)

let office = Office(
    rooms: 20,
    cost: 2_000_000,
    agent: "Michael"
)

house.printSalesSummary()
office.printSalesSummary()

//func returnRandom (_ intArr: [Int]?) -> Int { if let arr = intArr { return arr.randomElement()} else { return Int.random(in: 1...100)} }

struct Car {
    let model : String
    let year : Int
    let seatNumber : Int
    private var gear : Int = 1
    
    mutating func shiftGear(direction: String){
        if(direction == "up" && gear < 10){
            gear += 1
        } else if (direction == "down" && gear > 1){
            gear -= 1
        }
    }

}
