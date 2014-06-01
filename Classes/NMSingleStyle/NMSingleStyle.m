//
//  NMSingleStyle.m
//  VKMessenger
//
//  Created by Vladimir Konev on 3/24/12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

#import "NMSingleStyle.h"
#import "NMSingleStyleProperty.h"

@implementation NMSingleStyle
@synthesize properties  =   _properties;

#pragma mark    -   LifeCycle
-   (id)    init{
    return [self    initWithProperties:nil];
}

-   (id)    initWithProperties:(NSArray *)properties{
    self    =   [super  init];
    
    if (self){
        _properties    =   [[NSMutableSet  alloc]  init];
        
        for (NMSingleStyleProperty* property in [properties objectEnumerator])
            if ([property   isKindOfClass:[NMSingleStyleProperty class]])
                [self   addProperty:property];
    }
    
    return self;
}

#pragma mark    -   Logic
-   (void)  addStylePropertyWithSelector:(SEL)selector
                                   value:(id)value
                            propertyType:(NMSingleStylePropertyType)propertyType{
    NMSingleStyleProperty*    property    =   [[NMSingleStyleProperty   alloc]  initWithSelector:selector
                                                                                           value:value
                                                                                    propertyType:propertyType];
    
    [_properties   addObject:property];
}

-   (void)  addProperty:(NMSingleStyleProperty *)property{
    [self   addStylePropertyWithSelector:property.selector
                                   value:property.value
                            propertyType:property.propertyType];
}

-   (void)  removeStylePropertyForSelector:(SEL)selector{
    [_properties   enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NMSingleStyleProperty*  property    =   obj;
        if (property.selector == selector)
            [_properties   removeObject:property];
    }];
}

-   (void)  removeProperty:(NMSingleStyleProperty *)property{
    [self   removeStylePropertyForSelector:property.selector];
}

#pragma mark    -   Apply
-   (void)  applyStyleToReciever:(id)reciever{ 
    [_properties   enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NMSingleStyleProperty*  property    =   obj;
        [property   applyToReciever:reciever];
    }];
}

-   (NMSingleStyleProperty*)    propertyForSelector:(SEL)selector{
    NMSingleStyleProperty*  result  =   nil;
    for (NMSingleStyleProperty* property in [_properties objectEnumerator])
        if (property.selector   ==  selector){
            result  =   property;
            break;
        }
    
    return result;
}

@end
