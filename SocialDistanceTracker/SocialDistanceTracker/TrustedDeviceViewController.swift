//
//  TrustedDeviceViewController.swift
//  SocialDistanceTracker
//
//  Created by Vivek John on 27/04/20.
//  Copyright © 2020 Ayyalu  Jeyaprakash, Balaji (Cognizant). All rights reserved.
//

import UIKit

class TrustedDeviceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableview: UITableView!
    var viewModel = TrustedDeviceViewModel()
    var person : PersonModel = PersonModel()
    var trustedDeviceData: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        tableview.dataSource = self
        tableview.delegate = self
        
        self.registerTableViewCells()
        self.loadTrustedDeviceData()
    }
    
    // load trusted device details from user defaults
    func loadTrustedDeviceData() {
        let loadedData: [[String: String]] = self.viewModel.fetchFromUserDefault()
        if loadedData.count != 0 {
            trustedDeviceData = loadedData
            tableview.reloadData()
        } else {
            tableview.isHidden = true
        }
    }
    
    // MARK: UITableView

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return trustedDeviceData.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TrustedDeviceTableViewCell") as? TrustedDeviceTableViewCell {
            let item = trustedDeviceData[indexPath.row]
            if let type: UserCodeType = UserCodeType(rawValue: item["UserType"] ?? UserCodeType.User.rawValue) {
                switch type {
                case UserCodeType.User:
                    cell.lblUserDetails.text = "U"
                    cell.lblUserDetails.backgroundColor = .black
                case UserCodeType.Vendor:
                    cell.lblUserDetails.text = "V"
                    cell.lblUserDetails.backgroundColor = .red
                }
            }
            if let first = item["FirstName"] {
                cell.lblName.text = first
            }
            if let number = item["MobileNumber"] {
                cell.lblNumber.text = number
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.tableview.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    // MARK: Button Actions

    // close current page
    @IBAction func clickActionClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

class TrustedDeviceTableViewCell: UITableViewCell {
    
    @IBOutlet var lblUserDetails: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
