//
//  HealthKitViewController.swift
//  SocialDistanceTracker
//
//  Created by Ayyalu  Jeyaprakash, Balaji (Cognizant) on 25/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import UIKit
import HealthKit

class HealthKitViewController: UIViewController {

    let HealthKitStore:HKHealthStore = HKHealthStore()
    @IBOutlet weak var heartRatelabel: UILabel!
    @IBOutlet weak var respRatelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authorizeHealthKit { (success, error) in
            if((error) != nil)
           {
                let alertController  = UIAlertController(title: "Health Data Not Available", message: "", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                    alertController.dismiss(animated: false, completion: nil)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: false, completion: nil)
            }
        }
        
        self.fetchLatestHeartRateSample { (results) in
            print(results!)
            let heartRateUnit:HKUnit = HKUnit(from: "count/min")
            if results!.count > 0 {
            let currData:HKQuantitySample = results![0]
            print("Heart Rate: \(currData.quantity.doubleValue(for: heartRateUnit))")
             DispatchQueue.main.async {
                let bpm = String.init(describing: currData.quantity.doubleValue(for: heartRateUnit))
                 self.heartRatelabel.text = bpm + " bpm"
                }
            }
            else
            {
                DispatchQueue.main.async {
               let alertController  = UIAlertController(title: "Heart Rate Not Available", message: "Please Wear your iWatch to capture HeartRate", preferredStyle: UIAlertController.Style.alert)
               
               let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                   alertController.dismiss(animated: false, completion: nil)
               }
               alertController.addAction(okAction)
               self.present(alertController, animated: false, completion: nil)
                }
            }
        }
        
        self.fetchRespRateSample { (results) in
            print(results!)
            let heartRateUnit:HKUnit = HKUnit(from: "count/min")
            if results!.count > 0 {
            let currData:HKQuantitySample = results![0]
            print("Resp Rate: \(currData.quantity.doubleValue(for: heartRateUnit))")
             DispatchQueue.main.async {
                let bpm = String.init(describing:
                    currData.quantity.doubleValue(for: heartRateUnit))
                 self.respRatelabel.text = bpm + " breaths/Minute"
                }
            }
            else
            {
                DispatchQueue.main.async {
               let alertController  = UIAlertController(title: "Repiratory Rate Not Available", message: "", preferredStyle: UIAlertController.Style.alert)
               
               let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                   alertController.dismiss(animated: false, completion: nil)
               }
               alertController.addAction(okAction)
               self.present(alertController, animated: false, completion: nil)
                }
            }
        }
        
        

        // Do any additional setup after loading the view.
    }
    
    func authorizeHealthKit(_ completion: ((_ success: Bool, _ error:NSError?)->Void)!){
        
        let typesreadandwrite = Set([HKObjectType.workoutType(),
                                       HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                       HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                                       HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                       HKObjectType.quantityType(forIdentifier: .heartRate)!,
                                       HKObjectType.quantityType(forIdentifier: .stepCount)!,
                                       HKObjectType.quantityType(forIdentifier: .height)!,
                                       HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                                       HKObjectType.quantityType(forIdentifier: .respiratoryRate)!
                                       ])
    

        //check if store is not available
        if !HKHealthStore.isHealthDataAvailable()
        {
            let error = NSError(domain: "COVID-19 HealthKit",
                                code: 1111,
                                userInfo: [NSLocalizedDescriptionKey: "HK Store Not Available"]
            )
            if(completion != nil){
                completion(false, error)
            }
            return
        }
        
        HealthKitStore.requestAuthorization(toShare: typesreadandwrite, read:typesreadandwrite){(success,error) -> Void in
            if(completion != nil){
                if(error != nil){
                    completion(false,error! as NSError)
                }else{
                    completion(success,nil)
                }
            }
        }
    }
    
    func fetchLatestHeartRateSample(
        completion: @escaping (_ samples: [HKQuantitySample]?) -> Void) {
        
        /// Create sample type for the heart rate
        guard let sampleType = HKObjectType
            .quantityType(forIdentifier: .heartRate) else {
                completion(nil)
                return
        }
        
        /// Predicate for specifiying start and end dates for the query
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                    end: Date(),
                                                    options: .strictEndDate)
        
        /// Set sorting by date.
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        
        /// Create the query
        let query = HKSampleQuery(sampleType: sampleType,predicate: predicate,limit: Int(HKObjectQueryNoLimit),sortDescriptors: [sortDescriptor]) { (_, results, error) in
                guard error == nil else {
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                completion(results as? [HKQuantitySample])
        }
        
        /// Execute the query in the health store
        self.HealthKitStore.execute(query)
    }
    
    
    func fetchRespRateSample(
        completion: @escaping (_ samples: [HKQuantitySample]?) -> Void) {
        
        /// Create sample type for the heart rate
        guard let sampleType = HKObjectType
            .quantityType(forIdentifier: .respiratoryRate) else {
                completion(nil)
                return
        }
        
        /// Predicate for specifiying start and end dates for the query
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                    end: Date(),
                                                    options: .strictEndDate)
        
        /// Set sorting by date.
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        
        /// Create the query
        let query = HKSampleQuery(sampleType: sampleType,predicate: predicate,limit: Int(HKObjectQueryNoLimit),sortDescriptors: [sortDescriptor]) { (_, results, error) in
                guard error == nil else {
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                completion(results as? [HKQuantitySample])
        }
        
        /// Execute the query in the health store
        self.HealthKitStore.execute(query)
    }
    
    @IBAction func clickActionClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
