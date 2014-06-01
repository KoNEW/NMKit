//
//  UIImage+NMKit_Extensions.m
//  NMKit
//
//  Created by Vladimir Konev on 12/3/11.
//  Copyright (c) 2011 Novilab Mobile. All rights reserved.
//

#import "UIImage+NMKit_Extensions.h"

@implementation UIImage (NMKit_Extensions)

CGSize    CGSizeScaleWithRate(CGSize  size,   CGFloat rate){
    return  CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(rate, rate));
}

CGSize    CGSizeScaleToSize(CGSize   size,   CGSize  targetSize){
    CGFloat rWidth  =   targetSize.width    /   size.width;
    CGFloat rHeight =   targetSize.height   /   size.height;
    
    CGFloat rate    =   MIN(rWidth, rHeight);
    
    return  CGSizeScaleWithRate(size, rate);
};

CGSize    CGSizeScaleToHeight(CGSize size,   CGFloat height){
    return  CGSizeScaleWithRate(size, height/size.height);
}
CGSize    CGSizeScaleToWidth(CGSize  size,   CGFloat width){
    return  CGSizeScaleWithRate(size, width / size.width);
}


-   (UIImage*)  scaledImageToSize:(CGSize)targetSize{
    CGFloat sWidth  =   self.size.width;
    CGFloat rWidth  =   targetSize.width    /   sWidth;
    CGFloat sHeight =   self.size.height;
    CGFloat rHeight =   targetSize.height   /   sHeight;
    
    CGFloat rate    =  MIN(rWidth, rHeight);
    
    return [self    scaledImageWithFactor:rate];
}

-   (UIImage*)  scaledImageToWidth:(CGFloat)width{
    return [self    scaledImageToSize:CGSizeScaleToWidth(self.size, width)];
}

-   (UIImage*)  scaledImageToHeight:(CGFloat)height{
    return [self    scaledImageToSize:CGSizeScaleToHeight(self.size, height)];
}

-   (UIImage*)  scaledImageWithFactor:(CGFloat)scaleFactor{
    CGSize  newSize =   CGSizeMake(self.size.width  *   scaleFactor,
                                   self.size.height *   scaleFactor);
    UIGraphicsBeginImageContext(newSize);
    [self   drawInRect:CGRectMake(0.0,
                                  0.0,
                                  newSize.width,
                                  newSize.height)];
    UIImage*    result  =   UIGraphicsGetImageFromCurrentImageContext();
    
    return result;
}

#pragma mark  - Colorization
-   (UIImage*)  colorizedImage:(UIColor *)color{
    if (![color isKindOfClass:[UIColor class]])
        return self;
    
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef    context =   UIGraphicsGetCurrentContext();
    
        //UNFLIP IMAGE
    CGContextTranslateCTM(context, 0.0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
        //DRAW COLORED BACKGROUND
    CGRect  fullRect;
    fullRect.size   =   self.size;
    fullRect.origin =   CGPointMake(0.0, 0.0);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextClipToMask(context, fullRect, self.CGImage);
    CGContextFillRect(context, fullRect);
    
        //DRAW IMAGE WITH MULTIPLY MODE
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextDrawImage(context, fullRect, self.CGImage);
    
        //GET RESULT
    UIImage*    result  =   UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}


@end
