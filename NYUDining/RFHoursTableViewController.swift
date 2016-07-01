//
//  RFHoursTableViewController.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit
import PureLayout

class RFHoursTableViewController: UIViewController {
    
    var diningLocation: RFDiningLocation!
    private let hoursTable = UITableView()
    
    private let cellId = "hours"
    private var didSetConstraints = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hoursTable.registerClass(HoursTableViewCell.self, forCellReuseIdentifier: cellId)
        hoursTable.dataSource = self
        
        view.addSubview(hoursTable)

        view.setNeedsUpdateConstraints()
        hoursTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateViewConstraints() {
        if !didSetConstraints {
            hoursTable.autoPinEdgesToSuperviewEdges()
        }
        
        super.updateViewConstraints()
    }

}

extension RFHoursTableViewController: UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! HoursTableViewCell
        
        var hours = diningLocation.hours[indexPath.row]
        
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
        
        cell.weekdayLabel.text = dayOfWeek.rawValue
        
        hours = hours.stringByReplacingOccurrencesOfString(",", withString: "\n")
        cell.hoursLabel.text = hours
        
        
        return cell
        
    }
}
