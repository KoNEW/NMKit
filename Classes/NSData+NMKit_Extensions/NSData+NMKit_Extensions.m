//
//  NSData+NMKit_Extensions.m
//  VKMessenger
//
//  Created by Mephi Skib on 27.03.12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

#import "NSData+NMKit_Extensions.h"
#import "Base64.h"

@implementation NSData (NMKit_Extensions)

-   (NSString*) hexValue{    
    int length  =   [self length];
    
    NSMutableString*        value   =   [[NSMutableString   alloc]  initWithCapacity:length*2];
    const   unsigned char*  buffer  =   (const unsigned char*)[self   bytes];
    
    if (!buffer)
        return  @"";
    
    for (int i = 0; i   < length; i++)
        [value appendFormat:@"%02lx", (unsigned long)buffer[i]];
    
    
    return [NSString    stringWithString:value];
}

-   (NSString*) base64Value{
    return [Base64  encode:self];
}

@end
