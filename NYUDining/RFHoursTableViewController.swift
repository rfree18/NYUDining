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
    fileprivate let hoursTable = UITableView()
    
    fileprivate let cellId = "hours"
    fileprivate var didSetConstraints = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hoursTable.register(HoursTableViewCell.self, forCellReuseIdentifier: cellId)
        hoursTable.dataSource = self
        hoursTable.isUserInteractionEnabled = false
        
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let hours = diningLocation.hours {
            return hours.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HoursTableViewCell
        
        var hours = diningLocation.hours[(indexPath as NSIndexPath).row]
        
        var dayOfWeek: DayOfWeek
        
        switch (indexPath as NSIndexPath).row {
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
        
        hours = hours.replacingOccurrences(of: ",", with: "\n")
        cell.hoursLabel.text = hours
        
        
        return cell
        
    }
}
