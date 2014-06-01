//
//  NSString+NMKit_Extenstion.m
//  NMKit
//
//  Created by Vladimir Konev on 12/3/11.
//  Copyright (c) 2011 Novilab Mobile. All rights reserved.
//

#import "NSString+NMKit_Extenstion.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

NSString*   _deviceSuffix(void);
NSString*   _stateSuffix(UIControlState controlState);

NSString*   _deviceSuffix(void){
    if (IS_PAD())
        return @"_pad";
    else
        return @"";
}

NSString*   _stateSuffix(UIControlState controlState){
    NSString*   suffix;
    switch (controlState) {
        case UIControlStateHighlighted:
            suffix  =   @"_h";
            break;
            
        case UIControlStateDisabled:
            suffix  =   @"_d";
            break;
            
        case UIControlStateSelected:
            suffix  =   @"_s";
            break;
            
        case UIControlStateNormal:
        default:
            suffix  =   @"";
            break;
    }
    
    return suffix;
}

@implementation NSString (NMKit_Extenstion)

#pragma mark    -   Hash RAW
    //Get raw hash of NSString with MD5 algorithm
-	(NSData*)	MD5{
	const char*		data	=	[self	UTF8String];
	unsigned char	hashingBuffer[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5(data, strlen(data), hashingBuffer);
	
	return	[NSData	dataWithBytes:hashingBuffer
                          length:CC_MD5_DIGEST_LENGTH];
}
    //Get raw hash of NSString with SHA1 algorithm
-	(NSData*)	SHA1{
	const char*		data	=	[self	UTF8String];
	unsigned char	hashingBuffer[CC_SHA1_DIGEST_LENGTH];
	
	CC_SHA1(data, strlen(data), hashingBuffer);
	
	return	[NSData	dataWithBytes:hashingBuffer
                          length:CC_SHA1_DIGEST_LENGTH];
}

    //Get raw hash of NSString with MD5 algorithm and HMAC postprocessing
-	(NSData*)	HMAC_MD5:	(NSString*)hmacKey{
	const char*		data	=	[self	UTF8String];
	const char*		hashKey	=	[hmacKey	UTF8String];
	unsigned char	hashingBuffer[CC_MD5_DIGEST_LENGTH];
	
	CCHmac(kCCHmacAlgMD5, hashKey, strlen(hashKey), data, strlen(data), hashingBuffer);
	
	return	[NSData dataWithBytes:hashingBuffer length:CC_MD5_DIGEST_LENGTH];
}

    //Get raw hash of NSString with SHA1 algorithm and HMAC postprocessing
-	(NSData*)	HMAC_SHA1:	(NSString *)hmacKey{
	const char*		data	=	[self	UTF8String];
	const char*		hashKey	=	[hmacKey	UTF8String];
	unsigned char	hashingBuffer[CC_SHA1_DIGEST_LENGTH];
    
	CCHmac(kCCHmacAlgSHA1, hashKey, strlen(hashKey), data, strlen(data), hashingBuffer);
    
	return	[NSData	dataWithBytes:hashingBuffer length:CC_SHA1_DIGEST_LENGTH];
}

#pragma mark - Hash Base64
    //Get hash of NSString with MD5 algorithm and return Base64 interpretation
-   (NSString*) MD5_x64{
    return [[self   MD5]    base64Value];
}

    //Get hash of NSString with SHA1 algorithm and return Base64 interpretation
-   (NSString*) SHA1_x64{
    return [[self   SHA1]   base64Value];
}

    //Get hash of NSString with MD5 algorithm, HMAC postprocessing and return Base64 interpretation
-   (NSString*) HMAC_MD5_x64:(NSString *)hmacKey{
    return [[self HMAC_MD5:hmacKey] base64Value];
}

    //Get hash of NSString with SHA1 algorithm, HMAC postprocessing and return Base64 interpretation
-   (NSString*) HMAC_SHA1_x64:(NSString *)hmacKey{
    return [[self   HMAC_SHA1:hmacKey]  base64Value];
}

#pragma mark - Hash HEX
    //Get hash of NSString with MD5 algorithm and return hexadecimal interpretation
-   (NSString*) MD5_HEX{
    return [[self   MD5]    hexValue];
}
    //Get hash of NSString with SHA1 algorithm and return hexadecimal interpretation
-   (NSString*) SHA1_HEX{
    return [[self   SHA1]   hexValue];
}

    //Get hash of NSString with MD5 algorithm, HMAC postprocessing and return hexadecimal interpretation
-   (NSString*) HMAC_MD5_HEX:(NSString *)hmacKey{
    return [[self   HMAC_MD5:hmacKey]   hexValue];
}

    //Get hash of NSString with SHA1 algorithm, HMAC postprocessing and return hexadecimal interpretation
-   (NSString*) HMAC_SHA1_HEX:(NSString *)hmacKey{
    return [[self   HMAC_SHA1:hmacKey]  hexValue];
}

#pragma mark - Helpers
-   (BOOL)  hasCaseInsensetivePrefix:(NSString *)prefix{
    if ([self   length] <   [prefix length])
        return NO;
    
    if ([[self uppercaseString] hasPrefix:[prefix uppercaseString]])
        return YES;
    else
        return NO;
}

-   (BOOL)  hasCaseInsensetivePrefixInAnyWord:(NSString*)prefix{
        //LAZY RETURN
    if (prefix  ==  nil ||  prefix.length   ==  0)
        return YES;
    
    BOOL    result  =   NO;
    
        //FUTHER OPERATE ONLY ON UPPERCASED STRINGS
    NSString*   upperSelf   =   [self   uppercaseString];
    NSString*   upperPrefix =   [prefix uppercaseString];
    
    static  NSMutableCharacterSet*  st_emptySymbols =   nil;
    if (st_emptySymbols ==  nil){
        st_emptySymbols =   [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
        [st_emptySymbols    formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    }
    
    NSArray*    tokens  =   [upperSelf  componentsSeparatedByCharactersInSet:st_emptySymbols];
    
    for (NSString*  token in tokens)
        if ([token  rangeOfString:upperPrefix
                          options:NSDiacriticInsensitiveSearch | NSAnchoredSearch].location !=  NSNotFound){
            result  =   YES;
            break;
        }
    
    return  result;
}

-   (BOOL)  hasCaseInsensetiveSuffix:(NSString *)suffix{
    if ([self length]   <   [suffix length])
        return NO;
    
    if ([[self uppercaseString] hasSuffix:[suffix uppercaseString]])
        return YES;
    else
        return NO;
}

    //GET URL request prepared
-   (NSString*) preparedGetURLWithParams:(NSDictionary *)params{
    NSMutableArray*	paramComponents	=	[[NSMutableArray	alloc] init];
	for (NSString * key in [params keyEnumerator]) {
        id value    =   [params objectForKey:key];
        if (![value isKindOfClass:[NSString class]] &&
            ![value isKindOfClass:[NSNumber class]])
            continue;
        
		NSString*	ParsedKey	=	(__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) key, NULL, (CFStringRef) @":;.&%$#@!?[]{}+", kCFStringEncodingUTF8);
		NSString*	ParsedValue	=	(__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)[[params objectForKey:key]    description], NULL, (CFStringRef) @":;.&%$#@!?[]{}+", kCFStringEncodingUTF8);
		[paramComponents addObject:[NSString stringWithFormat:@"%@=%@", ParsedKey, ParsedValue]];
	}
	
	return	[self	stringByAppendingFormat:@"?%@",[paramComponents	componentsJoinedByString:@"&"]];
}

+   (CGFloat)   oneLineTextHeightWithFont:(UIFont *)font{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    return [@"TestString" sizeWithFont:font].height;
#else
    return [@"TestString" sizeWithAttributes:@{NSFontAttributeName : font}].height;
#endif
}

#pragma mark - Working with phone numbers
    //PHONE NORMALIZATION
-   (NSString*) normalizedRussianPhoneNumber{
    NSString*   result;
    result  =   [self   stringByReplacingOccurrencesOfString:@" " withString:@""];
    result  =   [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    result  =   [result stringByReplacingOccurrencesOfString:@"(" withString:@""];
    result  =   [result stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    if ([result length] >   10  &&  [result hasPrefix:@"8"])
        result  =   [result stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"+7"];
    
    return result;
}

-   (NSString*) formattedRussianPhoneNumber{
    NSString*   result  =   [self   copy];
    
    NSString*   normalizedPhoneNumber   =   [self   normalizedRussianPhoneNumber];
    NSInteger   length                  =   [normalizedPhoneNumber  length];
    
    if (length >=   10){
        NSString*   lastSevenDigits     =   [normalizedPhoneNumber  substringWithRange:NSMakeRange(length - 7, 7)];
        NSString*   defCode             =   [normalizedPhoneNumber  substringWithRange:NSMakeRange(length - 10, 3)];
        NSString*   countryCode         =   [normalizedPhoneNumber  substringWithRange:NSMakeRange(0, length - 10)];
        countryCode =   [countryCode    stringByReplacingOccurrencesOfString:@"+"
                                                                  withString:@""];
        
        result  =   [NSString   stringWithFormat:@"+%@ (%@) %@-%@-%@",
                     countryCode,
                     defCode,
                     [lastSevenDigits   substringWithRange:NSMakeRange(0, 3)],
                     [lastSevenDigits   substringWithRange:NSMakeRange(3, 2)],
                     [lastSevenDigits   substringWithRange:NSMakeRange(5, 2)]];
    }
    
    return result;
}

@end
