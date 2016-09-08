//
//  MainMenuViewController.swift
//  Swiper
//
//  Created by Matt Brenneke on 4/6/16.
//  Copyright © 2016 Matt Brenneke. All rights reserved.
//

import UIKit
import Crashlytics

class MainMenuViewController: UIViewController {

    @IBOutlet var beginnerButton : UIButton?
    @IBOutlet var intermediateButton : UIButton?
    @IBOutlet var advancedButon : UIButton?
    var themeBundle : NSBundleResourceRequest?

    override var preferredFocusedView: UIView? {
        var preferredFocusedView : UIView?
        let difficulty : String? = UserDefaults.standard.object(forKey: "gameDifficulty") as? String

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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestThemeBundle(self.currentTheme())
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }

        if let gameController = segue.destination as? GameViewController {
            guard let difficulty = GameDifficulty(rawValue: identifier) else {
                return
            }

            gameController.difficulty = difficulty
            gameController.selectedTheme = self.currentTheme()

            UserDefaults.standard.setValue(difficulty.rawValue, forKey: "gameDifficulty")
        }

        if let themeController = segue.destination as? ThemeSelectionViewController {
            themeController.delegate = self
        }
    }

    func currentTheme() -> String? {
        return UserDefaults.standard.object(forKey: "selectedTheme") as? String
    }

    func requestThemeBundle(_ theme: String?) {
        themeBundle = NSBundleResourceRequest.init(tags: Set([ "basic", theme ].flatMap({$0})))
        themeBundle?.beginAccessingResources(completionHandler: { (error) in
            if let error = error {
                Crashlytics.self().recordError(error)
                print(error)
            }
        })
    }
}

extension MainMenuViewController: ThemeSelectedProtocol {
    func selectedTheme(_ theme: String) {
        UserDefaults.standard.setValue(theme, forKey: "selectedTheme")
        self.requestThemeBundle(theme)
    }
}
