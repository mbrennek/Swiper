//
//  SwipeGameStateTests.swift
//  Swiper
//
//  Created by Matt Brenneke on 1/12/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import XCTest
@testable import Swiper

class SwipeGameStateTests: XCTestCase {

    func testInit() {
        let rows = 2
        let cols = 2
        let data : [Int?] = [1, 2, 3, nil]
        let gameState = SwipeGameState<Int>(rows: rows, columns: cols, data: data)

        XCTAssertEqual(rows, gameState.rows)
        XCTAssertEqual(cols, gameState.columns)
        for (left, right) in zip(data, gameState.data) {
            XCTAssertEqual(left, right)
        }
    }

}
