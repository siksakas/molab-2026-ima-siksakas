import SwiftUI

struct CanvasAnimView: View {
    
    let boats = [
#"""
                __/___
          _____/______|
  _______/_____\_______\_____
  \              < < <       |
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""#,

#"""
        _    _
     __|_|__|_|__
   _|____________|__
  |o o o o o o o o /  hjw
~'`~'`~'`~'`~'`~'`~'`~
"""#,

#"""
      I\
      I \
      I  \
      I*--\
      I    \
      I     \
      I______\
 _____I__O______
  \     ( )     b  ^  ^
^^^^^^^^^^^^^^^^^    ^
"""#
    ]
    
    
    var body: some View {
        ZStack {

            // dark blue background which is the water
            Color(red: 0.03, green: 0.05, blue: 0.12)
                .ignoresSafeArea()

            Canvas { context, size in

                // number its divided by is columns of boats
                let cellWidth = size.width / 2.0
                let cellHeight: CGFloat = 170

                //initial location
                var location = CGPoint(x: 20, y: 50)

                //while in frame
                while location.y < size.height - cellHeight / 2 {

                    let randomBoat = boats.randomElement()

                    if let randomBoat {
                        let boatText = Text(randomBoat)
                            .font(.system(size: 10,design: .monospaced))
                            .foregroundStyle(.white)
                        
                        location.x += CGFloat(Int.random(in: -10...30))
                        location.y += CGFloat(Int.random(in: -30...30))
                        context.draw(
                            context.resolve(boatText),
                            at: location,
                            anchor: .topLeading
                        )
                    }
                    
                    location.x += cellWidth

                    // loops back once off the right side of screen
                    if location.x >= size.width {
                        location.x = 20 + CGFloat(Int.random(in: -30...30))
                        location.y += cellHeight + CGFloat(Int.random(in: -30...30))
                    }
                }
            }
        }
    }
}

#Preview {
    CanvasAnimView()
}
