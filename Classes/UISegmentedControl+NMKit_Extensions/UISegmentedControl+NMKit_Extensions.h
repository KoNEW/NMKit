//
//  UISegmentedControl+NMKit_Extensions.h
//  VKMessenger
//
//  Created by Vladimir Konev on 4/13/12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl (NMKit_Extensions)

+   (void)  setBackgroundImage:(NSString*)imageName     __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_5_0) ;
+   (void)  setDividerImage:(NSString*)imageName        __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_5_0) ;

@end
