//
//  NMCGHelps.m
//  Scheme
//
//  Created by Vladimir Konev on 5/4/13.
//  Copyright (c) 2013 Novilab Mobile. All rights reserved.
//

#import "NMCGHelps.h"


CGPoint NMViewsTopLeftPoint(NSArray* views){
    CGPoint result  =   CGPointZero;
    
    CGRect  fullFrame   =   NMViewsUnionFrame(views);
    if (!CGRectEqualToRect(fullFrame, CGRectZero))
        result  =   NMRectGetTopLeft(fullFrame);
    
    return result;
};

CGPoint NMViewsBottomRightPoint(NSArray* views){
    CGPoint result  =   CGPointZero;
    
    CGRect  fullFrame   =   NMViewsUnionFrame(views);
    if (!CGRectEqualToRect(fullFrame, CGRectZero))
        result  =   NMRectGetBottomRight(fullFrame);
    
    return result;
};

CGRect  NMViewsUnionFrame(NSArray* views){
    CGRect  result  =   CGRectZero;
    
    for (UIView* view in views){
        if (![view  isKindOfClass:[UIView   class]])
              continue;
        
        result  =   CGRectUnion(result, view.frame);
    }
    
    return result;
};

BOOL    NMPathContainsRect(CGPathRef path, const CGRect rect){
    BOOL    result  =   YES;
    
    if (!CGPathContainsPoint(path, NULL, NMRectGetTopLeft(rect), false))
        result  =   NO;
    else if (!CGPathContainsPoint(path, NULL, NMRectGetBottomLeft(rect), false))
        result  =   NO;
    else if (!CGPathContainsPoint(path, NULL, NMRectGetTopRight(rect), false))
        result  =   NO;
    else if (!CGPathContainsPoint(path, NULL, NMRectGetBottomRight(rect), false))
        result  =   NO;
    
    return result;
}


CGPoint NMRectGetTopLeft(const CGRect rect){
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
};

CGPoint NMRectGetBottomLeft(const CGRect rect){
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
};

CGPoint NMRectGetTopRight(const CGRect rect){
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
};

CGPoint NMRectGetBottomRight(const CGRect rect){
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
};

CGPoint NMRectGetCenter(const CGRect rect){
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
};
