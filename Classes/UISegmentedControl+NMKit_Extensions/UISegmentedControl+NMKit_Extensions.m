//
//  UISegmentedControl+NMKit_Extensions.m
//  VKMessenger
//
//  Created by Vladimir Konev on 4/13/12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

#import "UISegmentedControl+NMKit_Extensions.h"

@implementation UISegmentedControl (NMKit_Extensions)

+   (void)  setBackgroundImage:(NSString *)imageName{
    if (![UISegmentedControl conformsToProtocol:@protocol(UIAppearance)])
        return;
    
    UIEdgeInsets    insets  =   UIEdgeInsetsMake(0.0, 9.0, 0.0, 9.0);
    
    UIImage*        imageN  =   [[UIImage   imageNamed:imageName]   resizableImageWithCapInsets:insets];
    UIImage*        imageH  =   [[UIImage   imageNamed:[imageName stringByAppendingString:@"_h"]]    resizableImageWithCapInsets:insets];
    
    [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:imageN
                                                                                              forState:UIControlStateNormal
                                                                                            barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:imageH
                                                                                              forState:UIControlStateHighlighted
                                                                                            barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:imageH
                                                                                              forState:UIControlStateSelected
                                                                                            barMetrics:UIBarMetricsDefault];    

    if (IS_PHONE()){
        imageN  =   [[UIImage   imageNamed:[imageName   stringByAppendingString:@"~L"]]     resizableImageWithCapInsets:insets];
        imageH  =   [[UIImage   imageNamed:[imageName   stringByAppendingString:@"_h~L"]]   resizableImageWithCapInsets:insets];
//        imageN  =   [[UIImage   imageNamed:imageName
//                                 andStated:UIControlStateNormal
//                         landscapeOriented:YES] resizableImageWithCapInsets:insets];
//        imageH  =   [[UIImage   imageNamed:imageName
//                                 andStated:UIControlStateHighlighted
//                         landscapeOriented:YES] resizableImageWithCapInsets:insets];
        [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:imageN
                                                                                                  forState:UIControlStateNormal
                                                                                                barMetrics:UIBarMetricsLandscapePhone];
        [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:imageH
                                                                                                  forState:UIControlStateHighlighted
                                                                                                barMetrics:UIBarMetricsLandscapePhone];
        [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:imageH
                                                                                                  forState:UIControlStateSelected
                                                                                                barMetrics:UIBarMetricsLandscapePhone];  
    }
}

+   (void)  setDividerImage:(NSString *)imageName{
    if (![UISegmentedControl conformsToProtocol:@protocol(UIAppearance)])
        return;
    
    UIImage*    imageNN =   [UIImage imageNamed:[imageName  stringByAppendingString:@"_nn"]];
    UIImage*    imageNS =   [UIImage imageNamed:[imageName  stringByAppendingString:@"_ns"]];
    UIImage*    imageSN =   [UIImage imageNamed:[imageName  stringByAppendingString:@"_sn"]];
    UIImage*    imageSS =   [UIImage imageNamed:[imageName  stringByAppendingString:@"_ss"]];
    
    [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageNN
                                                                                forLeftSegmentState:UIControlStateNormal
                                                                                  rightSegmentState:UIControlStateNormal
                                                                                         barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageNS
                                                                                forLeftSegmentState:UIControlStateNormal
                                                                                  rightSegmentState:UIControlStateSelected
                                                                                         barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageNS
                                                                                forLeftSegmentState:UIControlStateNormal
                                                                                  rightSegmentState:UIControlStateHighlighted
                                                                                         barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageSN
                                                                                forLeftSegmentState:UIControlStateSelected
                                                                                  rightSegmentState:UIControlStateNormal
                                                                                         barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageSN
                                                                                forLeftSegmentState:UIControlStateHighlighted
                                                                                  rightSegmentState:UIControlStateNormal
                                                                                         barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageSS
                                                                                forLeftSegmentState:UIControlStateSelected
                                                                                  rightSegmentState:UIControlStateHighlighted
                                                                                         barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageSS
                                                                                forLeftSegmentState:UIControlStateHighlighted
                                                                                  rightSegmentState:UIControlStateSelected
                                                                                         barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageSS
                                                                                forLeftSegmentState:UIControlStateHighlighted
                                                                                  rightSegmentState:UIControlStateHighlighted
                                                                                         barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageSS
                                                                                forLeftSegmentState:UIControlStateSelected
                                                                                  rightSegmentState:UIControlStateSelected
                                                                                         barMetrics:UIBarMetricsDefault];
    
    if (IS_PHONE()){
        imageNN =   [UIImage imageNamed:[imageName  stringByAppendingString:@"_nn~L"]];
        imageNS =   [UIImage imageNamed:[imageName  stringByAppendingString:@"_ns~L"]];
        imageSN =   [UIImage imageNamed:[imageName  stringByAppendingString:@"_sn~L"]];
        imageSS =   [UIImage imageNamed:[imageName  stringByAppendingString:@"_ss~L"]];
        
        [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageNN
                                                                                    forLeftSegmentState:UIControlStateNormal
                                                                                      rightSegmentState:UIControlStateNormal
                                                                                             barMetrics:UIBarMetricsLandscapePhone];
        
        [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageNS
                                                                                    forLeftSegmentState:UIControlStateNormal
                                                                                      rightSegmentState:UIControlStateSelected
                                                                                             barMetrics:UIBarMetricsLandscapePhone];
        [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageNS
                                                                                    forLeftSegmentState:UIControlStateNormal
                                                                                      rightSegmentState:UIControlStateHighlighted
                                                                                             barMetrics:UIBarMetricsLandscapePhone];
        
        [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageSN
                                                                                    forLeftSegmentState:UIControlStateSelected
                                                                                      rightSegmentState:UIControlStateNormal
                                                                                             barMetrics:UIBarMetricsLandscapePhone];
        [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageSN
                                                                                    forLeftSegmentState:UIControlStateHighlighted
                                                                                      rightSegmentState:UIControlStateNormal
                                                                                             barMetrics:UIBarMetricsLandscapePhone];
        
        [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageSS
                                                                                    forLeftSegmentState:UIControlStateSelected
                                                                                      rightSegmentState:UIControlStateHighlighted
                                                                                             barMetrics:UIBarMetricsLandscapePhone];
        [[UISegmentedControl    appearanceWhenContainedIn:[UINavigationBar class], nil] setDividerImage:imageSS
                                                                                    forLeftSegmentState:UIControlStateHighlighted
                                                                                      rightSegmentState:UIControlStateSelected
                                                                                             barMetrics:UIBarMetricsLandscapePhone];
    }
}

@end
