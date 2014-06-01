//
//  UIBarButtonItem+NMKit_Extensions.m
//  VKMessenger
//
//  Created by Vladimir Konev on 3/20/12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

#import "UIBarButtonItem+NMKit_Extensions.h"

@implementation UIBarButtonItem (NMKit_Extensions)

+   (void)  setBackButtonBackgroundImages:(NSString *)imageName{
    if (![UIBarButtonItem   conformsToProtocol:@protocol(UIAppearance)])
        return;
    
    UIImage*    backButtonN =   [UIImage    imageNamed:imageName];
    UIImage*    backButtonH =   [UIImage    imageNamed:[imageName   stringByAppendingString:@"_h"]];

    [[UIBarButtonItem   appearance] setBackButtonBackgroundImage:backButtonN
                                                        forState:UIControlStateNormal
                                                      barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem   appearance] setBackButtonBackgroundImage:backButtonH
                                                        forState:UIControlStateHighlighted
                                                      barMetrics:UIBarMetricsDefault];
    
    if (IS_PHONE()){
        backButtonN =   [UIImage    imageNamed:[imageName   stringByAppendingString:@"~L"]];
        backButtonH =   [UIImage    imageNamed:[imageName   stringByAppendingString:@"_h~L"]];
        [[UIBarButtonItem   appearance] setBackButtonBackgroundImage:backButtonN
                                                            forState:UIControlStateNormal
                                                          barMetrics:UIBarMetricsLandscapePhone];
        [[UIBarButtonItem   appearance] setBackButtonBackgroundImage:backButtonH
                                                            forState:UIControlStateHighlighted
                                                          barMetrics:UIBarMetricsLandscapePhone];
    }
}

+   (void)  setButtonBackgroundImages:(NSString *)imageName{
    if (![UIBarButtonItem conformsToProtocol:@protocol(UIAppearance)])
        return;
    
    UIImage*    buttonN =   [UIImage    imageNamed:imageName];
    UIImage*    buttonH =   [UIImage    imageNamed:[imageName   stringByAppendingString:@"_h"]];
    
    [[UIBarButtonItem   appearance]  setBackgroundImage:buttonN
                                               forState:UIControlStateNormal
                                             barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem   appearance] setBackgroundImage:buttonH
                                              forState:UIControlStateHighlighted
                                            barMetrics:UIBarMetricsDefault];
    
    if (IS_PHONE()){
        buttonN =   [UIImage    imageNamed:[imageName   stringByAppendingString:@"~L"]];
        buttonH =   [UIImage    imageNamed:[imageName   stringByAppendingString:@"_h~L"]];
        [[UIBarButtonItem   appearance] setBackgroundImage:buttonN
                                                  forState:UIControlStateNormal
                                                barMetrics:UIBarMetricsLandscapePhone];
        
        [[UIBarButtonItem   appearance] setBackgroundImage:buttonH
                                                  forState:UIControlStateHighlighted
                                                barMetrics:UIBarMetricsLandscapePhone];
    }
}

@end
