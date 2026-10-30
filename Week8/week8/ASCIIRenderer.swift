//
//  ASCIIRenderer.swift
//  week8
//
//  Created by Siksaka Suriyasat on 10/28/26.
//

import UIKit
import CoreGraphics

struct ASCIIRenderer {
    //this creates an arr of characters from this string
    static let characters = Array("@%#*+=-:. ")
    
    static func convert(image cgImage: CGImage, width: Int = 128) -> String? {
        // to get the height based off the width, we take the width we put in and multiply it by the original aspect ratio
        //then we halve it by multiplying 0.5 bc ascii characters are taller than they are wide
        let height = Int(Double(width) * Double(cgImage.height)/Double(cgImage.width) * 0.5)
        
        //arr of unsigned integers
        var pixels = [UInt8](
            repeating: 0, //initializes each element to 0
            count: width * height //
        )
        
        let success = pixels.withUnsafeMutableBytes { bytes in
           guard let context = CGContext(
            data: bytes.baseAddress, //pointer to the very first byte of the buffer
            width: width, //resizes to desired w and h
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: CGColorSpaceCreateDeviceGray(), //converts to greyscale
            bitmapInfo: CGImageAlphaInfo.none.rawValue
           ) else {
               return false
           }
            
            context.interpolationQuality = .high

            context.draw(
                cgImage,
                in: CGRect(
                    x: 0,
                    y: 0,
                    width: width,
                    height: height
                )
            )
            
            return true
        }
        
        guard success else {
            return nil
        }
        
        var output = ""
        
        for y in 0..<height {
            for x in 0..<width {
                //the pixels arr is one dimensional so it gets the row and col from y * width + x
                //mayb should hv made a 2d arr instead
                let brightness = Int(pixels[y * width + x])
                
                //turns brightness val into a number within index range
                let index = brightness * (characters.count - 1) / 255

                output.append(characters[index])
            }
            output.append("\n")//newline
        }
        
        return output
    }
}
