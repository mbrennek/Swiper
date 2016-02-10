//
//  UIImage+Crop.swift
//  Swiper
//
//  Created by Matt Brenneke on 2/9/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import UIKit

extension UIImage {
    func crop(rect: CGRect) -> UIImage {
        let scaledRect = CGRect(x: rect.origin.x * self.scale, y: rect.origin.y * self.scale, width: rect.width * self.scale, height: rect.height * self.scale)
        let imageRef = CGImageCreateWithImageInRect(self.CGImage, scaledRect)
        let result = UIImage(CGImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return result
    }
}