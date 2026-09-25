//
//  Shapes.swift
//  molab-ima-2026
//
//  Created by Siksaka Suriyasat on 9/24/26.
//

import SwiftUI

struct ShapesView: View {

    let colors: [Color] = [
        .red,
        .green,
        .yellow,
        .blue,
        .purple
    ]

    var body: some View {

        Canvas { context, size in

            let lineWidth = 8.0

            //five per row
            let nsize = CGSize(
                width: size.width / 5,
                height: size.width / 5
            )

            var arect = CGRect(
                origin: .zero,
                size: nsize
            )

            // keep drawing until we reach the bottom
            while arect.origin.y < size.height {

                let randomShape = Int.random(in: 0...1)
                let randomColor = colors.randomElement()!

                // circle
                if randomShape == 0 {

                    let ellipsePath = Path(ellipseIn: arect)

                    context.stroke(
                        ellipsePath,
                        with: .color(randomColor),
                        lineWidth: lineWidth
                    )

                }

                // square
                else {

                    let rectPath = Rectangle().path(in: arect)

                    context.stroke(
                        rectPath,
                        with: .color(randomColor),
                        lineWidth: lineWidth
                    )
                }

                // move to next cell
                arect.origin.x += nsize.width

                // move to next row
                if arect.origin.x >= size.width {
                    arect.origin.x = 0
                    arect.origin.y += nsize.height
                }
            }
        }
    }
}

#Preview {
    ShapesView()
}
