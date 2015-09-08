//
//  DiningLocation.m
//  NYUDining
//
//  Created by Ross Freeman on 9/8/15.
//  Copyright (c) 2015 Ross Freeman. All rights reserved.
//

#import "DiningLocation.h"

@implementation DiningLocation

-(id)initWithData:(NSDictionary *)data {
    self = [super init];
    
    if (self) {
        _hours = [[NSMutableArray alloc] initWithCapacity:0];
        _paymentTypes = [[NSMutableArray alloc] initWithCapacity:0];
        
        _name = [data objectForKey:@"name"];
        _logoURL = [data objectForKey:@"logo"];
        _address = [data objectForKey:@"address"];
        _phoneNumber = [data objectForKey:@"phone"];
        
        for (NSDictionary *payments in [data objectForKey:@"payments"]) {
            if ([payments objectForKey:@"accepted"]) {
                [_paymentTypes addObject:[payments objectForKey:@"name"]];
            }
        }
        
        NSArray *timetable = [data objectForKey:@"timetable"];
        
        NSArray *times = [timetable [0] objectForKey:@"information"];
        
        for (NSDictionary *time in times) {
            [_hours addObject:time];
        }
        
    }
                           
    return self;
}

@end
