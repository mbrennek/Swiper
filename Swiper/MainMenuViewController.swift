//
//  MainMenuViewController.swift
//  Swiper
//
//  Created by Matt Brenneke on 4/6/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet var beginnerButton : UIButton?
    @IBOutlet var intermediateButton : UIButton?
    @IBOutlet var advancedButon : UIButton?

    override var preferredFocusedView: UIView? {
        var preferredFocusedView : UIView?
        let difficulty : String? = NSUserDefaults.standardUserDefaults().objectForKey("gameDifficulty") as? String

        if let difficulty = difficulty {
            if let gameDifficulty = GameDifficulty(rawValue: difficulty) {
                switch gameDifficulty {
                case .Beginner:
                    preferredFocusedView = beginnerButton
                case .Intermediate:
                    preferredFocusedView = intermediateButton
                case .Advanced:
                    preferredFocusedView = advancedButon
                }
            }
        }

        return preferredFocusedView ?? beginnerButton
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            return
        }
        let gameController = segue.destinationViewController as? GameViewController
        let possibleDifficulty = GameDifficulty(rawValue: identifier)
        guard let difficulty = possibleDifficulty else {
            return
        }

        gameController?.difficulty = difficulty

        NSUserDefaults.standardUserDefaults().setValue(difficulty.rawValue, forKey: "gameDifficulty")
    }
}
