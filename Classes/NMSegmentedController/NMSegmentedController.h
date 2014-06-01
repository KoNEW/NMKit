//
//  NMSegmentedController.h
//  Test
//
//  Created by Vladimir Konev on 4/20/13.
//  Copyright (c) 2013 Novilab Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, NMSegmentedControllerTransitionStyle){
    NMSegmentedControllerTransitionStyleNone,
    
    NMSegmentedControllerTransitionStyleSlideHorizontal,
    NMSegmentedControllerTransitionStyleSlideVertical,
    
    NMSegmentedControllerTransitionStyleFlipHorizontal,
    NMSegmentedControllerTransitionStyleFlipVertical,
    
    NMSegmentedControllerTransitionStyleCurl,
    
    NMSegmentedControllerTransitionStyleDissolve
};

@interface NMSegmentedController : UIViewController

@property(nonatomic, readonly)  UISegmentedControl*                     segmentedControl;
@property(nonatomic, strong)    NSArray*                                viewControllers;
@property(nonatomic, assign)    NMSegmentedControllerTransitionStyle    segmentsTransitionStyle;

-   (void)  setViewControllersByStoryboardIdentifiers:(NSArray*)identifiers __attribute__((availability(ios, introduced=5.0)));

@end


@interface UIViewController (NMSegmentedControllerItem)

@property(nonatomic, copy)      NSString*               segmentedControllerTitle;
@property(nonatomic, strong)    UIImage*                segmentedControllerIcon;
@property(nonatomic, readonly)  NMSegmentedController*  segmentedController;

@end

@interface UIColor (NMSegmentedControllerColors)

+   (UIColor*)  segmentedControllerBackgroundColor __attribute__((const));

@end