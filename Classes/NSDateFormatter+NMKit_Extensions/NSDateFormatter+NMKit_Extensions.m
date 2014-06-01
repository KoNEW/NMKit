//
//  NSDateFormatter+NMKit_Extensions.m
//  VKMessenger
//
//  Created by Mephi Skib on 15.04.12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

#import "NSDateFormatter+NMKit_Extensions.h"

@implementation NSDateFormatter (NMKit_Extensions)

-   (NSString*) naturalDayStringFromDate:(NSDate *)date{
    switch ([date   dateType]){
        case NMDateYesterday:
            [self   setDateStyle:NSDateFormatterShortStyle];
            [self   setTimeStyle:NSDateFormatterNoStyle];
            [self   setDoesRelativeDateFormatting:YES];
            break;
            
        case NMDateToday:
            [self   setDateStyle:NSDateFormatterNoStyle];
            [self   setTimeStyle:NSDateFormatterShortStyle];
            [self   setDoesRelativeDateFormatting:NO];
            break;
            
        case NMDateFuture:
        case NMDatePast:
        case NMDateTomorrow:
        default:
            [self   setDateStyle:NSDateFormatterShortStyle];
            [self   setTimeStyle:NSDateFormatterNoStyle];
            [self   setDoesRelativeDateFormatting:NO];
            break;
    }
    
    return [self   stringFromDate:date];
}

@end
