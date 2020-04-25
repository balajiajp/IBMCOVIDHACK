//
//  PersonModel.swift
//  SocialDistanceTracker
//
//  Created by Dilip Sabat on 24/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import Foundation

extension String {
    func validString()-> Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
}
class PersonModel {
    var firstName: String!
    var lastName: String!
    var userType: String!
    var mobileNumber: String?
    var adhaarNumber: String?
    
    func validateUserInformation() -> Bool {
        guard let _ = firstName,
        let _ = lastName,
        let _ = userType else { return false }
        if (firstName.validString() && lastName.validString() && userType.validString()) && (mobileNumber?.validString() ?? false || adhaarNumber?.validString() ?? false){
            return true
        }
        return false
    }
}
