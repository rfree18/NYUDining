//
//  HoursTableViewController.h
//  NYUDining
//
//  Created by Ross Freeman on 11/5/15.
//  Copyright © 2015 Ross Freeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFDiningLocation.h"

@interface RFHoursTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *hoursTable;
@property (strong, nonatomic) RFDiningLocation *diningLocation;

@end
