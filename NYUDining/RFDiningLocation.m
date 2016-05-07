//
//  DiningLocation.m
//  NYUDining
//
//  Created by Ross Freeman on 9/8/15.
//  Copyright (c) 2015 Ross Freeman. All rights reserved.
//

#import "RFDiningLocation.h"

@implementation RFDiningLocation

-(id)initWithData:(NSDictionary *)data andParameters:(NSDictionary *)params{
    self = [super init];
    
    if (self) {
        _hours = [[NSMutableArray alloc] initWithCapacity:0];
        _paymentTypes = [[NSMutableArray alloc] initWithCapacity:0];
        _coordinates = [[NSMutableArray alloc] initWithCapacity:0];
        self.data = data;
        
        NSString *cal = [params objectForKey:@"calendar"];
        
        _hours = [data objectForKey:cal];
        _name = [data objectForKey:@"Name"];
        _logoURL = [data objectForKey:@"logo_URL"];
        _menuURL = [data objectForKey:@"menu_url"];
        _address = [data objectForKey:@"Address"];
        _phoneNumber = [data objectForKey:@"phone"];
        _coordinates = [[data objectForKey:@"Coordinates"] mutableCopy];
        
        for (NSDictionary *payments in [data objectForKey:@"payments"]) {
            if ([payments objectForKey:@"accepted"]) {
                [_paymentTypes addObject:[payments objectForKey:@"name"]];
            }
        }
        
    }
    
    return self;
}

// Changes hours selection
-(void)setNewHours:(NSString *)option {
    
    option = [option stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    _hours = [self.data objectForKey:option];
    
    // Recalculate status based on new times
    [self isOpen];
}


// Determines if location is currently open
-(BOOL)isOpen {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayOfWeek = [dateFormatter stringFromDate:[NSDate date]];
    
    // Finds the current time and stores it as a double
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *currentTime = [outputFormatter stringFromDate:now];
    NSArray *times = [currentTime componentsSeparatedByString:@":"];
    double currentHour = [times[0] doubleValue];
    double currentMinute = [times[1] doubleValue];
    NSLog(@"Current time: %ld:%ld", (long)currentHour, (long)currentMinute);
    double timeDouble = currentHour + currentMinute/60;
    
    double timeA = 0;
    double timeB = 0;

    [outputFormatter setDateFormat:@"a"];
    
    NSString *hoursToday = @"";
    
    // Get hours for today
    if ([dayOfWeek isEqualToString:@"Sunday"]) {
        hoursToday = _hours[0];
    }
    
    else if ([dayOfWeek isEqualToString:@"Monday"]) {
        hoursToday = _hours[1];
    }
    
    else if ([dayOfWeek isEqualToString:@"Tuesday"]) {
        hoursToday = _hours[2];
    }
    
    else if ([dayOfWeek isEqualToString:@"Wednesday"]) {
        hoursToday = _hours[3];
    }
    
    else if ([dayOfWeek isEqualToString:@"Thursday"]) {
        hoursToday = _hours[4];
    }
    
    else if ([dayOfWeek isEqualToString:@"Friday"]) {
        hoursToday = _hours[5];
    }
    
    else if ([dayOfWeek isEqualToString:@"Saturday"]) {
        hoursToday = _hours[6];
    }
    
    // Check if location closes mid-day
    if ([hoursToday containsString:@","]) {
        NSArray *timeSlots = [hoursToday componentsSeparatedByString:@","];
        
        NSInteger counter = 0;
        
        for (NSString *timeSlot in timeSlots) {
            
            counter++;
            
            NSArray *times = [timeSlot componentsSeparatedByString:@"-"];
            
            NSMutableString *time0 = [times[0] mutableCopy];
            NSMutableString *time1 = [times[1] mutableCopy];
            
            if ([times[0] containsString:@"am"]) {
                
                if ([times[0] containsString:@"12"]) {
                    timeA = 0;
                }
                
                else {
                    [time0 deleteCharactersInRange:[time0 rangeOfString:@"am"]];
                    
                    if ([time0 containsString:@":"]) {
                        NSArray *timeArray = [time0 componentsSeparatedByString:@":"];
                        NSString *minute = timeArray[1];
                        double minuteInHour = [minute doubleValue] / 60.0;
                        timeA = [times[0] doubleValue] + minuteInHour;
                    }
                    
                    else
                        timeA = [times[0] doubleValue];
                }
            }
            
            else {
                [time0 deleteCharactersInRange:[time0 rangeOfString:@"pm"]];
                
                
                if ([time0 containsString:@":"]) {
                    NSArray *timeArray = [time0 componentsSeparatedByString:@":"];
                    NSString *minute = timeArray[1];
                    double minuteInHour = [minute doubleValue] / 60.0;
                    timeA = [times[0] doubleValue] + minuteInHour;
                }
                
                else
                    timeA = [times[0] doubleValue];
                
                if (timeA < 12) {
                    timeA += 12;
                }
            }
            
            
            
            if ([times[1] containsString:@"am"]) {
                if ([times[1] containsString:@"12"]) {
                    timeB = 0;
                }
                
                else {
                    [time1 deleteCharactersInRange:[time1 rangeOfString:@"am"]];
                    
                    if ([time1 containsString:@":"]) {
                        NSArray *timeArray = [time1 componentsSeparatedByString:@":"];
                        NSString *minute = timeArray[1];
                        double minuteInHour = [minute doubleValue] / 60.0;
                        timeB = [times[1] doubleValue] + minuteInHour;
                    }
                    
                    else
                        timeB = [times[1] doubleValue];
                }
            }
            
            else {
                [time1 deleteCharactersInRange:[time1 rangeOfString:@"pm"]];
                
                
                if ([time1 containsString:@":"]) {
                    timeB = [times[1] doubleValue] + 0.5;
                }
                
                else
                    timeB = [times[1] doubleValue];
                
                if (timeB < 12) {
                    timeB += 12;
                }
            }
            
            if (timeDouble >= timeA && timeDouble < timeB) {
                return YES;
            }
            
            else if (counter == timeSlots.count)
                return NO;
            
        }
        
        
    }
    
    else {
        
        if ([hoursToday isEqualToString:@"Closed"]) {
            return NO;
        }
        else {
            
            NSArray *times = [hoursToday componentsSeparatedByString:@"-"];
            
            NSMutableString *time0 = [times[0] mutableCopy];
            NSMutableString *time1 = [times[1] mutableCopy];
            
            if ([times[0] containsString:@"am"]) {
                
                if ([times[0] containsString:@"12"]) {
                    timeA = 0;
                }
                
                else {
                    [time0 deleteCharactersInRange:[time0 rangeOfString:@"am"]];
                    
                    if ([time0 containsString:@":"]) {
                        NSArray *timeArray = [time0 componentsSeparatedByString:@":"];
                        NSString *minute = timeArray[1];
                        double minuteInHour = [minute doubleValue] / 60.0;
                        timeA = [times[0] doubleValue] + minuteInHour;
                    }
                    
                    else
                        timeA = [times[0] doubleValue];
                }
            }
            
            else {
                [time0 deleteCharactersInRange:[time0 rangeOfString:@"pm"]];
                
                if ([time0 containsString:@":"]) {
                    NSArray *timeArray = [time0 componentsSeparatedByString:@":"];
                    NSString *minute = timeArray[1];
                    double minuteInHour = [minute doubleValue] / 60.0;
                    timeA = [times[0] doubleValue] + minuteInHour;
                }
                
                else
                    timeA = [times[0] doubleValue];
                
                if (timeA < 12) {
                    timeA += 12;
                }
            }
            
            if ([times[1] containsString:@"am"]) {
                if ([times[1] containsString:@"12"]) {
                    timeB = 0;
                }
                
                else {
                    [time1 deleteCharactersInRange:[time1 rangeOfString:@"am"]];
                    
                    if ([time1 containsString:@":"]) {
                        NSArray *timeArray = [time1 componentsSeparatedByString:@":"];
                        NSString *minute = timeArray[1];
                        double minuteInHour = [minute doubleValue] / 60.0;
                        timeB = [times[1] doubleValue] + minuteInHour;
                    }
                    
                    else
                        timeB = [times[1] doubleValue];
                }
            }
            
            else {
                [time1 deleteCharactersInRange:[time1 rangeOfString:@"pm"]];
                
                if ([time1 containsString:@":"]) {
                    NSArray *timeArray = [time1 componentsSeparatedByString:@":"];
                    NSString *minute = timeArray[1];
                    double minuteInHour = [minute doubleValue] / 60.0;
                    timeB = [times[1] doubleValue] + minuteInHour;
                }
                
                else
                    timeB = [times[1] doubleValue];
                
                if (timeB < 12) {
                    timeB += 12;
                }
            }
            
            if ((timeDouble >= timeA && timeDouble < timeB) || (timeDouble >= timeA && timeB == 0)) {
                return YES;
            }
            
            else
                return NO;
            
        }
    }
    
    return YES;
}

// For dev purposes ONLY
// Do not use
- (BOOL)isOpenTest {
    return NO;
}

- (NSDate *)convertTimeRangeToDate:(NSString *)time {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *formattedTime = [formatter dateFromString:time];
    
    NSLog(@"%@", formattedTime);
    
    return formattedTime;
    
}


@end
