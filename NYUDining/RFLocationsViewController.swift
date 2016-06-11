//
//  RFLocationsViewController.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase


class RFLocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var locationTable: UITableView!
    
    var diningLocations: [RFDiningLocation] = []
    var timer: NSTimer! = nil
    let hoursOptions: [String] = []
    let tableName: String = ""
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = navigationController {
            navigationController.navigationBar.translucent = false
        }
        
        ref = FIRDatabase.database().reference()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(12.0, target: self, selector: #selector(showAlert), userInfo: nil, repeats: false)
        
        grabInformationFromServer()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        locationTable.reloadData()
        
        for indexPath: NSIndexPath in locationTable.indexPathsForSelectedRows! {
            locationTable.deselectRowAtIndexPath(indexPath, animated: false)
        }
    }
    
    func grabInformationFromServer() {
        ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            self.diningLocations.removeAll()
            self.timer.invalidate()
            
            let data = snapshot.value as! [String: AnyObject]
            
            let params = data["params"] as! [String: AnyObject]
            let locations = data["results"] as! [[String: AnyObject]]
            
            for locationData in locations {
                let location = RFDiningLocation(data: locationData, params: params)
                self.diningLocations.append(location)
            }
            
            self.diningLocations = self.diningLocations.sort({ (a, b) -> Bool in
                let name1 = a.name
                let name2 = b.name
                return name1 > name2
            })
            
            self.locationTable.reloadData()
            
        })
        
        ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            self.diningLocations.removeAll()
            self.timer.invalidate()
            
            let data = snapshot.value as! [String: AnyObject]
            
            let params = data["params"] as! [String: AnyObject]
            let locations = data["results"] as! [[String: AnyObject]]
            
            for locationData in locations {
                let location = RFDiningLocation(data: locationData, params: params)
                self.diningLocations.append(location)
            }
            
            self.diningLocations = self.diningLocations.sort({ (a, b) -> Bool in
                let name1 = a.name
                let name2 = b.name
                return name1 > name2
            })
            
            self.locationTable.reloadData()
            }) { (error) in
                print(error.description)
                
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let retry = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { (action) in
                    self.viewDidLoad()
                })
                alert.addAction(retry)
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert() {
        ref.removeAllObservers()
        
        let alert = UIAlertController(title: "Connection Error", message: "It looks like you're not connected to the internet 😢", preferredStyle: UIAlertControllerStyle.Alert)
        let retry = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) { (action) in
            self.grabInformationFromServer()
        }
        alert.addAction(retry)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diningLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("location")
        let location = diningLocations[indexPath.row]
        
        cell?.textLabel?.text = location.name
        
        if location.isOpen() {
            cell?.detailTextLabel?.text = "Open"
            cell?.detailTextLabel?.textColor = UIColor(red: 0.133, green: 0.58, blue: 0.282, alpha: 1.0)
            
            cell?.textLabel?.textColor = cell?.detailTextLabel?.textColor
            
        }
        
        else {
            cell?.detailTextLabel?.text = "Closed"
            cell?.detailTextLabel?.textColor = UIColor .redColor()
            
            cell?.textLabel?.textColor = cell?.detailTextLabel?.textColor
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetails", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path = sender as! NSIndexPath
        
        let selectedLocation = diningLocations[path.row]
        let dest = segue.destinationViewController as! RFLocationDetailViewController
        dest.location = selectedLocation
    }
}