#import "NMSingleStyleProperty.h"

@implementation NMSingleStyleProperty
@synthesize selector    =   _selector,
            value       =   _value,
            propertyType=   _propertyType;

-   (id)    initWithSelector:(SEL)selector
                       value:(id)value
                propertyType:(NMSingleStylePropertyType)propertyType{
    self    =   [super  init];
    
    if (self){
        [self   setSelector:selector];
        [self   setValue:value];
        [self   setPropertyType:propertyType];
    }
    
    return self;
}

-   (id)    init{
    return [self    initWithSelector:nil
                               value:nil
                        propertyType:NMSingleStylePropertyClass];
}

-   (void)  applyToReciever:(id)receiver{
    if ([receiver   respondsToSelector:_selector]){
        NSInvocation*   anInvocation  =   [NSInvocation   invocationWithMethodSignature:[[receiver class] instanceMethodSignatureForSelector:_selector]];
        
        [anInvocation   setSelector:_selector];
        [anInvocation   setTarget:receiver];
        
        BOOL                boolValue;
        char                charValue;
        double              doubleValue;
        float               floatValue;
        int                 intValue;
        NSInteger           integerValue;
        long                longValue;
        long long           longLongValue;
        short               shortValue;
        unsigned char       unsignedCharValue;
        unsigned int        unsignedIntValue;
        NSUInteger          unsignedIntegerValue;
        unsigned long       unsignedLongValue;
        unsigned long long  unsignedLongLongValue;
        unsigned short      unsignedShortValue;
        
        CGRect              rectValue;
        CGSize              sizeValue;
        
        switch (_propertyType) {
            case NMSingleStylePropertyClass:
                [anInvocation   setArgument:&_value
                                    atIndex:2];
                break;
                
            case NMSingleStylePropertyBool:
                boolValue   =   [_value boolValue];
                [anInvocation   setArgument:&boolValue atIndex:2];
                break;
                
            case NMSingleStylePropertyChar:
                charValue   =   [_value charValue];
                [anInvocation   setArgument:&charValue atIndex:2];
                break;
                
            case NMSingleStylePropertyDouble:
                doubleValue =   [_value doubleValue];
                [anInvocation   setArgument:&doubleValue atIndex:2];
                break;
                
            case NMSingleStylePropertyFloat:
                floatValue  =   [_value floatValue];
                [anInvocation   setArgument:&floatValue atIndex:2];
                break;
                
            case NMSingleStylePropertyInt:
                intValue    =   [_value intValue];
                [anInvocation   setArgument:&intValue atIndex:2];
                break;
                
            case NMSingleStylePropertyInteger:
                integerValue=   [_value integerValue];
                [anInvocation   setArgument:&integerValue atIndex:2];
                break;
                
            case NMSingleStylePropertyLong:
                longValue   =   [_value longValue];
                [anInvocation   setArgument:&longValue atIndex:2];
                break;
                
            case NMSingleStylePropertyLongLong:
                longLongValue   =   [_value longLongValue];
                [anInvocation   setArgument:&longLongValue atIndex:2];
                break;
                
            case NMSingleStylePropertyShort:
                shortValue      =   [_value shortValue];
                [anInvocation   setArgument:&shortValue atIndex:2];
                break;
                
            case NMSingleStylePropertyUnsignedChar:
                unsignedCharValue   =   [_value unsignedCharValue];
                [anInvocation   setArgument:&unsignedCharValue atIndex:2];
                break;
                
            case NMSingleStylePropertyUnsignedInt:
                unsignedIntValue    =   [_value unsignedIntValue];
                [anInvocation   setArgument:&unsignedIntValue atIndex:2];
                break;
                
            case NMSingleStylePropertyUnsignedInteger:
                unsignedIntegerValue=   [_value unsignedIntegerValue];
                [anInvocation   setArgument:&unsignedIntegerValue atIndex:2];
                break;
                
            case NMSingleStylePropertyUnsignedLong:
                unsignedLongValue   =   [_value unsignedLongValue];
                [anInvocation   setArgument:&unsignedLongValue atIndex:2];
                break;
                
            case NMSingleStylePropertyUnsignedLongLong:
                unsignedLongLongValue   =   [_value unsignedLongLongValue];
                [anInvocation   setArgument:&unsignedLongLongValue atIndex:2];
                break;
                
            case NMSingleStylePropertyUnsignedShort:
                unsignedShortValue      =   [_value unsignedShortValue];
                [anInvocation   setArgument:&unsignedShortValue atIndex:2];
                break;
                
            case NMSingleStylePropertyCGRect:
                rectValue               =   CGRectFromString(_value);
                [anInvocation   setArgument:&rectValue atIndex:2];
                break;
                
            case NMSingleStylePropertyCGSize:
                sizeValue               =   CGSizeFromString(_value);
                [anInvocation   setArgument:&sizeValue atIndex:2];
                break;
                
            default:
                break;
        }
        
        [anInvocation   performSelector:@selector(invoke) withObject:nil];
    }
}

@end