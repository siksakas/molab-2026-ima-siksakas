//
//  ContentView.swift
//  molab-ima-2026
//
//  Created by Siksaka Suriyasat on 9/24/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            Tab("boat",systemImage: "sailboat"){
                CanvasAnimView()
            }
            Tab("shapes",systemImage: "triangle.fill"){
                ShapesView()
            }
        }
    }
}

#Preview {
    ContentView()
}
