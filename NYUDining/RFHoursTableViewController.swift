//
//  RFHoursTableViewController.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit

class RFHoursTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var diningLocation: RFDiningLocation!
    @IBOutlet weak var hoursTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hoursTable.estimatedRowHeight = 44.0
        hoursTable.rowHeight = UITableViewAutomaticDimension

        hoursTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let hours = diningLocation.hours {
            return hours.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("hours")
        
        if let cell = cell, hours = diningLocation.hours {
            let hours = hours[indexPath.row]
            
            var dayOfWeek: DayOfWeek
            
            switch indexPath.row {
            case 0:
                dayOfWeek = .Sunday
            case 1:
                dayOfWeek = .Monday
            case 2:
                dayOfWeek = .Tuesday
            case 3:
                dayOfWeek = .Wednesday
            case 4:
                dayOfWeek = .Thursday
            case 5:
                dayOfWeek = .Friday
            default:
                dayOfWeek = .Saturday
            }
            
            var hoursText = hours
            hoursText = hoursText.stringByReplacingOccurrencesOfString(",", withString: "\n")
            
            cell.textLabel?.text = dayOfWeek.rawValue
            cell.detailTextLabel?.text = hoursText
        }
        
        return cell!
        
    }

}
