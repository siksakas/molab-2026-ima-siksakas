//: [Previous](@previous)

import Foundation

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

func returnRandom (_ intArr: [Int]?) -> Int { if let arr = intArr { return arr.randomElement()} else { return Int.random(in: 1...100)} }
