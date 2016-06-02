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
    var resourceRequest : NSBundleResourceRequest?
    var selectedTheme : String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: conditionally check if the resource is available first, show a loading screen if it isn't
        resourceRequest = NSBundleResourceRequest.init(tags: [ selectedTheme ?? "basic" ])
        resourceRequest?.beginAccessingResourcesWithCompletionHandler({ (error) in
            if let error = error {
                // TODO: handle Error
                Crashlytics.self().recordError(error)
                print(error)
            } else {
                if let contentsURL = self.resourceRequest?.bundle.URLForResource("contents", withExtension: "json") {
                    if let contentsData = NSData(contentsOfURL: contentsURL) {
                        if let contents = try? NSJSONSerialization.JSONObjectWithData(contentsData, options: .AllowFragments) as? Array<[String:String]> {
                            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                                if let scene = GameScene(fileNamed: "GameScene"), contents = contents where contents.count > 0 {
                                    let index = Int(arc4random_uniform(UInt32(contents.count)))
                                    scene.imageName = contents[index]["filename"]! // TODO: get rid of !
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
                            })
                        }
                    }
                }
            }
        })
    }
}
