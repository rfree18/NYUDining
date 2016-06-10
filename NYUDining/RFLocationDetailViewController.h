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

#import "RFMenuBrowserViewController.h"

@class RFDiningLocation;

@interface RFLocationDetailViewController : UIViewController

@property (strong, nonatomic) RFDiningLocation *location;
@property (weak, nonatomic) IBOutlet UIImageView *locationLogo;
@property (weak, nonatomic) IBOutlet UILabel *locationStatusLabel;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

- (NSString *)getHoursString;
- (IBAction)showMenu:(id)sender;

@end
