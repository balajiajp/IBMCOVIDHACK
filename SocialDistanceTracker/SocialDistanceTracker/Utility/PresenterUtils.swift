//
//  PresenterUtils.swift
//  SocialDistanceTracker
//
//  Created by Vivek John on 27/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import Foundation
import UIKit

struct PresenterUtilsAppValues {
    static let Okay = "OK"
    static let Cancel = "Cancel"
    static let Dismiss = "Dismiss"
    static let Settings = "Settings"
    static let ScanningFailed = "Scanning failed"
    static let Error = "Error"
    static let CameraDenied = "Camera access is denied"
    static let TrustedDevice = "Device Detected"
    static let TrustedDeviceMSG = "This is a Trusted Device"
}

struct PresenterUtils {

    //Presents an alert style dialog from the presenting view controller
    static func presentAlertWithTitle(_ title: String?,
                                                  message: String,
                                                  cancelAction: UIAlertAction = UIAlertAction(title: PresenterUtilsAppValues.Okay, style: .cancel, handler: nil),
                                                  alternateActions: [UIAlertAction]? = nil, fromController: UIViewController, preferredStyle: UIAlertController.Style = .alert) {
        DispatchQueue.main.async { () -> Void in
            let alert = getAlertWithTitle(title, message: message, cancelAction: cancelAction, alternateActions: alternateActions,
                                          preferredStyle: preferredStyle)
            
            fromController.present(alert, animated: true, completion: nil)
        }
    }
    
    // alert box
    fileprivate static func getAlertWithTitle(_ title: String?,
                                              message: String,
                                              cancelAction: UIAlertAction = UIAlertAction(title: PresenterUtilsAppValues.Okay, style: .cancel, handler: nil),
                                              alternateActions: [UIAlertAction]? = nil, preferredStyle: UIAlertController.Style = .alert) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        alert.addAction(cancelAction)
        if let alternateActions = alternateActions {
            for action in alternateActions {
                alert.addAction(action)
            }
        }
        
        return alert
    }
    
    // alert request to navigate to camera access permission settings
    static func presentCameraSettingsAlert(_ fromController: UIViewController, cancelledCompletion: ((CameraAuthorizationStatus) -> Void)? = nil) {

        let cancelAction = UIAlertAction(title: PresenterUtilsAppValues.Dismiss, style: .default, handler: { _ in
                                            cancelledCompletion?(.cancelled)
        })
        
        let settingsAction = (UIAlertAction(title: PresenterUtilsAppValues.Settings, style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        
        PresenterUtils.presentAlertWithTitle(PresenterUtilsAppValues.Error,
                                             message: PresenterUtilsAppValues.CameraDenied,
                                             cancelAction: cancelAction,
                                             alternateActions: [settingsAction],
                                             fromController: fromController)
        cancelledCompletion?(.disabled)
    }
    
    // alert for trusted device detected
    static func presentTrustedDeviceAlert(_ fromController: UIViewController) {
        let cancelAction = UIAlertAction(title: PresenterUtilsAppValues.Okay, style: .default, handler: nil)
        PresenterUtils.presentAlertWithTitle(PresenterUtilsAppValues.TrustedDevice,
                                             message: PresenterUtilsAppValues.TrustedDeviceMSG,
                                             cancelAction: cancelAction,
                                             alternateActions: nil,
                                             fromController: fromController)
    }
}
