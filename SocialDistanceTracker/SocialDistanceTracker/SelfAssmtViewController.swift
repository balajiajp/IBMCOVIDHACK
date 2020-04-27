//
//  SelfAssmtViewController.swift
//  SocialDistanceTracker
//
//  Created by Ayyalu  Jeyaprakash, Balaji (Cognizant) on 23/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import UIKit
import ResearchKit

class SelfAssmtViewController: UIViewController, ORKTaskViewControllerDelegate {

    
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var qrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        resultsView.isHidden = true
        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (!appDelegate.userIsRegistered) {
            self.performSegue(withIdentifier: "Registration", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.qrImageView.image = (UIApplication.shared.delegate as! AppDelegate).userQRCode
        self.qrImageView.backgroundColor = UIColor.black
    }
    
    @IBAction func selfAssmtActionHandler(_ button: UIButton) {
        let taskViewController = ORKTaskViewController(task: CovidQuestTask, taskRun: NSUUID() as UUID)
        taskViewController.delegate = self
        taskViewController.showsProgressInNavigationBar = true
        self.present(taskViewController, animated: true, completion: nil)
    }
    
    @IBAction func closeResultActionHandler(_ button: UIButton) {
        resultsView.isHidden = true
    }
    
    @IBAction func clickActionScan(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Scanner", bundle:nil)
        guard let ScannerVC = storyBoard.instantiateViewController(withIdentifier: "ScannerViewController") as? ScannerViewController else {
            return
        }
        self.present(ScannerVC, animated:true, completion:nil)
    }
    
    //MARK: - ResearchKit Task Controller Delegates
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        switch reason {
        case .completed:
            taskViewController.dismiss(animated: true, completion: {
                self.resultsView.isHidden = false
            })
            break
        case .discarded:
            taskViewController.dismiss(animated: true, completion: nil)
            break
        case .failed:
            taskViewController.dismiss(animated: true, completion: nil)
            break
        case .saved:
            taskViewController.dismiss(animated: true, completion: nil)
        break
        default: fatalError("Handle other reasons properly please!")
        }
    }
    
}

