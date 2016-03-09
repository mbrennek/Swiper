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

    func testSwipeDown() {
        let rows = 3
        let cols = 4
        let bottomRowBlankData : [Int?] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, nil]
        let bottomRowBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: bottomRowBlankData)
        let middleRowBlankData : [Int?] = [1, 2, 3, 4, 5, 6, 7, nil, 9, 10, 11, 8]
        let middleRowBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: middleRowBlankData)
        let topRowBlankData : [Int?] = [1, 2, 3, nil, 5, 6, 7, 4, 9, 10, 11, 8]
        let topRowBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: topRowBlankData)

        XCTAssertEqual(bottomRowBlankGameState.swipeDown(), middleRowBlankGameState)
        XCTAssertEqual(middleRowBlankGameState.swipeDown(), topRowBlankGameState)
        XCTAssertEqual(topRowBlankGameState.swipeDown(), topRowBlankGameState)
    }

    func testSwipeLeft() {
        let rows = 2
        let cols = 3
        let leftColBlankData : [Int?] = [1, 2, 3, nil, 4, 5]
        let leftColBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: leftColBlankData)
        let midColBlankData : [Int?] = [1, 2, 3, 4, nil, 5]
        let midColBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: midColBlankData)
        let rightColBlankData : [Int?] = [1, 2, 3, 4, 5, nil]
        let rightColBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: rightColBlankData)

        XCTAssertEqual(leftColBlankGameState.swipeLeft(), midColBlankGameState)
        XCTAssertEqual(midColBlankGameState.swipeLeft(), rightColBlankGameState)
        XCTAssertEqual(rightColBlankGameState.swipeLeft(), rightColBlankGameState)
    }

    func testSwipeRight() {
        let rows = 2
        let cols = 3
        let leftColBlankData : [Int?] = [1, 2, 3, nil, 4, 5]
        let leftColBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: leftColBlankData)
        let midColBlankData : [Int?] = [1, 2, 3, 4, nil, 5]
        let midColBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: midColBlankData)
        let rightColBlankData : [Int?] = [1, 2, 3, 4, 5, nil]
        let rightColBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: rightColBlankData)

        XCTAssertEqual(leftColBlankGameState.swipeRight(), leftColBlankGameState)
        XCTAssertEqual(midColBlankGameState.swipeRight(), leftColBlankGameState)
        XCTAssertEqual(rightColBlankGameState.swipeRight(), midColBlankGameState)
    }

    func testTapValid() {
        let rows = 3
        let cols = 4
        let midRowBlankData : [Int?] = [1, 2, 3, 4, 5, nil, 7, 8, 9, 10, 11, 6]
        let midRowBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: midRowBlankData)

        XCTAssertEqual(midRowBlankGameState.tap(1), try! SwipeGameState<Int>(rows: rows, columns: cols, data: [1, nil, 3, 4, 5, 2, 7, 8, 9, 10, 11, 6]))
        XCTAssertEqual(midRowBlankGameState.tap(4), try! SwipeGameState<Int>(rows: rows, columns: cols, data: [1, 2, 3, 4, nil, 5, 7, 8, 9, 10, 11, 6]))
        XCTAssertEqual(midRowBlankGameState.tap(6), try! SwipeGameState<Int>(rows: rows, columns: cols, data: [1, 2, 3, 4, 5, 7, nil, 8, 9, 10, 11, 6]))
        XCTAssertEqual(midRowBlankGameState.tap(9), try! SwipeGameState<Int>(rows: rows, columns: cols, data: [1, 2, 3, 4, 5, 10, 7, 8, 9, nil, 11, 6]))
    }

    func testTapInvalid() {
        let rows = 3
        let cols = 4
        let bottomRowBlankData : [Int?] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, nil]
        let bottomRowBlankGameState = try! SwipeGameState<Int>(rows: rows, columns: cols, data: bottomRowBlankData)

        XCTAssertEqual(bottomRowBlankGameState, bottomRowBlankGameState.tap(0))
        XCTAssertEqual(bottomRowBlankGameState, bottomRowBlankGameState.tap(4))
        XCTAssertEqual(bottomRowBlankGameState, bottomRowBlankGameState.tap(11))
    }

    func testBlankIndex() {
        let rows1 = 2
        let cols1 = 3
        let data1 : [Int?] = [1, 2, 3, 4, 5, nil]
        let gameState1 = try! SwipeGameState<Int>(rows: rows1, columns: cols1, data: data1)
        XCTAssertEqual(gameState1.blankIndex(), 5)

        let rows2 = 2
        let cols2 = 3
        let data2 : [Int?] = [1, 2, 3, nil, 4, 5]
        let gameState2 = try! SwipeGameState<Int>(rows: rows2, columns: cols2, data: data2)
        XCTAssertEqual(gameState2.blankIndex(), 3)

        let rows3 = 2
        let cols3 = 3
        let data3 : [Int?] = [nil, 2, 3, 4, 5, 1]
        let gameState3 = try! SwipeGameState<Int>(rows: rows3, columns: cols3, data: data3)
        XCTAssertEqual(gameState3.blankIndex(), 0)
    }

    func testWonState() {
        let rows1 = 2
        let cols1 = 3
        let data1 : [Int?] = [1, 2, 3, 4, 5, nil]
        let gameState1 = try! SwipeGameState<Int>(rows: rows1, columns: cols1, data: data1)
        XCTAssertTrue(gameState1.won())

        let rows2 = 3
        let cols2 = 2
        let data2 : [Int?] = [1, 2, 3, 4, 5, nil]
        let gameState2 = try! SwipeGameState<Int>(rows: rows2, columns: cols2, data: data2)
        XCTAssertTrue(gameState2.won())

        let rows3 = 3
        let cols3 = 2
        let data3 : [Int?] = [1, 2, 3, nil, 5, 4]
        let gameState3 = try! SwipeGameState<Int>(rows: rows3, columns: cols3, data: data3)
        XCTAssertFalse(gameState3.won())

        let rows4 = 2
        let cols4 = 2
        let data4 : [Int?] = [1, 2, 3, nil]
        let gameState4 = try! SwipeGameState<Int>(rows: rows4, columns: cols4, data: data4)
        XCTAssertTrue(gameState4.won())

        let rows5 = 2
        let cols5 = 2
        let data5 : [Int?] = [1, 2, nil, 3]
        let gameState5 = try! SwipeGameState<Int>(rows: rows5, columns: cols5, data: data5)
        XCTAssertFalse(gameState5.won())
    }

    func testEquity() {
        let rows1 = 2
        let cols1 = 3
        let data1 : [Int?] = [1, 2, 3, 4, 5, nil]
        let gameState1 = try! SwipeGameState<Int>(rows: rows1, columns: cols1, data: data1)

        let rows2 = 3
        let cols2 = 2
        let data2 : [Int?] = [1, 2, 3, 4, 5, nil]
        let gameState2 = try! SwipeGameState<Int>(rows: rows2, columns: cols2, data: data2)

        let rows3 = 3
        let cols3 = 2
        let data3 : [Int?] = [1, 2, 3, nil, 5, 4]
        let gameState3 = try! SwipeGameState<Int>(rows: rows3, columns: cols3, data: data3)

        XCTAssertNotEqual(gameState1, gameState2)

        XCTAssertEqual(gameState1, gameState1)

        XCTAssertNotEqual(gameState2, gameState3)
    }
}
