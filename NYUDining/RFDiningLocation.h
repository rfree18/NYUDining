//
//  DiningLocation.h
//  NYUDining
//
//  Created by Ross Freeman on 9/8/15.
//  Copyright (c) 2015 Ross Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface RFDiningLocation : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *logoURL;
@property (strong, nonatomic) NSMutableArray *paymentTypes;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSMutableArray *hours;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSMutableArray *coordinates;
@property (strong, nonatomic) PFObject *data;

-(id)initWithData:(PFObject *)data;
-(void)setNewHours:(NSString *)option;
-(BOOL)isOpen;
-(BOOL)isOpenTest;
-(NSDate *)convertTimeRangeToDate:(NSString *)time;

@end
