//
//  UIImage+ColorOverlay.swift
//  Swiper
//
//  Created by Matt Brenneke on 2/9/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import UIKit

extension UIImage {
    func imageWithColorOverlay(_ colorOverlay: UIColor) -> UIImage?
    {
        // create drawing context
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        // draw current image
        self.draw(at: .zero)

        // determine bounding box of current image
        let rect = CGRect(origin: .zero, size: self.size)

        // get drawing context
        if let context = UIGraphicsGetCurrentContext() {
            // flip orientation
            context.translateBy(x: 0.0, y: self.size.height)
            context.scaleBy(x: 1.0, y: -1.0)

            // set overlay
            context.setBlendMode(.hardLight)
            context.clip(to: rect, mask: self.cgImage!)
            context.setFillColor(colorOverlay.cgColor)
            context.fill(rect)
        }
        let returnImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return returnImage
    }
}
