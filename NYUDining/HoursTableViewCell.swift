//
//  HoursTableViewCell.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/30/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit
import PureLayout

class HoursTableViewCell: UITableViewCell {
    
    let weekdayLabel = UILabel()
    let hoursLabel = UILabel()
    
    fileprivate var didSetupConstraints = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(weekdayLabel)
        addSubview(hoursLabel)
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            weekdayLabel.autoAlignAxis(toSuperviewMarginAxis: .horizontal)
            weekdayLabel.autoPinEdge(toSuperviewMargin: .leading)

            hoursLabel.lineBreakMode = .byClipping
            hoursLabel.numberOfLines = 0
            hoursLabel.autoPinEdge(toSuperviewMargin: .trailing)
            hoursLabel.autoAlignAxis(toSuperviewMarginAxis: .horizontal)
            hoursLabel.textColor = UIColor.gray
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    

}
