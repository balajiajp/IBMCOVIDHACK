//
//  CameraPermissionsManager.swift
//  SocialDistanceTracker
//
//  Created by Vivek John on 27/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import AVFoundation
import UIKit

public enum CameraAuthorizationStatus: Int {
    case authorized
    case cancelled
    case disabled
}

public class CameraPermissionsManager {
    public init() {
        
    }
    
    public func performCameraAuthorization(forController controller: UIViewController, completion: @escaping (CameraAuthorizationStatus) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            PresenterUtils.presentCameraSettingsAlert(controller,
            cancelledCompletion: completion)
            
        case .restricted:
            PresenterUtils.presentCameraSettingsAlert(controller)
            completion(.cancelled)
        case .authorized:
            completion(.authorized)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    completion(.authorized)
                } else {
                    completion(.cancelled)
                }
            }
        @unknown default:
            fatalError("Invalid camera auth status")
        }
    }
}
