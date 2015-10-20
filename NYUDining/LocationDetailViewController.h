//
//  LocationDetailViewController.h
//  NYUDining
//
//  Created by Ross Freeman on 9/24/15.
//  Copyright © 2015 Ross Freeman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AFNetworking/AFNetworking.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "DiningLocation.h"

@interface LocationDetailViewController : UIViewController

@property (strong, nonatomic) DiningLocation *location;
@property (weak, nonatomic) IBOutlet UIImageView *locationLogo;
@property (weak, nonatomic) IBOutlet UILabel *locationStatusLabel;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;

-(NSString *)getHoursString;

@end
