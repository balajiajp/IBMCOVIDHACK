//
//  AppDelegate.swift
//  SocialDistanceTracker
//
//  Created by Ayyalu  Jeyaprakash, Balaji (Cognizant) on 23/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import UIKit
import ResearchKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var userIsRegistered = false
    var userTypeIsVendor = false
    var userQRCode : UIImage? = nil
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            window!.tintColor = UIColor { traitCollection -> UIColor in
                return traitCollection.userInterfaceStyle == .light ? #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1) : #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            }
        } else {
            window!.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        }
        return true
    }

}

