//
//  NMSingleStyle.h
//  VKMessenger
//
//  Created by Vladimir Konev on 3/24/12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NMSingleStyle.h"
#import "NMSingleStyleProperty.h"
#import "NSObject+NMSingleStyle.h"

@interface NMSingleStyle : NSObject{
    NSMutableSet*   _properties;
}

@property(nonatomic, strong) NSMutableSet*  properties;

/*
 Constructors
 */

-   (id)    initWithProperties:(NSArray*)properties;

/*
 Apply current style for given object
 */
-   (void)  applyStyleToReciever:(id)reciever;


/*
Different methods for manipulating style properties
 */
-   (void)  addStylePropertyWithSelector:(SEL)selector
                                   value:(id)value
                            propertyType:(NMSingleStylePropertyType)propertyType;

-   (void)  addProperty:(NMSingleStyleProperty*)property;

-   (void)  removeStylePropertyForSelector:(SEL)selector;

-   (void)  removeProperty:(NMSingleStyleProperty*)property;

-   (NMSingleStyleProperty*)propertyForSelector:(SEL)selector;

@end
