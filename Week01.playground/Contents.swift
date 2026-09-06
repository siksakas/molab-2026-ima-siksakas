import UIKit

var greeting = "Hello, playground"
// length of string
print(greeting.count)

// to uppercase
print(greeting.uppercased())

// hasPrefix
print(greeting.hasPrefix("He"))
print(greeting.hasPrefix("Fe"))

// hasSuffix
print(greeting.hasSuffix("playground"))

let k = 100

// isMultiple(of:)
print(k.isMultiple(of: 2))

var isAuthenticated = false
isAuthenticated = !isAuthenticated
print(isAuthenticated)

// another way is to use .toggle()
isAuthenticated.toggle()
print(isAuthenticated)

let name = "Siksaka"
let age = 19

print("My name is \(name) and I am \(age) yrs old")

let C = 29
let F = C * 9 / 5 + 32

print("\(C) degrees C is equal to \(F) degrees F")

var beatles = ["John", "Paul", "George", "Ringo"]
let numbers = [4, 8, 15, 16, 23, 42]
var temperatures = [25.3, 28.2, 26.4]
print(beatles[0])
print(numbers[1])
print(temperatures[2])

// can only append same type of data, also
// cannot do smt like: let notAllowed = firstBeatle + firstNumber
beatles.append("Adrian")

// creates an empty array of type Int
var scores = Array<Int>()
scores.append(100) //1 but is scores[0]
scores.append(80) //2 scores[1]
scores.append(85) //3 scores[2]
print(scores[1])
// .count can be used for # of elem in arr
print(scores.count)

//.remove(at:)
var characters = ["Lana", "Pam", "Ray", "Sterling"]
print(characters.count)

characters.remove(at: 2)
print(characters.count)

characters.removeAll()
print(characters.count)

let bondMovies = ["Casino Royale", "Spectre", "No Time To Die"]
print(bondMovies.contains("Frozen"))
print(bondMovies.reversed())
print(bondMovies.sorted())

//dictionary
let employee2 = [
    "name": "Taylor Swift",
    "job": "Singer",
    "location": "Nashville"
]

// warning because it is an optional
print(employee2["job"])
// it is an optional because
// Swift can't guarantee "job" actually exists.
if let job = employee2["job"]{
    print(job)
}
// another alternative is to provide a default value
print(employee2["job", default: "Unknown"])

// creating an empty dictionary and specifying which type it is
var heights = [String: Int]()
heights["Yao Ming"] = 229
heights["Shaquille O'Neal"] = 216
heights["LeBron James"] = 206
// the set stores values in any order it wants
// runs much faster with things like .contains()
var people = Set<String>()
people.insert("Denzel Washington")
people.insert("Tom Cruise")
people.insert("Nicolas Cage")

enum Weekday {
    // can also be written as
    // case monday, tuesday, wednesday, thursday, friday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
}
var day = Weekday.monday
day = Weekday.tuesday
day = Weekday.friday

//var day = Weekday.monday
//day = .tuesday
//day = .friday
//Swift knows that .tuesday must refer to Weekday.tuesday because day must always be some kind of Weekday.

let al = ["1","212","121","21","2","12","12"]
print(al.count)
// makes a set from the arr
let j = Set(al)
print(j.count)

let currentAge = 18
let canVote = currentAge >= 18 ? "Yes" : "No"


