//
//  Extension.swift
//  SocialDistanceTracker
//
//  Created by Vivek John on 27/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import UIKit
import AVFoundation

var vSpinner : UIView?

extension UIViewController {
    // hide the navigation bar
    func hideNavigationBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    // show the navigation bar
    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // start loading view
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .whiteLarge
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicator)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    // remove loading view
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

extension UIDevice {
    // device vibration
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

