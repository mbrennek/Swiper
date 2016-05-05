//
//  UIImage+ColorOverlay.swift
//  Swiper
//
//  Created by Matt Brenneke on 2/9/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import UIKit

extension UIImage {
    func imageWithColorOverlay(colorOverlay: UIColor) -> UIImage
    {
        // create drawing context
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        // draw current image
        self.drawAtPoint(.zero)

        // determine bounding box of current image
        let rect = CGRect(origin: .zero, size: self.size)

        // get drawing context
        let context = UIGraphicsGetCurrentContext()

        // flip orientation
        CGContextTranslateCTM(context, 0.0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)

        // set overlay
        CGContextSetBlendMode(context, .HardLight)
        CGContextClipToMask(context, rect, self.CGImage)
        CGContextSetFillColorWithColor(context, colorOverlay.CGColor)
        CGContextFillRect(context, rect)

        let returnImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return returnImage
    }
}