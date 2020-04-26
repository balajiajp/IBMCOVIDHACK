//
//  TutorialViewController.swift
//  SocialDistanceTracker
//
//  Created by NivasK on 26/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onButtonNextTap(_ sender: Any) {
        // perform action
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "registrationVC" {
            let regirationViewController = segue.destination as! RegistrationViewController
            regirationViewController.closeVC = {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
