//
//  UINavigationBar+NMKit_Extensions.m
//  VKMessenger
//
//  Created by Vladimir Konev on 3/20/12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

#import "UINavigationBar+NMKit_Extensions.h"
#import "NMKitDefines.h"


static  UIImage*    st_navigationBarBackgroundImagePortrait     =   nil;
static  UIImage*    st_navigationBarBackgroundImageLandscape    =   nil;

@implementation UINavigationBar (NMKit_Extensions)

+   (void)  setBackgroundImage:(UIImage *)backgroundImage
       forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
        st_navigationBarBackgroundImagePortrait =   backgroundImage;
    else
        st_navigationBarBackgroundImageLandscape=   backgroundImage;
    
    if ([UINavigationBar    conformsToProtocol:@protocol(UIAppearance)]){
        BOOL    isLandscapePhone    =   IS_PHONE()  &&  UIInterfaceOrientationIsLandscape(interfaceOrientation);
        
        [[UINavigationBar   appearance] setBackgroundImage:backgroundImage
                                             forBarMetrics:isLandscapePhone ?   UIBarMetricsLandscapePhone  :   UIBarMetricsDefault];
    }
}

-   (void)  drawRect:(CGRect)rect{
    BOOL    isLandscape =   UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]  statusBarOrientation]);
    UIImage*    image   =   isLandscape ?   st_navigationBarBackgroundImageLandscape    :   st_navigationBarBackgroundImagePortrait;
    
    if (image   !=  nil)
        [image  drawInRect:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    
    [super  drawRect:rect];
}




@end
