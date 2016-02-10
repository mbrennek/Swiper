//
//  SwipeGameTile.swift
//  Swiper
//
//  Created by Matt Brenneke on 2/9/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import UIKit

struct SwipeGameTile {
    let image : UIImage
    let tileNumber : Int
    let rect : CGRect

    init(image: UIImage, tileNumber: Int, rect: CGRect) {
        self.image = image;
        self.tileNumber = tileNumber
        self.rect = rect
    }
}

extension SwipeGameTile : Comparable {}

func ==(lhs: SwipeGameTile, rhs: SwipeGameTile) -> Bool {
    return lhs.tileNumber == rhs.tileNumber
}

func <(lhs: SwipeGameTile, rhs: SwipeGameTile) -> Bool {
    return lhs.tileNumber < rhs.tileNumber
}
