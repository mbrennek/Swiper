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

    func testInitStateCopy() {
        let rows = 2
        let cols = 2
        let data : [Int?] = [1, 2, 3, nil]
        let gameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: data)

        XCTAssertEqual(rows, gameState.rows)
        XCTAssertEqual(cols, gameState.columns)
        for (left, right) in zip(data, gameState.data) {
            XCTAssertEqual(left, right)
        }
    }

    func testInitCountFail() {
        let rows = 2
        let cols = 2

        let tooManyItems : [Int?] = [1, 2, 3, 4, nil]
        XCTAssertThrowsError(try SwipeGameState<Int>(rows: rows, columns: cols, data: tooManyItems))

        let tooFewItems : [Int?] = [1, 2, nil]
        XCTAssertThrowsError(try SwipeGameState<Int>(rows: rows, columns: cols, data: tooFewItems))

        let justRightItems : [Int?] = [1, 2, 3, nil]
        do {
            let _ = try SwipeGameState<Int>(rows: rows, columns: cols, data: justRightItems)
        } catch {
            XCTFail("this init call should not have failed")
        }
    }

    func testInitTooManyNilsFail() {
        let rows = 2
        let cols = 2

        let tooManyNils : [Int?] = [1, 2, nil, nil]
        XCTAssertThrowsError(try SwipeGameState<Int>(rows: rows, columns: cols, data: tooManyNils))
    }

    func testInitNoNilFail() {
        let rows = 2
        let cols = 2

        let noNilData : [Int?] = [1, 2, 3, 4]
        XCTAssertThrowsError(try SwipeGameState<Int>(rows: rows, columns: cols, data: noNilData))
    }

    func testRandomize() {
        let rows = 3
        let cols = 4
        let data : [Int?] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, nil]
        let gameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: data)
        let randomState = gameState.randomize()

        XCTAssertEqual(randomState.data.count, data.count)

        // there is a non-zero chance that these asserts fail, and that the randomized
        // results are a winning puzzle.  If this test EVER asserts, then I need to
        // come up with a better randomization strategy.
        XCTAssertNotEqual(gameState, randomState)
        XCTAssertFalse(randomState.won())
    }

    func testSwipeUp() {
        let rows = 3
        let cols = 4
        let bottomRowBlankData : [Int?] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, nil]
        let bottomRowBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: bottomRowBlankData)
        let middleRowBlankData : [Int?] = [1, 2, 3, 4, 5, 6, 7, nil, 9, 10, 11, 8]
        let middleRowBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: middleRowBlankData)
        let topRowBlankData : [Int?] = [1, 2, 3, nil, 5, 6, 7, 4, 9, 10, 11, 8]
        let topRowBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: topRowBlankData)

        XCTAssertEqual(topRowBlankGameState.swipeUp(), middleRowBlankGameState)
        XCTAssertEqual(middleRowBlankGameState.swipeUp(), bottomRowBlankGameState)
        XCTAssertEqual(bottomRowBlankGameState.swipeUp(), bottomRowBlankGameState)
    }
}
