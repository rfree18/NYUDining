//
//  HoursTableViewController.h
//  NYUDining
//
//  Created by Ross Freeman on 11/5/15.
//  Copyright © 2015 Ross Freeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiningLocation.h"

@interface HoursTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *hoursTable;
@property (strong, nonatomic) DiningLocation *diningLocation;

@end
