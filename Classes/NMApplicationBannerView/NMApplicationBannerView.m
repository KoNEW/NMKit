//
//  NMApplicationBannerView.m
//  iCollection
//
//  Created by Mephi Skib on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NMApplicationBannerView.h"
#import "NMKitDefines.h"

#define NM_APPLICATION_BANNER_DEFAULT_HEIGHT        20.0
#define NM_APPLICATION_BANNER_DEFAULT_DURATION      5.0
#define NM_APPLICATION_BANNER_ANIMATION_DURATION    1.0

@interface NMApplicationBannerView (InternalMethods)

-   (void)  didTimerFire;
-   (void)  didChangeStatusBarFrame:(NSNotification*)notification;
-   (void)  rotateToStatusBarFrame:(NSValue*)statusBarFrame;
-   (void)  resizeSubviews;

@end

@implementation NMApplicationBannerView

static  NMApplicationBannerView*    sharedBannerView;

@synthesize imageView       =   _imageView,
            textLabel       =   _textLabel,
            duration        =   _duration,
            backgroundView  =   _backgroundView;

-   (id)    init {
    
    self    =   [self   initWithFrame:CGRectMake(0.0, 0.0, 0.0, NM_APPLICATION_BANNER_DEFAULT_HEIGHT)];
    if (self) {
    
    }
    return  self;
}

-   (id)    initWithFrame:(CGRect)frame {
    
    self    =   [super  initWithFrame:frame];
    if (self) {
        
        
        CGRect  statusBarRect   =   [UIApplication  sharedApplication].statusBarFrame;
        [self   setFrame:statusBarRect];
        [self   setWindowLevel:UIWindowLevelStatusBar + 1.0];
        [self   setHidden:YES];
        
        _timer          =   nil;
        
        _imageView      =   [[UIImageView   alloc]  initWithFrame:CGRectZero];

        _textLabel  =   [[UILabel       alloc]  initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        _backgroundView =   nil;
        [self   setDuration:NM_APPLICATION_BANNER_DEFAULT_DURATION];
        
        [self   addSubview:_imageView];
        [self   addSubview:_textLabel];
        
        [self   setBackgroundColor:[UIColor blackColor]];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setTextColor:[UIColor   lightGrayColor]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didChangeStatusBarFrame:)
													 name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

-   (id)    initWithImage:(UIImage *)image text:(NSString *)text duration:(NSTimeInterval)duration {
    
    self    =   [self   init];
    if (self) {
        
        [_imageView setImage:image];
        [_textLabel setText:text];
        [self       setDuration:duration];
    }
    return self;
}

+   (id)    bannerWithImage:(UIImage *)image text:(NSString *)text duration:(NSTimeInterval)duration {
    
    NMApplicationBannerView*    banner  =   [[NMApplicationBannerView   alloc]  initWithImage:image text:text duration:duration];
    return banner;
}

+   (NMApplicationBannerView*)  sharedBannerView {
    
    @synchronized   (self) {
        if (sharedBannerView    ==  nil) {
            sharedBannerView    =   [[self  alloc]  init];
        }
        return sharedBannerView;
    }
    return nil;
}

-   (void)  setBackgroundView:(UIView *)backgroundView {
    
    [_backgroundView    removeFromSuperview];
    
    _backgroundView =   backgroundView;
    
    if (_backgroundView) {
        
        [_backgroundView    setFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        [self   insertSubview:_backgroundView belowSubview:_imageView];
    }
}

-   (void)  show {
    
    if (_timer) {
        [_timer invalidate];
        _timer  =   nil;
    }
    
    [self   setHidden:YES];
    
    [self   makeKeyAndVisible];
    [self   rotateToStatusBarFrame:[NSValue valueWithCGRect:[UIApplication  sharedApplication].statusBarFrame]];
    
    _timer   =   [NSTimer    scheduledTimerWithTimeInterval:_duration target:self selector:@selector(didTimerFire) userInfo:nil repeats:NO];
}

#pragma mark    -   Internal methods

-   (void)  didTimerFire {
    
    _timer  =   nil;
    
    [self   setHidden:YES];
}

-   (void)  didChangeStatusBarFrame:(NSNotification *)notification {
        
    [self performSelector:@selector(rotateToStatusBarFrame:) withObject:[notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey] afterDelay:0];
}

-   (void)  rotateToStatusBarFrame:(NSValue*)statusBarFrame {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat pi = (CGFloat)M_PI;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(void) {
                         if (orientation == UIDeviceOrientationPortrait) {
                             
                             self.transform = CGAffineTransformIdentity;
                         }
                         else if (orientation == UIDeviceOrientationLandscapeLeft) {
                             
                             self.transform = CGAffineTransformMakeRotation(pi * (90.f) / 180.0f);
                         } 
                         else if (orientation == UIDeviceOrientationLandscapeRight) {
                             
                             self.transform = CGAffineTransformMakeRotation(pi * (-90.f) / 180.0f);
                         } 
                         else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
                             
                             self.transform = CGAffineTransformMakeRotation(pi);
                         }
                         
                         [self   setFrame:[UIApplication   sharedApplication].statusBarFrame];
                         [self   resizeSubviews];
                     }
                     completion:^(BOOL  finished) {
                         
                     }];
    
}

-   (void)  resizeSubviews {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        if (_imageView.image) {
            [_imageView setFrame:CGRectMake(1.0, 1.0, NM_APPLICATION_BANNER_DEFAULT_HEIGHT - 2.0, NM_APPLICATION_BANNER_DEFAULT_HEIGHT - 2.0)];
            [_textLabel setFrame:CGRectMake(NM_APPLICATION_BANNER_DEFAULT_HEIGHT + 4.0, 0.0, self.frame.size.width - NM_APPLICATION_BANNER_DEFAULT_HEIGHT - 4.0, self.frame.size.height)];
        } 
        else {
            [_imageView setFrame:CGRectZero];
            [_textLabel setFrame:CGRectMake(4.0, 0.0, self.frame.size.width - 4.0, self.frame.size.height)];
        }
	}
    else if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        
        if (_imageView.image) {
            [_imageView setFrame:CGRectMake(1.0, 1.0, NM_APPLICATION_BANNER_DEFAULT_HEIGHT - 2.0, NM_APPLICATION_BANNER_DEFAULT_HEIGHT - 2.0)];
            [_textLabel setFrame:CGRectMake(NM_APPLICATION_BANNER_DEFAULT_HEIGHT + 4.0, 0.0, self.frame.size.height - NM_APPLICATION_BANNER_DEFAULT_HEIGHT - 4.0, self.frame.size.width)];
        }
        else {
            [_imageView setFrame:CGRectZero];
            [_textLabel setFrame:CGRectMake(4.0, 0.0, self.frame.size.height - 4.0, self.frame.size.width)];
        }
	} 
}


@end
