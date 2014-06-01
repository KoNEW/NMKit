//
//  NSObject+NMSingleStyle.m
//  VKMessenger
//
//  Created by Vladimir Konev on 3/24/12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

#import "NSObject+NMSingleStyle.h"
#import "NMSingleStyle.h"

@implementation NSObject (NMSingleStyle)

-   (void)  applyStyle:(NMSingleStyle *)style{
    [style  applyStyleToReciever:self];
}

@end
