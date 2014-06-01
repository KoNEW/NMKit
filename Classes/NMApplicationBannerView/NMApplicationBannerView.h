//
//  NMApplicationBannerView.h
//  iCollection
//
//  Created by Mephi Skib on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMApplicationBannerView : UIWindow {
    UIImageView*    _imageView;
    UILabel*        _textLabel;
    UIView*         _backgroundView;
    NSTimeInterval  _duration;
    
    NSTimer*        _timer;
}

@property(nonatomic,    readonly)                       UIImageView*    imageView;
@property(nonatomic,    readonly)                       UILabel*        textLabel;
@property(nonatomic,    strong, setter = setBackgroundView:)    UIView*         backgroundView;
@property(nonatomic,    assign)                         NSTimeInterval  duration;

-   (id)    init;
-   (id)    initWithFrame:(CGRect)frame;
-   (id)    initWithImage:(UIImage*)image   text:(NSString*)text    duration:(NSTimeInterval)duration;
-   (void)  show;

+   (id)    bannerWithImage:(UIImage*)image text:(NSString*)text    duration:(NSTimeInterval)duration;
+   (id)    sharedBannerView;

@end
