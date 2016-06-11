//
//  RFLocationDetailViewController.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit

class RFLocationDetailViewController: UIViewController {
    
    var location: RFDiningLocation!
    
    @IBOutlet weak var locationLogo: UIImageView!
    @IBOutlet weak var locationStatusLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = location.name
        
        dispatch_async(dispatch_get_main_queue()) {
            let url = NSURL(string: self.location.logoURL!)
            let data = NSData(contentsOfURL: url!)
            
            // TODO: Implement error checking
            self.locationLogo.image = UIImage(data: data!)
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
        
        // TODO: Implement GMaps
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
        let dayOfWeek: DayOfWeek = DayOfWeek(rawValue: dateFormatter.stringFromDate(NSDate()))!
        
        if let hours = location.hours {
            switch dayOfWeek {
            case .Sunday:
                if let today = hours[0] {
                    hoursToday = today
                }
            case .Monday:
                if let today = hours[01] {
                    hoursToday = today
                }
            case .Tuesday:
                if let today = hours[2] {
                    hoursToday = today
                }
            case .Wednesday:
                if let today = hours[3] {
                    hoursToday = today
                }
            case .Thursday:
                if let today = hours[4] {
                    hoursToday = today
                }
            case .Friday:
                if let today = hours[5] {
                    hoursToday = today
                }
            default:
                if let today = hours[6] {
                    hoursToday = today
                }
            
            }
            hoursString = hoursToday.stringByReplacingOccurrencesOfString(",", withString: "\n")
        }
        
            
        return hoursString
        
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
