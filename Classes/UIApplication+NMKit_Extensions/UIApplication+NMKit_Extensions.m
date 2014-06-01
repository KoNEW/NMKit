//
//  UIApplication+NMKit_Extensions.m
//  VKMessenger
//
//  Created by Mephi Skib on 22.03.12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

#import "UIApplication+NMKit_Extensions.h"
#import "NMKitDefines.h"

@implementation UIApplication (NMKit_Extensions)

+   (void)  redirectLogOutputToDocumentsFolderWithFileName:(NSString*)fileName{
    NSString*   logPath =   [DOCUMENTS_PATH stringByAppendingPathComponent:fileName];
    NSLog(@"ATTENTION: Try to redirect application std output of to file: %@", logPath);
    
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

+   (void)  redirectLogOutputToDocumentsFolder{
    NSDateFormatter*    formatter   =   [[NSDateFormatter   alloc]  init];
    [formatter  setDateFormat:@"MM-dd_HH:mm:ss"];
    NSString*   fileName    =   [NSString stringWithFormat:@"LogConsole_%@.log", [formatter stringFromDate:[NSDate date]]];
    [UIApplication  redirectLogOutputToDocumentsFolderWithFileName:fileName];
}


+   (void)  openURL:(NSString *)url{
    [[UIApplication sharedApplication]  openURL:[NSURL URLWithString:url]];
}

+   (void)  callPhone:(NSString *)phoneNumber{
    NSString*   url =   [NSString   stringWithFormat:@"tel://%@", phoneNumber];
    [UIApplication  openURL:url];
}

+   (void)  sendSMS:(NSString *)phoneNumber{
    NSString*   url =   [NSString   stringWithFormat:@"sms://%@", phoneNumber];
    [UIApplication  openURL:url];
}

+   (NSURL*) applicationDocumentsFolderUrl{
    return [[[NSFileManager defaultManager]  URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]   lastObject];
}

+   (NSURL*) applicationDocumentsFolderUrlWithFileName:(NSString *)fileName{
    NSURL* applicationFolder = [UIApplication applicationDocumentsFolderUrl];
    
    return [applicationFolder URLByAppendingPathComponent:fileName];
}

@end
