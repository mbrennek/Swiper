//
//  AppDelegate.swift
//  Swiper
//
//  Created by Matt Brenneke on 12/1/15.
//  Copyright © 2015 Matt Brenneke. All rights reserved.
//

import UIKit
import GameController
import Fabric
import Crashlytics

private extension Selector {
    static let setupControllers = #selector(AppDelegate.setupControllers(_:))
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var motionDelegate: ReactToMotionEvent?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        Fabric.with([Crashlytics.self])

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: .setupControllers, name: GCControllerDidConnectNotification, object: nil)
        notificationCenter.addObserver(self, selector: .setupControllers, name: GCControllerDidDisconnectNotification, object: nil)
//        GCController.startWirelessControllerDiscoveryWithCompletionHandler { () -> Void in
//
//        }
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

