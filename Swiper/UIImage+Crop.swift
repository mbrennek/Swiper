//
//  UIImage+Crop.swift
//  Swiper
//
//  Created by Matt Brenneke on 2/9/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import UIKit

extension UIImage {
    func crop(_ rect: CGRect) -> UIImage {
        let scaledRect = CGRect(x: rect.origin.x * self.scale, y: rect.origin.y * self.scale, width: rect.width * self.scale, height: rect.height * self.scale)
        let imageRef = self.cgImage!.cropping(to: scaledRect)
        let result = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return result
    }
}
