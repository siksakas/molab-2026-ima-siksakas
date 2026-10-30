//
//  CameraModel.swift
//  week8
//
//  Created by Siksaka Suriyasat on 10/29/26.
//

import SwiftUI
import AVFoundation
import CoreImage

// MARK: - Model

@Observable
class CameraModel: NSObject {
  var previewImage: CGImage?
  var asciiFrame = ""

  @ObservationIgnored private let session = AVCaptureSession()
  @ObservationIgnored private let context = CIContext(options: nil)
  @ObservationIgnored private var isConfigured = false

  // Call from onAppear
  func start() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      setupSession()
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted { self.setupSession() }
      }
    default:
      print("Camera access denied")
    }
  }

  private func setupSession() {
    guard !isConfigured else { return }   // original could run setup twice
    isConfigured = true

    session.beginConfiguration()

    // 1. Camera input (front wide-angle; use .back for the rear camera)
    guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                               for: .video,
                                               position: .front),
          let input = try? AVCaptureDeviceInput(device: device),
          session.canAddInput(input)
    else {
      session.commitConfiguration()
      print("Could not set up camera input")
      return
    }
    session.addInput(input)

    // 2. Frame output: delivers each frame to captureOutput(...) below
    let output = AVCaptureVideoDataOutput()
    output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
    output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
    if session.canAddOutput(output) {
      session.addOutput(output)

      output.connection(with: .video)?.videoOrientation = .portrait
    }

    session.commitConfiguration()

    // startRunning() blocks, so keep it off the main thread,
    // and never call it between begin/commitConfiguration.
    DispatchQueue.global(qos: .userInitiated).async {
      self.session.startRunning()
    }
  }
}

extension CameraModel: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput,
                     didOutput sampleBuffer: CMSampleBuffer,
                     from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }

    // convert here on videoQueue so the main thread only receives the finished string
    let ascii = ASCIIRenderer.convert(image: cgImage, width: 128)

    DispatchQueue.main.async {
      self.previewImage = cgImage
      if let ascii { self.asciiFrame = ascii }
    }
  }
}

struct FrameView: View {
  var image: CGImage?
  private let label = Text("Video feed")
  var body: some View {
    if let image = image {
      GeometryReader { geometry in
        Image(image, scale: 1.0, orientation: .upMirrored, label: label) // mirrored like a selfie camera
          .resizable()
          .scaledToFill()
          .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
          .clipped()
      }
    } else {
      EmptyView()
    }
  }
}

#Preview {
  ContentView()
}
