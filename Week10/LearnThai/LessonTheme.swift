//
//  LessonTheme.swift
//  LearnThai
//
//  Fonts and building blocks for the grammar lesson screens.
//  The lesson colors (Color.lessonInk etc.) live in Assets.xcassets > Lesson Colors.
//

import SwiftUI
import CoreText

enum MaliFont {
    static let registerOnce: Void = {
        for name in ["Mali-Regular", "Mali-SemiBold", "Mali-Bold"] {
            guard let url = Bundle.main.url(
                forResource: name,
                withExtension: "ttf"
            ) else { continue }

            CTFontManagerRegisterFontsForURL(
                url as CFURL,
                .process,
                nil
            )
        }
    }()
}

extension Font {
    static func mali(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        _ = MaliFont.registerOnce
        let name: String
        switch weight {
        case .bold, .heavy, .black: name = "Mali-Bold"
        case .semibold, .medium: name = "Mali-SemiBold"
        default: name = "Mali-Regular"
        }
        return .custom(name, size: size)
    }
}

// MARK: - Building blocks

extension View {
    /// White hand-drawn card with a thick ink outline.
    func sketchCard(fill: Color = .white, lineWidth: CGFloat = 3.5, cornerRadius: CGFloat = 18) -> some View {
        background {
            SketchRectangle(cornerRadius: cornerRadius).fill(fill)
        }
        .overlay {
            SketchRectangle(cornerRadius: cornerRadius)
                .stroke(Color.lessonInk,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
        }
    }
}

struct SketchPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.mali(18, weight: .bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background {
                SketchRectangle(cornerRadius: 20).fill(Color.lessonInk)
            }
            .offset(y: configuration.isPressed ? 3 : 0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct DashedDivider: View {
    var body: some View {
        HorizontalLine()
            .stroke(Color.lessonDivider, style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [6, 5]))
            .frame(height: 2)
    }
}

struct HorizontalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return p
    }
}

struct CashierDog: View {
    var body: some View {
        Image("cashier_dog")
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .foregroundStyle(Color.lessonInk)
            .accessibilityHidden(true)
    }
}
