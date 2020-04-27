//
//  TrustedDeviceViewModel.swift
//  SocialDistanceTracker
//
//  Created by Vivek John on 27/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import Foundation

class TrustedDeviceViewModel: NSObject {
    
    // For getting all trusted list
    func fetchFromUserDefault() -> [[String: String]] {
        if let loadedData = UserDefaults.standard.array(forKey: "TrustedDevice") as? [[String: String]] {
            return loadedData
        }
        return []
    }
}
