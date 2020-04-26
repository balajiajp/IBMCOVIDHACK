//
//  ScannerViewModel.swift
//  SocialDistanceTracker
//
//  Created by Vivek John on 27/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import Foundation
import UIKit

public enum PersonType: String {
    case FirstName
    case LastName
    case UserType
    case MobileNumber
    case AdhaarNumber
}

public enum UserCodeType: String {
    case User
    case Vendor
}

class ScannerViewModel: NSObject {

    var person : PersonModel = PersonModel()
    
    // qrCodeBounds
    var qrCodeBounds:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 4
        return view
    }()
    
    // For converting string to model
    func parseData(parsedString: String) {
        let filteredChars = "{}\"\n\t"
        let parsedString = parsedString.filter { filteredChars.range(of: String($0)) == nil }
        let typeArray : [String] = parsedString.components(separatedBy: ",")
        for string in typeArray {
            let keyArray : [String] = string.components(separatedBy: ":")
            if let key : PersonType = PersonType(rawValue: keyArray[0]) {
                let value : String = keyArray[1]
                
                switch key {
                case PersonType.FirstName :
                    person.firstName = value
                case PersonType.LastName :
                    person.lastName = value
                case PersonType.MobileNumber :
                    person.mobileNumber = value
                case PersonType.AdhaarNumber :
                    person.adhaarNumber = value
                case PersonType.UserType :
                    person.userType = value
                }
            }
        }
        
        guard person.firstName != nil, person.userType != nil else {
            return
        }
        self.saveToUserDefault(people: person)
    }
    
    // For saving to trusted list
    func saveToUserDefault(people:PersonModel) {
        var loadedData: [[String: String]] = self.fetchFromUserDefault()
        if loadedData.count != 0 {
            let peopleDict = ["FirstName":"\( String(person.firstName))","MobileNumber":"\(person.mobileNumber ?? "")","UserType":"\(String(person.userType))"]
            
            let contains = loadedData.map(){$0 == peopleDict}.contains(true)
            if contains{
                guard let presentVC = UIApplication.getPresentedViewController() else {
                    return
                }
                PresenterUtils.presentTrustedDeviceAlert(presentVC)
                UIDevice.vibrate()
            } else {
                loadedData.append(peopleDict as [String : String])
            }
            UserDefaults.standard.set(loadedData, forKey: "TrustedDevice")
        } else {
            let peopleDict = ["FirstName":"\( String(person.firstName))","MobileNumber":"\(person.mobileNumber ?? "")","UserType":"\(String(person.userType))"]
            UserDefaults.standard.set([peopleDict], forKey: "TrustedDevice")
        }
    }
    
    // For getting all trusted list
    func fetchFromUserDefault() -> [[String: String]] {
        if let loadedData = UserDefaults.standard.array(forKey: "TrustedDevice") as? [[String: String]] {
            return loadedData
        }
        return []
    }
    
    // alert for failed to scan
    func failed() {
        let cancelAction = UIAlertAction(title: PresenterUtilsAppValues.Dismiss, style: .default, handler: nil)
        guard let presentVC = UIApplication.getPresentedViewController() else {
            return
        }
        PresenterUtils.presentAlertWithTitle(PresenterUtilsAppValues.ScanningFailed,
                                              message: "",
                                              cancelAction: cancelAction,
                                              alternateActions: nil,
                                              fromController: presentVC,
                                              preferredStyle: .alert)
    }
}
