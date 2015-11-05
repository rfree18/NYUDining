//
//  LocationDetailViewController.m
//  NYUDining
//
//  Created by Ross Freeman on 9/24/15.
//  Copyright © 2015 Ross Freeman. All rights reserved.
//

#import "LocationDetailViewController.h"

@interface LocationDetailViewController ()

@end

@implementation LocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _location.name;
    
    _hoursLabel.lineBreakMode = NSLineBreakByClipping;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSString *urlString = _location.logoURL;
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        _locationLogo.image = [UIImage imageWithData:data];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
    
    
    [_hoursLabel setPreferredMaxLayoutWidth:200];
    _hoursLabel.text = self.getHoursString;
    
    
    if ([_location isOpen]) {
        _locationStatusLabel.text = @"Open";
        _locationStatusLabel.textColor = [UIColor colorWithRed:0.133f green:0.580f blue:0.282f alpha:1.00f];
    }
    
    else {
        _locationStatusLabel.text = @"Closed";
        _locationStatusLabel.textColor = [UIColor redColor];
    }
    
    
    // Create a GMSCameraPosition that tells the map to display the
   // coordinate -33.86,151.20 at zoom level 6.
    
    double x = [_location.coordinates[0] doubleValue];
    double y = [_location.coordinates[1] doubleValue];
   
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:x
                                                            longitude:y
                                                                 zoom:16];
    
    _mapView.frame = CGRectZero;
    _mapView.camera = camera;
    
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(x, y);
    marker.title = _location.name;
    marker.snippet = _location.address;
    marker.map = _mapView;
    
    _mapView.selectedMarker = marker;
     
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getHoursString {
    
    NSMutableString *hoursString = [[NSMutableString alloc] init];
    NSString *todaysHours;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayOfWeek = [dateFormatter stringFromDate:[NSDate date]];
    
    if([dayOfWeek isEqualToString:@"Sunday"]) {
        todaysHours = _location.hours[0];
    }
    else if([dayOfWeek isEqualToString:@"Monday"]) {
        todaysHours = _location.hours[1];
    }
    else if([dayOfWeek isEqualToString:@"Tuesday"]) {
        todaysHours = _location.hours[2];
    }
    else if([dayOfWeek isEqualToString:@"Wednesday"]) {
        todaysHours = _location.hours[3];
    }
    else if([dayOfWeek isEqualToString:@"Thursday"]) {
        todaysHours = _location.hours[4];
    }
    else if([dayOfWeek isEqualToString:@"Friday"]) {
        todaysHours = _location.hours[5];
    }
    else
        todaysHours = _location.hours[6];
    
    hoursString = [[todaysHours stringByReplacingOccurrencesOfString:@"," withString:@"\n"] mutableCopy];
    
    
    return hoursString;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
