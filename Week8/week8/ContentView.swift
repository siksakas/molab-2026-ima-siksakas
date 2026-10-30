//
//  ContentView.swift
//  week8
//
//  Created by Siksaka Suriyasat on 10/28/26.
//


import SwiftUI

struct ContentView: View {
//    @State private var ascii = ""
    @State var model = CameraModel()

    var body: some View {
        VStack {
            Text(model.asciiFrame)
                .font(.system(
                    size: 5,
                    design: .monospaced
                ))
                .foregroundStyle(.white)
                .fixedSize()
                .padding()
        }
        .background(.black)
        .onAppear { model.start() }

    }
}

#Preview {
    ContentView()
}
