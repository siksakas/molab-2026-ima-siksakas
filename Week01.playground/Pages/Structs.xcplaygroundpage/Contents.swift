//: [Previous](@previous)

import Foundation

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
