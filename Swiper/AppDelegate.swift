//
//  AppDelegate.swift
//  Swiper
//
//  Created by Matt Brenneke on 12/1/15.
//  Copyright © 2015 Matt Brenneke. All rights reserved.
//

import UIKit
import GameController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var motionDelegate: ReactToMotionEvent?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(setupControllers(_:)), name: GCControllerDidConnectNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(setupControllers(_:)), name: GCControllerDidDisconnectNotification, object: nil)
        GCController.startWirelessControllerDiscoveryWithCompletionHandler { () -> Void in

        }
        return true
    }

    func setupControllers(notification: NSNotification) {
        let controllers = GCController.controllers()
        for controller in controllers {
            controller.motion?.valueChangedHandler = { (motion: GCMotion)->() in
                if let delegate = self.motionDelegate {
                    delegate.motionUpdate(motion)
                }
            }
        }
    }
}

