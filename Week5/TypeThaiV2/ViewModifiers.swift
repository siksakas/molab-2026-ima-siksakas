//
//  ViewModifiers.swift
//  TypeThaiV2
//
//  Created by Siksaka Suriyasat on 10/9/26.
//
import SwiftUI
import AVFoundation

struct ChunkyButtonStyle: ButtonStyle {
    private let depth: CGFloat = 7

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed
        configuration.label
            .fontDesign(.rounded)
            .fontWeight(.bold)
            .foregroundStyle(Color.ink)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .offset(y: pressed ? depth : 0)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.shadow)
                    .offset(y: 7)
            }
            .padding(.bottom, depth)
            .animation(.spring(response: 0.1, dampingFraction: 0.7), value: pressed)
    }
}



//
//struct RaisedButtonStyle: ButtonStyle {
//    var face: Color = .white
//    var shadow: Color = .shadow
//    var cornerRadius: CGFloat = 16
//    var depth: CGFloat = 5
//
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .background(
//                face,
//                in: RoundedRectangle(cornerRadius: cornerRadius)
//            )
//            .offset(y: configuration.isPressed ? depth : 0)
//            .background(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .fill(shadow)
//                    .offset(y: depth)
//            )
//            .padding(.bottom, depth)
//            .animation(
//                .spring(response: 0.1, dampingFraction: 0.7),
//                value: configuration.isPressed
//            )
//    }
//}
