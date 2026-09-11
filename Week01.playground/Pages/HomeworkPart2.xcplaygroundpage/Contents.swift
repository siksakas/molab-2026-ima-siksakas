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

func createSmoke(size: Int) {
    let smallSmoke: [Character] = ["⠂", "⠁", "⠈", "⠐"]
    let regSmoke: [Character] = ["⠪", "⠕", "⡱", "⢎"]
    let bigSmoke: [Character] = ["⣦", "⣶", "⣷", "⣿","⢎", "⡱"]
    
    var lineSize: Int = size
    var whiteSpace: String = " "
    
    while (lineSize > 4) {
        var currLine: String = ""
        currLine.append(whiteSpace)
        
        if((Int.random(in: 0...3))%2==0) {
            currLine.append(" ")
        }
        for k in 1...lineSize {
            var variation = 0
            if (lineSize>8){
                variation = Int.random(in: 0...2)
            }
            //print("k equals + \(k)")
            if (k<2 || k>(lineSize-2)){
                if let smokeChar = smallSmoke.randomElement() {
                    currLine.append(smokeChar)
                }
            } else if (k<4+variation  || k>(lineSize-4-variation)){
                if let smokeChar = regSmoke.randomElement() {
                    currLine.append(smokeChar)
                }
            } else {
                if let smokeChar = bigSmoke.randomElement() {
                    currLine.append(smokeChar)
                }
            }
            
        }
        whiteSpace += " "
        lineSize -= (2 - Int.random(in: 0...1))
        print(currLine)
    }
}

createSmoke(size: 30)
