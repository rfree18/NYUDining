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
    
    private var didSetupConstraints = false
    
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
            weekdayLabel.autoAlignAxisToSuperviewMarginAxis(.Horizontal)
            weekdayLabel.autoPinEdgeToSuperviewMargin(.Leading)
            
            hoursLabel.lineBreakMode = .ByClipping
            hoursLabel.numberOfLines = 0
            hoursLabel.autoPinEdgeToSuperviewMargin(.Trailing)
            hoursLabel.autoAlignAxisToSuperviewMarginAxis(.Horizontal)
            hoursLabel.textColor = UIColor.grayColor()
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    

}
