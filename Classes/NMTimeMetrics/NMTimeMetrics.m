//
//  NMTimeMarker.m
//  Scheme
//
//  Created by Vladimir Konev on 4/28/13.
//  Copyright (c) 2013 Novilab Mobile. All rights reserved.
//

#import "NMTimeMetrics.h"
#import "NMKitDefines.h"

@interface NMTimeMetrics (){
    NSMutableArray* _times;
    NSMutableArray* _marks;
    
    NSDate*         _startTime;
}

@end

@implementation NMTimeMetrics

#pragma mark    -   LifeCycle
-   (instancetype)  init{
    self    =   [super  init];
    
    if (self){
        _times  =   [[NSMutableArray    alloc]  init];
        _marks  =   [[NSMutableArray    alloc]  init];
    }
    
    return self;
}

+   (instancetype) timeMetrics{
    NMTimeMetrics*   result  =   [[NMTimeMetrics  alloc]  init];
    [result start];
    
    return result;
}


#pragma mark    -   Logic

-   (void)  appendMark:(NSString *)mark{
    [_times addObject:[NSDate date]];
    [_marks addObject:[mark copy]];
}

-   (void)  start{
    [_times removeAllObjects];
    [_marks removeAllObjects];
    
    _startTime  =   [NSDate date];
}

-   (void)  print{
    NSDate*         finishTime  =   [NSDate date];
    NSTimeInterval  fullTime    =   [finishTime timeIntervalSinceDate:_startTime];
    
    NSDate*         lastMark    =   _startTime;
    NMLog(@"NMTimeMarker Stats. Full: %f sec.", fullTime);
    for (int i = 0; i < _times.count; i++){
        NSDate*         timeMark    =   [_times objectAtIndex:i];
        NSString*       userMark    =   [_marks objectAtIndex:i];
        NSTimeInterval  duration    =   [timeMark   timeIntervalSinceDate:lastMark];
        
        NMLog(@"%d) \"%@\". %f sec. <%.2f%%>", i+1, userMark, duration, duration / fullTime * 100.0);
        
        lastMark    =   timeMark;
    }
}

-   (void)  printWithTitle:(NSString *)title
             andShortStyle:(BOOL)shortStyle{
    NSDate*         finishTime  =   [NSDate date];
    NSTimeInterval  fullTime    =   [finishTime timeIntervalSinceDate:_startTime];
    
    NSDate*         lastMark    =   _startTime;
    if (title   !=  nil)
        NMLog(@"NMTimeMarker Stats. \"%@\" Full: %f sec.", title, fullTime);
    else
        NMLog(@"NMTimeMarker Stats. Full: %f sec.", fullTime);
    if (!shortStyle)
        for (int i = 0; i < _times.count; i++){
            NSDate*         timeMark    =   [_times objectAtIndex:i];
            NSString*       userMark    =   [_marks objectAtIndex:i];
            NSTimeInterval  duration    =   [timeMark   timeIntervalSinceDate:lastMark];
            
            NMLog(@"%d) \"%@\". %f sec. <%.2f%%>", i+1, userMark, duration, duration / fullTime * 100.0);
            
            lastMark    =   timeMark;
        }
}


@end
