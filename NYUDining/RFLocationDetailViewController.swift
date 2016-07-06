//
//  RFLocationDetailViewController.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit
import GoogleMaps
import MBProgressHUD
import Alamofire

class RFLocationDetailViewController: UIViewController {
    
    var location: RFDiningLocation!
    
    @IBOutlet weak var locationLogo: UIImageView!
    @IBOutlet weak var locationStatusLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var checkInsTable: UITableView!
    
    var peopleCheckedIn:[[String:AnyObject]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = location.name
        let theLoc = location.name
        let newString = theLoc.stringByReplacingOccurrencesOfString(" ", withString: "")
        Alamofire.request(.GET, "http://172.17.50.254:8080/EatWithSmartService/webapi/checkIn?diningHallName=\(newString)", encoding: .JSON)
            .validate()
            .responseJSON { response in
                debugPrint(response)     // prints detailed description of all response properties
                
                if let JSON = response.result.value {
                    print(JSON)
                    if (response.result.value is NSNull){}
                    else
                    { self.peopleCheckedIn = JSON as! [Dictionary<String,AnyObject>]}
                }
        }
        
        
        
        MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        
        dispatch_async(dispatch_get_main_queue()) {
            let url = NSURL(string: self.location.logoURL!)
            let data = NSData(contentsOfURL: url!)
            
            // TODO: Implement error checking
            self.locationLogo.image = UIImage(data: data!)
            
            MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: true)
            
        }
        
        hoursLabel.preferredMaxLayoutWidth = 200
        hoursLabel.text = getHoursString()
        
        if location.menuURL == nil {
            menuButton.hidden = true
        }
        
        if location.isOpen() {
            locationStatusLabel.text = "Open"
            locationStatusLabel.textColor = UIColor(red: 0.133, green: 0.580, blue: 0.282, alpha: 1.0)
        }
        
        else {
            locationStatusLabel.text = "Closed"
            locationStatusLabel.textColor = UIColor.redColor()
        }
        
        //let x = location.coordinates[0]
        //let y = location.coordinates[1]
        
        //let camera = GMSCameraPosition.cameraWithLatitude(x, longitude: y, zoom: 16)
        
        //mapView.frame = CGRectZero
        //mapView.camera = camera
        
       // let marker = GMSMarker(position: CLLocationCoordinate2DMake(x, y))
       // marker.title = location.name!
       // marker.snippet = location.address!
        //marker.map = mapView
        
        //mapView.selectedMarker = marker
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHoursString() -> String {
        var hoursString = ""
        var hoursToday = ""
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeek = DayOfWeek(rawValue: dateFormatter.stringFromDate(NSDate()))
        
        if let dayOfWeek = dayOfWeek {
            switch dayOfWeek {
            case .Sunday:
                hoursToday = location.hours[0]
            case .Monday:
                hoursToday = location.hours[1]
            case .Tuesday:
                hoursToday = location.hours[2]
            case .Wednesday:
                hoursToday = location.hours[3]
            case .Thursday:
                hoursToday = location.hours[4]
            case .Friday:
                hoursToday = location.hours[5]
            default:
                hoursToday = location.hours[6]
            }
            hoursString = hoursToday.stringByReplacingOccurrencesOfString(",", withString: "\n")
        }
        
        
        return hoursString
        
    }
    @IBOutlet var checkinButton: UIButton!
    
    
    @IBAction func checkin(sender: AnyObject) {
        if checkinButton.currentTitle == "Check In" {
            let now = NSDate()
            
            let dateFormatter = NSDateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let convertedDate = dateFormatter.stringFromDate(now)
            print(convertedDate)
            let date = now.dateByAddingTimeInterval(30.0 * 60.0)
            let convertDate = dateFormatter.stringFromDate(date)
            print(convertDate)
            
            let defaults = NSUserDefaults()
            let FbId = defaults.stringForKey("FbUserId")
            
            let theLoc = location.name
            let newString = theLoc.stringByReplacingOccurrencesOfString(" ", withString: "")
            let parameters2: [String : AnyObject] = [
                "fbUserId": FbId!,
                "diningHallName": newString,
                "checkInDateTime":"\(convertedDate)",
                "checkOutDateTime":"\(convertDate)"]
            Alamofire.request(.POST, "http://172.17.50.254:8080/EatWithSmartService/webapi/checkIn", parameters: parameters2, encoding: .JSON)
                .validate()
                .responseString{ response in
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result.value)")
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(peopleCheckedIn)")
        return 5 //change to number of people in location
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = "test"
        
        return cell
    }
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMenu" {
            let dest = segue.destinationViewController as! RFMenuBrowserViewController
            dest.location = location
        }
        
        else {
            let dest = segue.destinationViewController as! RFHoursTableViewController
            dest.diningLocation = location
        }
    }
    
}
