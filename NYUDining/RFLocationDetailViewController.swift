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

class RFLocationDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var location: RFDiningLocation!
    private var checkInTimePicker = UIPickerView()
    private let logoImageView = UIImageView()
    private let locationStatusLabel = UILabel()
    private let headerLabel = UILabel()
    private let hoursLabel = UILabel()
    //private let menuButton = UIButton(type: .System)
    private let menuButton = UIBarButtonItem()
    private let checkInsTable = UITableView()
    //private let checkInButton = UIBarButtonItem()
    private let checkInButton = UIButton(type: .System)
    private let submitButton = UIButton(type: .System)
    private var didPressCheckin:Bool = false
    private let pickOption: [String] = ["Now", "15 Minutes", "30 Minutes"]
    var timeSelected = ""
    
    var peopleCheckedIn:[[String:AnyObject]]!
    
    private var needsToSetConstraints = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkInsTable.delegate = self
        self.checkInsTable.dataSource = self
        self.checkInTimePicker.dataSource = self
        self.checkInTimePicker.delegate = self
        self.checkInTimePicker.hidden = true
        self.checkInTimePicker.backgroundColor = UIColor.clearColor()
        self.submitButton.hidden = true
        view.backgroundColor = UIColor.whiteColor()

        navigationItem.title = location.name
        updateTable()
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
            
            //menuButton.hidden = true
            //hide menu from bar
        }
        
        if location.isOpen() {
            locationStatusLabel.text = "Open"
            locationStatusLabel.textColor = UIColor(red: 0.133, green: 0.580, blue: 0.282, alpha: 1.0)
        }
        
        else {
            locationStatusLabel.text = "Closed"
            locationStatusLabel.textColor = UIColor.redColor()
        }
        
        //checkInButton.style = .Plain
        //checkInButton.title = "CheckIn"
        //checkInButton.target = self
        //checkInButton.action = #selector(RFLocationDetailViewController.checkin)
        //navigationItem.rightBarButtonItem = checkInButton
        menuButton.style = .Plain
        menuButton.title = "Menu"
        menuButton.target = self
        menuButton.action = #selector(RFLocationDetailViewController.goToMenu)
        navigationItem.rightBarButtonItem = menuButton
        
        
        // TODO: Subclass UIButton to automate this setup
        //menuButton.backgroundColor = UIColor.navColor()
        //menuButton.setTitle("Menu", forState: .Normal)
        //menuButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        //menuButton.addTarget(self, action: #selector(RFLocationDetailViewController.goToMenu), forControlEvents: .TouchUpInside)
        //menuButton.layer.cornerRadius = 5
        checkInButton.backgroundColor = UIColor.clearColor()
        checkInButton.setImage(UIImage(named: "CheckinButton"), forState: .Normal)
        checkInButton.addTarget(self, action: #selector(RFLocationDetailViewController.checkin), forControlEvents: .TouchUpInside)
        //checkInButton.layer.cornerRadius = 5
        
        submitButton.backgroundColor = UIColor.clearColor()
        submitButton.setTitle("Submit", forState: .Normal)
        submitButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        submitButton.addTarget(self, action: #selector(RFLocationDetailViewController.submit), forControlEvents: .TouchUpInside)
        
        view.addSubview(locationStatusLabel)
        view.addSubview(logoImageView)
        view.addSubview(headerLabel)
        view.addSubview(hoursLabel)
        //view.addSubview(menuButton)
        view.addSubview(checkInButton)
        view.addSubview(checkInsTable)
        view.addSubview(checkInTimePicker)
        view.addSubview(submitButton)
        view.setNeedsUpdateConstraints()
        
    }
    
    func submit(){
        var inTime = NSDate()
        
        if (timeSelected == "15 Minutes")
        {
            inTime = inTime.dateByAddingTimeInterval(15.0 * 60.0)
        }
        else if (timeSelected == "30 Minutes")
        {
            inTime = inTime.dateByAddingTimeInterval(30.0 * 60.0)
        }
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let convertedDate = dateFormatter.stringFromDate(inTime)
        print(convertedDate)
        
        let outTime = inTime.dateByAddingTimeInterval(30.0 * 60.0)
        let convertDate = dateFormatter.stringFromDate(outTime)
        print(convertDate)
        
        let defaults = NSUserDefaults()
        let FbId = defaults.stringForKey("fbUserId")
        
        let theLoc = location.name
        let newString = theLoc.stringByReplacingOccurrencesOfString(" ", withString: "")
        print (newString)
        print("this is from checkIn")
        let parameters2: [String : AnyObject] = [
            "fbUserId": FbId!,
            "diningHallName": newString,
            "checkInDateTime":"\(convertedDate)",
            "checkOutDateTime":"\(convertDate)"]
        Alamofire.request(.POST, "http://eatwith.umxb9zewhm.us-east-1.elasticbeanstalk.com/webapi/checkIn", parameters: parameters2, encoding: .JSON)
            .validate()
            .responseString{ response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)")
        }
        checkInTimePicker.hidden = true
        submitButton.hidden = true
        checkInsTable.hidden = false
        updateTable()
        view.setNeedsUpdateConstraints()
        
    }
    func updateTable()
    {
        let theLoc = location.name
        let newString = theLoc.stringByReplacingOccurrencesOfString(" ", withString: "")
        print(newString)
        print("this is from updateTable")
        
        Alamofire.request(.GET, "http://eatwith.umxb9zewhm.us-east-1.elasticbeanstalk.com/webapi/checkIn?diningHallName=\(newString)", encoding: .JSON)
            .validate()
            .responseJSON { response in
                debugPrint(response)     // prints detailed description of all response properties
                
                if let JSON = response.result.value {
                    print("Printing the JSON HEREEEE")
                    print(JSON)
                    print("UPTO HEREEE")
                    if (response.result.value is NSNull){}
                    else
                    { self.peopleCheckedIn = JSON as! [Dictionary<String,AnyObject>]}
                }
        }

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
            
            //menuButton.autoPinEdgeToSuperviewMargin(.Right)
            //menuButton.autoPinEdge(.Left, toEdge: .Right, ofView: logoImageView, withOffset: 5)
            //menuButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: hoursLabel, withOffset: 8)
            
            checkInButton.autoSetDimension(.Width, toSize: 80)
            checkInButton.autoSetDimension(.Height, toSize:30)
            checkInButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: logoImageView, withOffset: 8)
            checkInButton.autoAlignAxisToSuperviewAxis(.Vertical)
            
            checkInsTable.autoPinEdgeToSuperviewEdge(.Left)
            checkInsTable.autoPinEdgeToSuperviewEdge(.Right)
            checkInsTable.autoPinEdgeToSuperviewEdge(.Bottom)
            //checkInsTable.autoPinEdge(.Top, toEdge: .Bottom, ofView: menuButton, withOffset: 8)
            checkInsTable.autoPinEdge(.Top, toEdge: .Bottom, ofView: checkInButton, withOffset: 8)
            
            submitButton.autoPinEdgeToSuperviewEdge(.Right)
            submitButton.autoPinEdgeToSuperviewEdge(.Bottom)

            checkInTimePicker.autoPinEdgeToSuperviewEdge(.Left)
            checkInTimePicker.autoPinEdgeToSuperviewEdge(.Right)
            checkInTimePicker.autoPinEdge(.Bottom, toEdge: .Top, ofView: submitButton, withOffset: 8)
            checkInTimePicker.autoPinEdge(.Top, toEdge: .Bottom, ofView: checkInButton, withOffset: 8)

            
            needsToSetConstraints = false
        }
        
        super.updateViewConstraints()
    }
    // pickerView funcs 
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeSelected = pickOption[row]
        

    }
    
    //pickerView funcs
    
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
        if User.isSignedIn() {
            checkInsTable.hidden = true
            submitButton.hidden = false
            checkInTimePicker.hidden = false
            
        } else {
            let pController = ProfileViewController()
            navigationController?.pushViewController(pController, animated: true)
            /*
            let alert = UIAlertController(title: "Not Signed In", message: "You must be signed in to use this feature", preferredStyle: .Alert)
            let signIn = UIAlertAction(title: "Sign In", style: .Default, handler: { action in
                self.tabBarController?.selectedIndex = Tab.Profile.rawValue
            })
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(signIn)
            alert.addAction(cancel)
            
            presentViewController(alert, animated: true, completion: nil)
            */
        }
    }
    
    // MARK: Navigation
    
    func goToMenu() {
        let menuController = RFMenuBrowserViewController()
        menuController.location = location
        
        navigationController?.pushViewController(menuController, animated: true)
    }
    
}

extension RFLocationDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(peopleCheckedIn)")
        print("Above are the people checked in")
        if (peopleCheckedIn == nil || peopleCheckedIn.isEmpty)
        {
            print("No one is checked in")
            return 1
        }
        return peopleCheckedIn.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        let row = indexPath.row
        if (peopleCheckedIn == nil || peopleCheckedIn.isEmpty){
            cell.textLabel?.text = "No one has checked in"
            cell.detailTextLabel?.text = "Be the first to check in"
        }
        else{
            let aPersonAt = peopleCheckedIn[row]
            cell.textLabel?.text = (aPersonAt["fbUserName"] as! String)
            cell.detailTextLabel?.text = (aPersonAt["bfUserId"] as! String)
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let personProfile = OtherProfileViewController()
        let row = indexPath.row
       
        if (peopleCheckedIn == nil || peopleCheckedIn.isEmpty ) {
            didPressCheckin = true
            didSelectCheckin()
        }
        else {
            
            personProfile.personInfo = peopleCheckedIn[row]
            personProfile.isRequestPage = true
            personProfile.location = location.name
            navigationController?.pushViewController(personProfile, animated: true)
        }
    }
    func didSelectCheckin()
    {
        if didPressCheckin{
            checkin()
        }
    }
}
