//
//  LocationsViewController.h
//  NYUDining
//
//  Created by Ross Freeman on 9/8/15.
//  Copyright (c) 2015 Ross Freeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import <Firebase/Firebase.h>

#import "RFDiningLocation.h"

@interface RFLocationsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *locationTable;
@property (strong, nonatomic) NSMutableArray *diningLocations;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray *hoursOptions;
@property (strong, nonatomic) NSString *tableName;
@property (strong, nonatomic) Firebase *rootRef;

- (void)showAlert;
- (void)grabInformationFromServer;
- (void)grabLocationsFromServer;
- (IBAction)selectCal:(id)sender;

@end
