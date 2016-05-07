//
//  DiningLocation.h
//  NYUDining
//
//  Created by Ross Freeman on 9/8/15.
//  Copyright (c) 2015 Ross Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RFDiningLocation : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *logoURL;
@property (strong, nonatomic) NSString *menuURL;
@property (strong, nonatomic) NSMutableArray *paymentTypes;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSMutableArray *hours;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSMutableArray *coordinates;
@property (strong, nonatomic) NSDictionary *data;

-(id)initWithData:(NSDictionary *)data andParameters:(NSDictionary *)params;
-(void)setNewHours:(NSString *)option;
-(BOOL)isOpen;
-(BOOL)isOpenTest;
-(NSDate *)convertTimeRangeToDate:(NSString *)time;

@end
