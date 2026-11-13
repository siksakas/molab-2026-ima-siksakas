//
//  Styling.swift
//  LearnThai
//
//  Created by Siksaka Suriyasat on 11/6/26.
//

import SwiftUI

struct SketchRectangle: Shape {
    var cornerRadius: CGFloat = 18

    func path(in rect: CGRect) -> Path {
        let r = min(cornerRadius, rect.width / 4, rect.height / 4)
        let x = rect.minX
        let y = rect.minY
        let w = rect.width
        let h = rect.height

        var p = Path()
        p.move(to: CGPoint(x: x + r, y: y))

        // Slightly curved top
        p.addQuadCurve(
            to: CGPoint(x: x + w - r, y: y + 2),
            control: CGPoint(x: x + w / 2, y: y - 2)
        )

        p.addQuadCurve(
            to: CGPoint(x: x + w, y: y + r),
            control: CGPoint(x: x + w, y: y)
        )

        // Right side
        p.addQuadCurve(
            to: CGPoint(x: x + w - 1, y: y + h - r),
            control: CGPoint(x: x + w + 2, y: y + h / 2)
        )

        p.addQuadCurve(
            to: CGPoint(x: x + w - r, y: y + h),
            control: CGPoint(x: x + w, y: y + h)
        )

        // Bottom
        p.addQuadCurve(
            to: CGPoint(x: x + r, y: y + h - 1),
            control: CGPoint(x: x + w / 2, y: y + h + 2)
        )

        p.addQuadCurve(
            to: CGPoint(x: x, y: y + h - r),
            control: CGPoint(x: x, y: y + h)
        )

        // Left side
        p.addQuadCurve(
            to: CGPoint(x: x + 1, y: y + r),
            control: CGPoint(x: x - 2, y: y + h / 2)
        )

        p.addQuadCurve(
            to: CGPoint(x: x + r, y: y),
            control: CGPoint(x: x, y: y)
        )

        p.closeSubpath()
        return p
    }
}

struct SketchButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background {
                SketchRectangle()
                    .fill(.white)
            }
            .overlay {
                SketchRectangle()
                    .stroke(
                        .black,
                        style: StrokeStyle(
                            lineWidth: 3.5,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
            }
            .offset(y: configuration.isPressed ? 3 : 0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12),
                       value: configuration.isPressed)
    }
}
