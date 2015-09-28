//
//  LocationsViewController.m
//  NYUDining
//
//  Created by Ross Freeman on 9/8/15.
//  Copyright (c) 2015 Ross Freeman. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationDetailViewController.h"

@interface LocationsViewController ()

@end

@implementation LocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _diningLocations = [[NSMutableArray alloc] initWithCapacity:0];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Locations"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                DiningLocation *location = [[DiningLocation alloc] initWithData:object];
                [_diningLocations addObject:location];
            }
            
            [self.locationTable reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.locationTable reloadData];
    
    for (NSIndexPath *indexPath in _locationTable.indexPathsForSelectedRows) {
        [_locationTable deselectRowAtIndexPath:indexPath animated:NO];
    }
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
    NSLog(@"%lu", (unsigned long)_diningLocations.count);
    return _diningLocations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"location"];
    
    cell.textLabel.text = [_diningLocations[indexPath.row] name];
    NSLog(@"%@", [_diningLocations[indexPath.row] name]);
    
    if ([_diningLocations [indexPath.row] isOpen] == YES) {
        cell.detailTextLabel.text = @"Open";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.133f green:0.580f blue:0.282f alpha:1.00f];
    }
    
    else if ([_diningLocations [indexPath.row] isOpenTest] == NO) {
        cell.detailTextLabel.text = @"Closed";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    
    else {
        cell.detailTextLabel.text = @"Unknown";
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetails" sender:indexPath];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *path = (NSIndexPath *)sender;
    
    DiningLocation *selectedLocation = _diningLocations[path.row];
    LocationDetailViewController *dest = segue.destinationViewController;
    dest.location = selectedLocation;
}


@end
