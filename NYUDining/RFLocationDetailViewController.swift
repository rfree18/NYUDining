//
//  RFLocationDetailViewController.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import PureLayout

class RFLocationDetailViewController: UIViewController {
    
    var location: RFDiningLocation!
    
    private let logoImageView = UIImageView()
    private let locationStatusLabel = UILabel()
    private let headerLabel = UILabel()
    private let hoursLabel = UILabel()
    private let menuButton = UIButton()
    private let checkInsTable = UITableView()
    private let checkInButton = UIBarButtonItem()
    
    var peopleCheckedIn:[[String:AnyObject]]!
    
    private var needsToSetConstraints = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()

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
            self.logoImageView.image = UIImage(data: data!)
            
            MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: true)
            
        }
        
        headerLabel.lineBreakMode = .ByClipping
        headerLabel.numberOfLines = 0
        headerLabel.text = "Today's Hours"
        
        hoursLabel.preferredMaxLayoutWidth = 200
        hoursLabel.text = getHoursString()
        hoursLabel.lineBreakMode = .ByClipping
        hoursLabel.numberOfLines = 0
        
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
        
        checkInButton.style = .Plain
        checkInButton.title = "CheckIn"
        checkInButton.target = self
        checkInButton.action = #selector(RFLocationDetailViewController.checkin)
        navigationItem.rightBarButtonItem = checkInButton
        
        menuButton.backgroundColor = UIColor.navColor()
        menuButton.setTitle("Menu", forState: .Normal)
        menuButton.addTarget(self, action: #selector(RFLocationDetailViewController.goToMenu), forControlEvents: .TouchUpInside)
        
        view.addSubview(locationStatusLabel)
        view.addSubview(logoImageView)
        view.addSubview(headerLabel)
        view.addSubview(hoursLabel)
        view.addSubview(menuButton)
        view.addSubview(checkInsTable)
        
        view.setNeedsUpdateConstraints()
        
    }

    override func updateViewConstraints() {
        if needsToSetConstraints {
            logoImageView.autoPinEdgeToSuperviewEdge(.Leading, withInset: 4)
            logoImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 8)
            logoImageView.autoPinEdge(.Right, toEdge: .Left, ofView: locationStatusLabel, withOffset: -5)
            logoImageView.autoSetDimension(.Height, toSize: 135)
            logoImageView.autoSetDimension(.Width, toSize: 186)
            
            locationStatusLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 9)
            locationStatusLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 17)
            locationStatusLabel.textAlignment = .Center
            
            headerLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: locationStatusLabel, withOffset: 8)
            headerLabel.autoPinEdge(.Left, toEdge: .Right, ofView: logoImageView, withOffset: 5)
            headerLabel.autoPinEdgeToSuperviewMargin(.Right)
            headerLabel.textAlignment = .Center
            
            hoursLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: headerLabel, withOffset: 8)
            hoursLabel.autoPinEdge(.Left, toEdge: .Right, ofView: logoImageView, withOffset: 5)
            hoursLabel.autoPinEdgeToSuperviewMargin(.Right)
            hoursLabel.textAlignment = .Center
            
            menuButton.autoPinEdgeToSuperviewMargin(.Right)
            menuButton.autoPinEdge(.Left, toEdge: .Right, ofView: logoImageView, withOffset: 5)
            menuButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: hoursLabel, withOffset: 8)
            
            checkInsTable.autoPinEdgeToSuperviewEdge(.Left)
            checkInsTable.autoPinEdgeToSuperviewEdge(.Right)
            checkInsTable.autoPinEdgeToSuperviewEdge(.Bottom)
            checkInsTable.autoPinEdge(.Top, toEdge: .Bottom, ofView: menuButton, withOffset: 8)
            
            needsToSetConstraints = false
        }
        
        super.updateViewConstraints()
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
    
    func checkin() {
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
    
   
    // MARK: Navigation
    
    func goToMenu() {
        let menuController = RFMenuBrowserViewController()
        menuController.location = location
        
        navigationController?.pushViewController(menuController, animated: true)
    }
    
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

extension RFLocationDetailViewController: UITableViewDataSource {
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
}
