    //
    //  NSDate+NMKit_Extensions.m
    //  VKMessenger
    //
    //  Created by Mephi Skib on 15.04.12.
    //  Copyright (c) 2012 Novilab Mobile. All rights reserved.
    //

#import "NSDate+NMKit_Extensions.h"

@implementation NSDate (NMKit_Extensions)

-   (NMDateType)    dateType{
    NSDate* todayMidnight       =   [NSDate lastMidNightFromToday];
    
    NSTimeInterval  difference  =   [self   timeIntervalSinceDate:todayMidnight];
    
    NMDateType  result  =   NMDatePast;
    
    if (difference < -1*NM_SECONDS_PER_DAY)
        result  =   NMDatePast;
    else if (difference < 0)
        result  =   NMDateYesterday;
    else if (difference < NM_SECONDS_PER_DAY)
        result  =   NMDateToday;
    else if (difference < 2*NM_SECONDS_PER_DAY)
        result  =   NMDateTomorrow;
    else
        result  =   NMDateFuture;
    
    return result;
}

+   (NSDate*)   dateWithRFC3339Value:(NSString *)rfc3339Value{
    if (rfc3339Value    ==  nil)
        return nil;
    
        //PREPARE COMPONENTS AND PARSING SYMBOLS AND PARSER
    NSInteger year          = NSUndefinedDateComponent;
    NSInteger month         = NSUndefinedDateComponent;
    NSInteger day           = NSUndefinedDateComponent;
    NSInteger hour          = NSUndefinedDateComponent;
    NSInteger minute        = NSUndefinedDateComponent;
    NSInteger sec           = NSUndefinedDateComponent;
    float secFloat          = -1.0f;
    NSString* sign          = nil;
    NSInteger offsetHour    = 0;
    NSInteger offsetMinute  = 0;
    
    NSScanner* scanner = [NSScanner scannerWithString:rfc3339Value];
    
    NSCharacterSet* dashSet         = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    NSCharacterSet* tSet            = [NSCharacterSet characterSetWithCharactersInString:@"Tt "];
    NSCharacterSet* colonSet        = [NSCharacterSet characterSetWithCharactersInString:@":"];
    NSCharacterSet* plusMinusZSet   = [NSCharacterSet characterSetWithCharactersInString:@"+-zZ"];
    
    
        //PARSING STRING
        //DATE BLOCK
    [scanner    scanInteger:&year];
    [scanner    scanCharactersFromSet:dashSet
                           intoString:NULL];
    [scanner    scanInteger:&month];
    [scanner    scanCharactersFromSet:dashSet
                           intoString:NULL];
    [scanner    scanInteger:&day];
    
    if([scanner    isAtEnd]){
            //DATA REPRESENTED IN FORM OF "YYYY-DD-MM", so time should be set to 12:00 of this day
        hour            =   12;
        minute          =   0;
        secFloat        =   0.0;
        offsetHour      =   0;
        offsetMinute    =   0;
    }else{
            //TIME BLOCK
        [scanner    scanCharactersFromSet:tSet
                               intoString:NULL];
        [scanner    scanInteger:&hour];
        [scanner    scanCharactersFromSet:colonSet
                               intoString:NULL];
        [scanner    scanInteger:&minute];
        [scanner    scanCharactersFromSet:colonSet
                               intoString:NULL];
        [scanner    scanFloat:&secFloat];
        
            //TIMEZONE
        [scanner    scanCharactersFromSet:plusMinusZSet
                               intoString:&sign];
        [scanner    scanInteger:&offsetHour];
        [scanner    scanCharactersFromSet:colonSet
                               intoString:NULL];
        [scanner    scanInteger:&offsetMinute];
    }
    
    
        //PREPARING RESULT
    NSDateComponents*   dateComponentes =   [[NSDateComponents  alloc]  init];
    [dateComponentes    setYear:year];
    [dateComponentes    setMonth:month];
    [dateComponentes    setDay:day];
    [dateComponentes    setHour:hour];
    [dateComponentes    setMinute:minute];
    if (fabs(secFloat)  > 1.0f)
        sec =   (NSInteger) secFloat;
    [dateComponentes    setSecond:sec];
    
    
    NSDate* result  =   [[[NSCalendar   alloc]  initWithCalendarIdentifier:NSGregorianCalendar]   dateFromComponents:dateComponentes];
    
    NSInteger   totalOffset =   NSUndefinedDateComponent;
    
    if ([sign   caseInsensitiveCompare:@"Z"]    ==  NSOrderedSame)
        totalOffset =   0;
    else if (sign   !=  nil){
        totalOffset =   (60 * offsetHour) + (60 * 60 * offsetMinute);
        
        if ([sign   isEqualToString:@"-"]){
            if (totalOffset ==  0)//special case -0.00 means undefined date
                totalOffset =   NSUndefinedDateComponent;
            else
                totalOffset *= -1;
        }
    }
    
    return result;
}

-   (NSString*) rfc3339Value{
    static  NSDateFormatter*    rfc3339Formatter    =   nil;
    if (rfc3339Formatter    ==  nil){
        rfc3339Formatter    =   [[NSDateFormatter   alloc]  init];
        [rfc3339Formatter   setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    
    NSString*   result  =   [rfc3339Formatter   stringFromDate:self];
    result  =   [result stringByReplacingOccurrencesOfString:@" "
                                                  withString:@"T"];
    result  =   [result stringByAppendingString:@"+0000"];
    
    return result;
}


-   (NSDate*)   midNightTime{
    NSCalendar* gregorianCalendar   =   [[NSCalendar    alloc]  initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger  unitFlags           =   NSYearCalendarUnit  |   NSMonthCalendarUnit |   NSDayCalendarUnit;
    
    NSDateComponents*   components  =   [gregorianCalendar  components:unitFlags
                                                              fromDate:self];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [gregorianCalendar   dateFromComponents:components];
}

+   (NSDate*)   lastMidNightFromToday{
    return [[NSDate date]   midNightTime];
}

+   (NSDate*)   nextMidNightFromToday{
    return [[NSDate  dateWithTimeIntervalSinceNow:86400.0f] midNightTime];
}

-   (BOOL)      isToday{
    return [self    dateType]   ==  NMDateToday;
}

-   (BOOL)      isTomorrow{
    return [self    dateType]   ==  NMDateTomorrow;
}

-   (BOOL)      isYesterday{
    return [self    dateType]   ==  NMDateYesterday;
}

-   (BOOL)      isFuture:(BOOL)strictly{
    BOOL    result  =   [self   dateType]   ==  NMDateFuture;
    
    if (!strictly)
        result  |=  [self   dateType]   ==  NMDateTomorrow;
    
    return result;
}

-   (BOOL)      isFuture{
    return [self    isFuture:NO];
}

-   (BOOL)      isPast:(BOOL)strictly{
    BOOL    result  =   [self   dateType]   ==  NMDatePast;
    
    if (!strictly)
        result  |=  [self   dateType]   ==  NMDateYesterday;
    
    return result;
}

-   (BOOL)      isPast{
    return [self    isPast:NO];
}

-   (BOOL)      isSimilarDay:(NSDate *)date{
    return [[self   midNightTime]   isEqualToDate:[date midNightTime]];
}

@end
