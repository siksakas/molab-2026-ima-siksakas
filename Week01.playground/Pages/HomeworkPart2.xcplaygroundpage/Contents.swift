import UIKit

func createIsland(islandSize: Int) {
    for i in 1...islandSize {
        var str = ""
        for j in 1...5 {
            let randomInt = Int.random(in: 0...10)
            switch randomInt {
            case 0: str.append("🐟")
            case 1: str.append("🐠")
            case 2: str.append("🏝️")
            default: str.append("🌊")
            }
        }
        print(str)
    }
    print()
}

createIsland(islandSize: 5)

createIsland(islandSize: 10)
