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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsView.isHidden = true
        // Do any additional setup after loading the view.
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

