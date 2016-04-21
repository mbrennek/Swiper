//
//  GameViewController.swift
//  Swiper
//
//  Created by Matt Brenneke on 12/1/15.
//  Copyright (c) 2015 Matt Brenneke. All rights reserved.
//

import UIKit
import SpriteKit
import Crashlytics

class GameViewController: UIViewController {
    var difficulty = GameDifficulty.Beginner
    var bundledResourceRequest : NSBundleResourceRequest?
    var bundledResourcesAvailable = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: probably not the right place to be managing resource requests
        // TODO: get the tag of the currently selected resource
        // TODO: conditionally check if the resource is available first, show a loading screen if it isn't
        bundledResourceRequest = NSBundleResourceRequest.init(tags: [ "bundled" ])
        bundledResourceRequest?.beginAccessingResourcesWithCompletionHandler({ (error) in
            if let error = error {
                // handle Error
                Crashlytics.self().recordError(error)
                print(error)
            } else {
                self.bundledResourcesAvailable = true
                let images = self.bundledResourceRequest?.bundle.pathsForResourcesOfType("png", inDirectory: nil)
                print(images)

                if let scene = GameScene(fileNamed: "GameScene") {
                    scene.imageName = (images?.last)!
                    scene.difficulty = self.difficulty

                    // Configure the view.
                    let skView = self.view as! SKView
                    skView.showsFPS = true
                    skView.showsNodeCount = true

                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true

                    /* Set the scale mode to resize to fit the window */
                    scene.scaleMode = .ResizeFill

                    skView.presentScene(scene)
                }
            }
        })
    }

    deinit {
        if (bundledResourcesAvailable) {
            bundledResourceRequest?.endAccessingResources()
        }
    }
}
