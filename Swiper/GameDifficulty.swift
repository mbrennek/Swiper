//
//  GameDifficulty.swift
//  Swiper
//
//  Created by Matt Brenneke on 4/6/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import Foundation

enum GameDifficulty {
    case Beginner
    case Intermediate
    case Advanced

    func segueIdentifier() -> String {
        switch self {
        case .Beginner:
            return "beginnerSegue"
        case .Intermediate:
            return "intermediateSegue"
        case .Advanced:
            return "advancedSegue"
        }
    }

    func rows() -> Int {
        switch self {
        case .Beginner:
            return 2
        case .Intermediate:
            return 3
        case .Advanced:
            return 4
        }
    }

    func columns() -> Int {
        switch self {
        case .Beginner:
            return 3
        case .Intermediate:
            return 4
        case .Advanced:
            return 5
        }
    }
}