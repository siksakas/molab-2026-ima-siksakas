////
////  ContentView.swift
////  week7hw
////
////  Created by Siksaka Suriyasat on 10/21/26.
////
//
//import SwiftUI
//import PhotosUI
//
//struct ContentView: View {
//    @State private var selectedItem: PhotosPickerItem?
//    @State private var originalImage: UIImage?
//    @State private var displayedImage: UIImage?
//    @State private var isPixelated: Bool = false
//    @State private var pixelsWide: Double = 64
//
//    var body: some View {
//        VStack(spacing: 20) {
//            if let displayedImage {
//                Image(uiImage: displayedImage)
//                    .resizable()
//                    // if the boolean isPixelated is true, then there is NO interpolation
//                    .interpolation(isPixelated ? .none : .high)
//                    .scaledToFit()
//                    .frame(maxHeight: 300)
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//            } else {
//                Image(systemName: "photo")
//                    .font(.system(size: 80))
//                    .foregroundStyle(.secondary)
//            }
//
//            PhotosPicker("Select Photo", selection: $selectedItem, matching: .images)
//                .buttonStyle(.borderedProminent)
//
//            // if there is an img
//            if originalImage != nil {
//                VStack {
//                    Text("Pixels wide: \(Int(pixelsWide))")
//                    Slider(value: $pixelsWide, in: 8...128, step: 8)
//                }
//
//                Button(isPixelated ? "Show Original" : "Convert to Pixel Art") {
//                    isPixelated.toggle()
//                    updateDisplayedImage()
//                }
//                .buttonStyle(.bordered)
//            }
//        }
//        .padding()
//        .onChange(of: selectedItem) { _, newItem in
//            Task {
//                if let data = try? await newItem?.loadTransferable(type: Data.self),
//                   let image = UIImage(data: data) {
//                    originalImage = image
//                    isPixelated = false
//                    updateDisplayedImage()
//                }
//            }
//        }
//        .onChange(of: pixelsWide) {
//            if isPixelated { updateDisplayedImage() }
//        }
//    }
//
//    private func updateDisplayedImage() {
//        guard let originalImage else { return }
//        displayedImage = isPixelated
//            ? pixelate(originalImage, pixelsWide: Int(pixelsWide))
//            : originalImage
//    }
//
//
//    private func pixelate(_ image: UIImage, pixelsWide: Int) -> UIImage {
//        let aspect = image.size.height / image.size.width
//        let size = CGSize(width: pixelsWide, height: max(1, Int((CGFloat(pixelsWide) * aspect).rounded())))
//
//        let format = UIGraphicsImageRendererFormat()
//        format.scale = 1 // one point = one pixel, so the result is truly tiny
//
//        return UIGraphicsImageRenderer(size: size, format: format).image { context in
//            // High-quality downsampling averages each block instead of picking a single pixel
//            context.cgContext.interpolationQuality = .high
//            image.draw(in: CGRect(origin: .zero, size: size))
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
