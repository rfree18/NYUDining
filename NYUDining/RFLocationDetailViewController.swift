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
            let url = NSURL(string: self.location.logoURL)
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
        var hoursString: String
        var todaysHours: String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeek: DayOfWeek = DayOfWeek(rawValue: dateFormatter.stringFromDate(NSDate()))!
        
        switch dayOfWeek {
        case .Sunday:
            todaysHours = location.hours[0]
        case .Monday:
            todaysHours = location.hours[1]
        case .Tuesday:
            todaysHours = location.hours[2]
        case .Wednesday:
            todaysHours = location.hours[3]
        case .Thursday:
            todaysHours = location.hours[4]
        case .Friday:
            todaysHours = location.hours[5]
        default:
            todaysHours = location.hours[6]
        }
            
        hoursString = todaysHours.stringByReplacingOccurrencesOfString(",", withString: "\n")
            
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
