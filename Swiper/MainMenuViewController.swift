//
//  MainMenuViewController.swift
//  Swiper
//
//  Created by Matt Brenneke on 4/6/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            return
        }
        let gameController = segue.destinationViewController as? GameViewController

        switch identifier {
        case GameDifficulty.Beginner.segueIdentifier():
            gameController?.difficulty = .Beginner
        case GameDifficulty.Intermediate.segueIdentifier():
            gameController?.difficulty = .Intermediate
        case GameDifficulty.Advanced.segueIdentifier():
            gameController?.difficulty = .Advanced
        default:
            print("segue to unknown view controller happening")
        }
    }
}
