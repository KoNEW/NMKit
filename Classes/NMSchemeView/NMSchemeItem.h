//
//  NMSchemeItem.h
//  Scheme
//
//  Created by Vladimir Konev on 4/28/13.
//  Copyright (c) 2013 Novilab Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

extern  const   CGFloat kNMSchemeItemDefaultStrokeWidth;

@interface NMSchemeItem : UIView

    //GEOMETRY
@property(nonatomic, assign)    CGPathRef   path;
@property(nonatomic, copy)      UIColor*    fillColor;
@property(nonatomic, copy)      UIColor*    selectedFillColor;
@property(nonatomic, copy)      UIColor*    strokeColor;
@property(nonatomic, copy)      UIColor*    selectedStrokeColor;

    //TITLE
@property(nonatomic, copy)      UIFont*     titleFont;
@property(nonatomic, copy)      NSString*   titleText;
@property(nonatomic, copy)      UIColor*    titleColor;
@property(nonatomic, copy)      UIColor*    selectedTitleColor;
@property(nonatomic, assign)    CGPoint     titlePoint;
@property(nonatomic, assign)    CGFloat     titleAngle;

    //ICON
@property(nonatomic, strong)    UIImage*    icon;

    //STATE
@property(nonatomic, assign)    BOOL        selected;
@property(nonatomic, assign)    BOOL        selectable;

@property(nonatomic, assign)    BOOL        searchSelected;


-   (CGPathRef) getTransformedPath;//путь, используемый при расчётах

@end


@interface UIColor (NMSchemeItemColors)
    //ATTENTION COLORS IS SHARED FOR PERFORMANCE REASON
+   (UIColor*)  schemeItemFillColor;
+   (UIColor*)  schemeItemSelectedFillColor;
+   (UIColor*)  schemeItemStrokeColor;
+   (UIColor*)  schemeItemSelectedStrokeColor;
+   (UIColor*)  schemeItemTitleColor;
+   (UIColor*)  schemeItemTitleSelectedColor;

+   (UIColor*)  schemeItemLayerFillColor;
+   (UIColor*)  schemeItemLayerStrokeColor;

@end


