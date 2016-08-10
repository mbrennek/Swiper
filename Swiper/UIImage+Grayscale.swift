//
//  UIImage+Grayscale.swift
//  Swiper
//
//  Created by Matt Brenneke on 5/4/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import UIKit


extension UIImage {
    func grayscaleImage() -> UIImage {

        // Create image rectangle with current image width/height
        let imageRect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)

        // Grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()

        // Create bitmap content with current image size and grayscale colorspace
        let context = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height), 8, 0, colorSpace, CGImageAlphaInfo.None.rawValue)

        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        CGContextDrawImage(context!, imageRect, self.CGImage!)

        // Create bitmap image info from pixel data in current context
        let imageRef = CGBitmapContextCreateImage(context!)

        // Return a new UIImage object
        return UIImage.init(CGImage: imageRef!)
    }
}
