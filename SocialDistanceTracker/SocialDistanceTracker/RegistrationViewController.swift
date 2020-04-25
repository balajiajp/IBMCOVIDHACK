//
//  RegistrationViewController.swift
//  SocialDistanceTracker
//
//  Created by Ayyalu  Jeyaprakash, Balaji (Cognizant) on 25/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import UIKit

enum UserType {
    case vendor
    case user
}

class RegistrationViewController: UIViewController {
    
    var isSafe : Bool = true
    var userType : UserType?
    var person : PersonModel = PersonModel()
    
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldMobile: UITextField!
    @IBOutlet weak var txtFieldAdhaar: UITextField!
    
    @IBOutlet weak var imgViewVendor: UIImageView!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var imgViewQRCode: UIImageView!
    
    @IBAction func toggleUserTypeSelection(_ sender: Any) {
        self.view.endEditing(true)
        let selectedButton : UIButton = sender as! UIButton
        switch selectedButton.tag {
        case 0:
            imgViewUser.isHighlighted = false
            imgViewVendor.isHighlighted = true
            userType = .vendor
        case 1:
            imgViewUser.isHighlighted = true
            imgViewVendor.isHighlighted = false
            userType = .user
        default:
            break
        }
    }
    
    @IBAction func onClickGenearateCode(_ sender: Any) {
        self.view.endEditing(true)
        validateAndGenerateCode()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"
        // Do any additional setup after loading the view.
    }


    func validateAndGenerateCode(){
        person.firstName = txtFieldFirstName.text
        person.lastName = txtFieldLastName.text
        person.userType = (userType == .vendor) ? "Vendor" : ((userType == .user) ? "User" : nil)
        person.mobileNumber = txtFieldMobile.text
        person.adhaarNumber = txtFieldAdhaar.text
        
        if person.validateUserInformation() {
            imgViewQRCode.backgroundColor = isSafe ? .green : .red
            isSafe = !isSafe
            let localDict = ["Name":"\(String(describing: person.firstName))","Mobile":"\(person.mobileNumber ?? "")","UserType":"\(String(describing: person.userType))"]
            guard let qrImage = QRCodeGenarator.generateQRCode(dictData: localDict) else {return}
            imgViewQRCode.image = qrImage
            self.showRegSuccessAlert()
        }else{
            showAlert()
            imgViewQRCode.backgroundColor = .clear
            imgViewQRCode.image = nil
        }
    }
    
    func moveToHome()
    {
        performSegue(withIdentifier: "HomeScreen", sender: self)
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Person Detail", message: "Please Enter all inforamtion", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    func showRegSuccessAlert(){
    let alertController  = UIAlertController(title: "Registration Successfull", message: "", preferredStyle: UIAlertController.Style.alert)
    
    let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
        alertController.dismiss(animated: false, completion: nil)
        self.moveToHome()
    }
    alertController.addAction(okAction)
    self.present(alertController, animated: false, completion: nil)
    }
    
}

