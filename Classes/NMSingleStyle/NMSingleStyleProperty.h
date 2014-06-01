//
//  NMSingleStyleProperty.h
//  VKMessenger
//
//  Created by Vladimir Konev on 3/24/12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    /*
     If you want to add some class-layer property you should use it directly
     */
    NMSingleStylePropertyClass  =   0,
    
    /*
     If you want to add some numerical-layer property you should use it by wrapping in NSNumber
     */
    NMSingleStylePropertyBool,
    NMSingleStylePropertyChar,
    NMSingleStylePropertyDouble,
    NMSingleStylePropertyFloat,
    NMSingleStylePropertyInt,
    NMSingleStylePropertyInteger,
    NMSingleStylePropertyLong,
    NMSingleStylePropertyLongLong,
    NMSingleStylePropertyShort,
    NMSingleStylePropertyUnsignedChar,
    NMSingleStylePropertyUnsignedInt,
    NMSingleStylePropertyUnsignedInteger,
    NMSingleStylePropertyUnsignedLong,
    NMSingleStylePropertyUnsignedLongLong,
    NMSingleStylePropertyUnsignedShort,
    
    /*
     If you want to use sime CoreGraphics elements you should use it by wrapping in NSString
     */
    NMSingleStylePropertyCGRect,
    NMSingleStylePropertyCGSize
}   NMSingleStylePropertyType;

@interface NMSingleStyleProperty : NSObject{
    SEL _selector;
    id  _value;
    NMSingleStylePropertyType   _propertyType;
}

@property(nonatomic, assign) SEL    selector;
@property(nonatomic, strong) id     value;
@property(nonatomic, assign) NMSingleStylePropertyType  propertyType;

-   (id)    initWithSelector:(SEL)selector
                       value:(id)value
                propertyType:(NMSingleStylePropertyType)propertyType;

-   (void)  applyToReciever:(id)receiver;


@end
