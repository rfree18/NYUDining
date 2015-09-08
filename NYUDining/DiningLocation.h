//
//  DiningLocation.h
//  NYUDining
//
//  Created by Ross Freeman on 9/8/15.
//  Copyright (c) 2015 Ross Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiningLocation : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *logoURL;
@property (strong, nonatomic) NSMutableArray *paymentTypes;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSMutableArray *hours;
@property (strong, nonatomic) NSString *address;

-(id)initWithData:(NSDictionary *)data;

@end
