//
//  UIImage+Grayscale.swift
//  Swiper
//
//  Created by Matt Brenneke on 5/4/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import UIKit


extension UIImage {
    func grayscaleImage() -> UIImage? {

        // Create image rectangle with current image width/height
        let imageRect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)

        // Grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()

        // Create bitmap content with current image size and grayscale colorspace
        if let context = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue) {
            // Draw image into current context, with specified rectangle
            // using previously defined context (with grayscale colorspace)
            context.draw(self.cgImage!, in: imageRect)

            // Create bitmap image info from pixel data in current context
            if let imageRef = context.makeImage() {
                // Return a new UIImage object
                return UIImage.init(cgImage: imageRef)
            }
        }
        return nil
    }
}
