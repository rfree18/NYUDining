//
//  RFLocationsViewController.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MBProgressHUD
import Crashlytics

class RFLocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var locationTable: UITableView!
    
    var diningLocations: [RFDiningLocation] = []
    var timer: Timer! = nil
    let hoursOptions: [String] = []
    let tableName: String = ""
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = navigationController {
            navigationController.navigationBar.isTranslucent = false
        }
        
        ref = FIRDatabase.database().reference()
        
        timer = Timer.scheduledTimer(timeInterval: 12.0, target: self, selector: #selector(showAlert), userInfo: nil, repeats: false)
        
        grabInformationFromServer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationTable.reloadData()
        
        if let indexPaths = locationTable.indexPathsForSelectedRows {
            for indexPath: IndexPath in indexPaths {
                locationTable.deselectRow(at: indexPath, animated: false)
            }
        }
    }
    
    func grabInformationFromServer() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ref.observe(FIRDataEventType.value, with: { (snapshot) in
            self.diningLocations.removeAll()
            self.timer.invalidate()
            
            let data = snapshot.value as! [String: AnyObject]
            
            let params = data["params"] as! [String: AnyObject]
            let locations = data["results"] as! [[String: AnyObject]]
            
            for locationData in locations {
                let location = RFDiningLocation(data: locationData, params: params)
                self.diningLocations.append(location)
            }
            
            self.diningLocations = self.diningLocations.sorted(by: { (a, b) -> Bool in
                let name1 = a.name
                let name2 = b.name
                return name1! < name2!
            })
            
            self.locationTable.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
            
            }) { (error) in
                print(error.localizedDescription)
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let retry = UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: { (action) in
                    self.viewDidLoad()
                })
                alert.addAction(retry)
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert() {
        MBProgressHUD.hide(for: self.view, animated: true)
        
        ref.removeAllObservers()
        
        let alert = UIAlertController(title: "Connection Error", message: "It looks like you're not connected to the internet 😢", preferredStyle: UIAlertControllerStyle.alert)
        let retry = UIAlertAction(title: "Retry", style: UIAlertActionStyle.default) { (action) in
            self.grabInformationFromServer()
        }
        alert.addAction(retry)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diningLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location")
        let location = diningLocations[(indexPath as NSIndexPath).row]
        
        cell?.textLabel?.text = location.name
        
        if location.isOpen() {
            cell?.detailTextLabel?.text = "Open"
            cell?.detailTextLabel?.textColor = UIColor(red: 0.133, green: 0.58, blue: 0.282, alpha: 1.0)
            
            cell?.textLabel?.textColor = cell?.detailTextLabel?.textColor
            
        }
        
        else {
            cell?.detailTextLabel?.text = "Closed"
            cell?.detailTextLabel?.textColor = UIColor.red
            
            cell?.textLabel?.textColor = cell?.detailTextLabel?.textColor
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let path = sender as! IndexPath
        
        let selectedLocation = diningLocations[(path as NSIndexPath).row]
        let dest = segue.destination as? RFLocationDetailViewController
        if let dest = dest {
            dest.location = selectedLocation
            Answers.logContentView(withName: "Dining Hall", contentType: "Location", contentId: selectedLocation.name, customAttributes: nil)
        }
    }
}
