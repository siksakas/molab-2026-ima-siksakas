//
//  ContentView.swift
//  week7hw
//
//  Created by Siksaka Suriyasat on 10/21/26.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    // stores which photo the user selected
    @State private var selectedItem: PhotosPickerItem?
    @State private var image: UIImage?
    @State private var pixelsWide = 64.0
    
    var body: some View {
        VStack {
            PhotosPicker(
                "Choose Photo", //btn label
                selection: $selectedItem,
                matching: .images
            )
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    
            }
            
            Button("Convert to Pixel Art") {
                if let image {
                    self.image = pixelate(image,pixelsWide)
                }
            }
            
            Text("Pixels : \(Int(pixelsWide))")
            Slider(
                value: $pixelsWide,
                in: 8...64,
                step: 8
            )
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let loadedImage = UIImage(data: data) {

                    image = loadedImage
                }
            }
        }
        
        
    }
    
    // takes the original image, defines new size / smaller canvas, and redraws original image in that smaller size
    private func pixelate(_ image: UIImage, _ pixelsWide: Double) -> UIImage {
        
        let aspectRatio = image.size.height / image.size.width
        
        // creates the size and width based off of the aspectRatio
        let size = CGSize(
            width: CGFloat(pixelsWide), // width in pixels
            height: CGFloat(pixelsWide) * aspectRatio
        )
        
        // sets canvas at the set size
        let renderer = UIGraphicsImageRenderer(size: size)
        
        //creates canvas at this size
        let rectangle = CGRect(
            origin: .zero,
            size: size
        )

        // draw image onto the smaller canvas
        let newImage = renderer.image { _ in
            image.draw(in: rectangle)
        }
        
        
        return newImage
    }
}

#Preview {
    ContentView()
}
