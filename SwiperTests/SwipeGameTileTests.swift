//
//  SwipeGameTileTests.swift
//  Swiper
//
//  Created by Matt Brenneke on 2/23/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import XCTest
@testable import Swiper

class SwipeGameTileTests: XCTestCase {

    func testInit() {
        let image = UIImage()
        let tileNumber = 42

        let tile = SwipeGameTile(image: image, tileNumber: tileNumber)
        XCTAssertEqual(image, tile.image)
        XCTAssertEqual(tileNumber, tile.tileNumber)
    }

    func testEqual() {
        let firstTile = SwipeGameTile(image: UIImage(), tileNumber: 1)
        let secondTile = SwipeGameTile(image: UIImage(), tileNumber: 2)
        let firstCopy = firstTile

        XCTAssertEqual(firstTile, firstCopy)
        XCTAssertTrue(firstTile < secondTile)
        XCTAssertTrue(secondTile > firstTile)
        XCTAssertNotEqual(firstCopy, secondTile)
    }


}
