//
//  RegistrationViewController.swift
//  SocialDistanceTracker
//
//  Created by Ayyalu  Jeyaprakash, Balaji (Cognizant) on 25/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth


enum UserType {
    case vendor
    case user
}

class RegistrationViewController: UIViewController, CLLocationManagerDelegate {
    var closeVC : (() -> Void)?
    var isSafe : Bool = true
    var userType : UserType?
    var person : PersonModel = PersonModel()
    let locationManager = CLLocationManager()
    var peripheralManager = CBPeripheralManager()


    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldMobile: UITextField!
    @IBOutlet weak var txtFieldAdhaar: UITextField!
    
    @IBOutlet weak var imgViewVendor: UIImageView!
    @IBOutlet weak var imgViewUser: UIImageView!
    
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
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }


    func requestBluetoothPermission() {
        let showPermissionAlert = 1
        let options = [CBCentralManagerOptionShowPowerAlertKey: showPermissionAlert]
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
    }
    
    func validateAndGenerateCode(){
        person.firstName = txtFieldFirstName.text
        person.lastName = txtFieldLastName.text
        person.userType = (userType == .vendor) ? "Vendor" : ((userType == .user) ? "User" : nil)
        person.mobileNumber = txtFieldMobile.text
        person.adhaarNumber = txtFieldAdhaar.text
        
        if person.validateUserInformation() {
            isSafe = !isSafe
            let localDict = ["FirstName":"\(String(describing: person.firstName))","MobileNumber":"\(person.mobileNumber ?? "")","UserType":"\(String(describing: person.userType))"]
            guard let qrImage = QRCodeGenarator.generateQRCode(dictData: localDict) else {return}
            
            (UIApplication.shared.delegate as! AppDelegate).userQRCode = qrImage
            self.showRegSuccessAlert()
        }else{
            showAlert()
        }
    }
    
    func moveToHome()
    {
        (UIApplication.shared.delegate as! AppDelegate).userIsRegistered = true
        self.dismiss(animated: true)
        self.closeVC!()
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

extension RegistrationViewController {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            requestBluetoothPermission()

         /*   if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    requestBluetoothPermission()
                }
            }*/
        }
        
        if status == .authorizedWhenInUse {
            requestBluetoothPermission()
           /* if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                      requestBluetoothPermission()
                }
            }*/
        }
    }
}

extension RegistrationViewController : CBCentralManagerDelegate, CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
            switch peripheral.state {
          case .unknown:
            print("peripheral.state is .unknown")
          case .resetting:
            print("peripheral.state is .resetting")
          case .unsupported:
            print("peripheral.state is .unsupported")
          case .unauthorized:
            print("peripheral.state is .unauthorized")
          case .poweredOff:
            print("peripheral.state is .poweredOff")
          case .poweredOn:
            print("peripheral.state is .poweredOn")
        @unknown default:
            print("peripheral.state is .poweredOn")
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
        @unknown default:
            print("central.state is .poweredOn")
        }
    }
}
