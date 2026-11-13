//
//  ContentView.swift
//  LearnThai
//
//  Created by Siksaka Suriyasat on 11/5/26.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var showingLesson = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 6) {
                Text("LearnThai")
                    .font(.mali(48, weight: .bold))
            }

            CashierDog()
                .frame(width: 150, height: 100)
                .padding(.top, 28)

            Spacer()

            Button("Play") { showingLesson = true }
            .buttonStyle(SketchPrimaryButtonStyle())
            
            Button("Flashcards") { }
            .buttonStyle(SketchPrimaryButtonStyle())
            .padding(.top,17)
            
            Button("Characters") { }
            .buttonStyle(SketchPrimaryButtonStyle())
            .padding(.top,17)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(Color.lessonInk)
        .background(Color.white.ignoresSafeArea())
        .fullScreenCover(isPresented: $showingLesson) {
            AdventureFlow()
        }
    }
}

struct AdventureFlow: View {
    private enum Stage { case lesson, game }

    @State private var stage: Stage = .lesson

    var body: some View {
        ZStack {
            switch stage {
            case .lesson:
                Lesson1View(onFinish: {
                    withAnimation(.easeInOut(duration: 0.35)) { stage = .game }
                })
                .transition(.opacity)
            case .game:
                GameScreen()
                    .transition(.opacity)
            }
        }
    }
}

struct GameScreen: View {
    @Environment(\.dismiss) private var dismiss

    @State private var scene: GameScene = {
        let scene = GameScene(size: CGSize(width: 400, height: 800))
        scene.scaleMode = .resizeFill
        return scene
    }()

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
            .overlay(alignment: .topLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "house.fill")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundStyle(Color.lessonInk)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(.white))
                        .overlay(Circle().stroke(Color.lessonInk, lineWidth: 3.5))
                }
                .accessibilityLabel("Home")
                .padding(.leading, 20)
                .padding(.top, 8)
            }
    }
}

#Preview {
    ContentView()
}
