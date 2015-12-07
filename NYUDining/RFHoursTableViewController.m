//
//  HoursTableViewController.m
//  NYUDining
//
//  Created by Ross Freeman on 11/5/15.
//  Copyright © 2015 Ross Freeman. All rights reserved.
//

#import "RFHoursTableViewController.h"

@interface RFHoursTableViewController ()

@end

@implementation RFHoursTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_hoursTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hours"];
    
    int index = (int)indexPath.row;
    NSString *hours = _diningLocation.hours[index];
    NSLog(@"%@", hours);
    
    NSString *dayOfWeek = @"";
    
    switch (index) {
        case 0:
            dayOfWeek = @"Sunday";
            break;
        case 1:
           dayOfWeek = @"Monday";
            break;
        case 2:
            dayOfWeek = @"Tuesday";
            break;
        case 3:
            dayOfWeek = @"Wednesday";
            break;
        case 4:
            dayOfWeek = @"Thursday";
            break;
        case 5:
            dayOfWeek = @"Friday";
            break;
        default:
            dayOfWeek = @"Saturday";
            break;
    }
    
    cell.textLabel.text = dayOfWeek;
    cell.detailTextLabel.text = hours;
    
    return cell;
}

@end
