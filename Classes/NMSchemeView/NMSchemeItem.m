//
//  NMSchemeItem.m
//  Scheme
//
//  Created by Vladimir Konev on 4/28/13.
//  Copyright (c) 2013 Novilab Mobile. All rights reserved.
//

#import "NMSchemeItem.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

    //SCHEME ITEM LAYER
const   CGFloat kNMSchemeItemDefaultStrokeWidth =   2.0f;

    //SCHEME ITEM
@interface NMSchemeItem (){
        //OVERRIDES FOR PERFORMANCE REASON
    CGColorRef      _fillColor;
    CGColorRef      _selectedFillColor;
    CGColorRef      _strokeColor;
    CGColorRef      _selectedStrokeColor;
    
    CAShapeLayer*   _layer;
    
    CATextLayer*    _titleLayer;
    
    BOOL            _angleToken;
}

@property(nonatomic, assign)    CGFloat     strokeWidth;

-   (void)  redraw;
-   (void)  relayoutTitle;

@end

@implementation NMSchemeItem

+   (Class) layerClass{
    return [CAShapeLayer    class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _layer  =   (CAShapeLayer*)self.layer;
        _layer.lineWidth    =   kNMSchemeItemDefaultStrokeWidth;
        
        self.fillColor          =   [UIColor    schemeItemFillColor];
        self.selectedFillColor  =   [UIColor    schemeItemSelectedFillColor];
        self.strokeColor        =   [UIColor    schemeItemStrokeColor];
        self.selectedStrokeColor=   [UIColor    schemeItemSelectedStrokeColor];
        
            //COLORS
        [self   setBackgroundColor:[UIColor     clearColor]];
        
            //SELECTABLES
        _selectable         =   YES;
        
            //TITLE LAYER
        _titlePoint                 =   CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        _angleToken                 =   NO;
        [self   setTitleAngle:0.0f];
//        _titleAngle                 =   0.0f;

    }
    
    return self;
}

-   (id)    init{
    return [self    initWithFrame:CGRectZero];
}

#pragma mark    -   Geometry and Drawing
-   (void)  redraw
{
    _layer.fillColor            =   _selected   ?   _selectedFillColor  :   _fillColor;
    _layer.strokeColor          =   _selected   ?   _selectedStrokeColor:   _strokeColor;
    _titleLayer.foregroundColor =   _selected   ?   _selectedTitleColor.CGColor :   _titleColor.CGColor;
    
    if (_searchSelected && !_selected)//специальное выделение при поиске
    {
        _layer.fillColor = _selectedFillColor;
        _layer.strokeColor = _selectedStrokeColor;
        _titleLayer.foregroundColor = _selectedTitleColor.CGColor;
    }
    
//    [self   relayoutTitle];//закомменчено до меня
}

-   (void)  relayoutTitle
{
    
    if (_titleLayer ==  nil){
        _titleLayer =   [CATextLayer layer];
        _titleLayer.backgroundColor =   [UIColor clearColor].CGColor;
        _titleLayer.alignmentMode   =   kCAAlignmentCenter;
        _titleLayer.wrapped         =   NO;
        [self.layer addSublayer:_titleLayer];
    }
    
    if (!_selected)
        _titleLayer.foregroundColor =   _titleColor.CGColor;
    else
        _titleLayer.foregroundColor =   _selectedTitleColor.CGColor;
    
    _titleLayer.string  =   _titleText;
    
    if (_titleFont  !=  nil){
        CTFontRef   font    =   CTFontCreateWithName((__bridge CFStringRef)_titleFont.fontName, _titleFont.pointSize, NULL);
        _titleLayer.font    =   font;
        _titleLayer.fontSize=   _titleFont.pointSize;
        CFRelease(font);
        
        CGFloat height  =   _titleFont.lineHeight;//[NSString oneLineTextHeightWithFont:_titleFont];
        CGFloat width;//   =   [_titleText sizeWithFont:_titleFont].width;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  _titleFont, NSFontAttributeName,
                                                  nil];
            
            CGSize notExactlySize = [_titleText boundingRectWithSize:CGSizeMake(FLT_MAX, 200)
                                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                                    attributes:attributesDictionary
                                                                                       context:nil].size;
            width = notExactlySize.width;
        }
        else
        {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            width   =   [_titleText sizeWithFont:_titleFont].width;
#else
            width = [_titleText sizeWithAttributes:@{NSFontAttributeName : _titleFont}].width;
#endif
            
        }
        
        
        CGRect  titleFrame  =   CGRectMake(_titlePoint.x - width/2 - self.frame.origin.x,
                                           _titlePoint.y - height/2- self.frame.origin.y,
                                           width,
                                           height);
        _titleLayer.frame   =   titleFrame;
    }else
        _titleLayer.frame   =   CGRectZero;
    
}

-   (void)  drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CATransform3D       rt  =   CATransform3DMakeRotation(_titleAngle, 0, 0, 1);
    _titleLayer.transform   =   rt;
}

#pragma mark    -   Logic
-   (void)  setSelected:(BOOL)selected{
    if (selected    ==  _selected)
        return;
    
    if (selected    && !_selectable)
        return;
    
    _selected   =   selected;
    
    [self   redraw];
}

-   (void)  setSelectable:(BOOL)selectable{
    if (selectable  ==  _selectable)
        return;
    
    _selectable =   selectable;
    
    if (!_selectable)
        [self   setSelected:NO];
}

-   (void)  setSearchSelected:(BOOL)searchSelected
{
    if (searchSelected == _searchSelected) return;
    
    _searchSelected = searchSelected;
    
    [self redraw];
}

#pragma mark    -   Properties


-   (void)  dealloc{
    [self   setFillColor:nil];
    [self   setSelectedFillColor:nil];
    [self   setStrokeColor:nil];
    [self   setSelectedStrokeColor:nil];
    
    [self   removeFromSuperview];
}

    //PATH
-   (CGPathRef) path
{
    return _layer.path;
}

-   (CGPathRef) getTransformedPath//если возвращать созданный путь просто по запросу на наличие, то будет утечка, лучше разделить на два разных метода
{
    CGPoint origin          =   self.frame.origin;
    
    CGAffineTransform   t   =   CGAffineTransformMakeTranslation(origin.x, origin.y);
    
    CGPathRef   result      =   CGPathCreateCopyByTransformingPath(_layer.path, &t);
    
    //NSLog(@"path shift %f %f", origin.x, origin.y);
    
    return result;
}

-   (void)      setPath:(CGPathRef)path
{
    if (path)//избавились от бесконечных фреймов при отсутствии пути
    {
        CGPoint origin          =   CGPathGetPathBoundingBox(path).origin;
        
        CGAffineTransform   t   =   CGAffineTransformMakeTranslation(origin.x * -1, origin.y * -1);
        
        CGPathRef   internalPath=   CGPathCreateCopyByTransformingPath(path, &t);
        
        if (_layer.path)
        {
            CGPathRelease(_layer.path);//убираем утечки
            _layer.path = nil;
        }
        
        _layer.path             =   internalPath;
        
        [self       setFrame:CGPathGetPathBoundingBox(path)];
        [self       relayoutTitle];
    }
    else
    {
        if (_layer.path) CGPathRelease(_layer.path);//убираем утечки
        _layer.path             =   nil;
        
        [self       setFrame:CGRectZero];
        [self       relayoutTitle];
    }
    
}

    //FILL COLOR
-   (UIColor*)  fillColor{
    return _fillColor   ==  NULL    ?   nil :   [UIColor    colorWithCGColor:_fillColor];
}

-   (void)      setFillColor:(UIColor *)fillColor{
    if (_fillColor  !=  NULL)
        CGColorRelease(_fillColor);
    
    if (fillColor   !=  nil){
        _fillColor  =   fillColor.CGColor;
        CGColorRetain(_fillColor);
    }else
        _fillColor  =   NULL;
    
    [self   redraw];
}

    //SELECTED FILL COLOR
-   (UIColor*)  selectedFillColor{
    return _selectedFillColor   ==  NULL    ?   nil :   [UIColor colorWithCGColor:_selectedFillColor];
}

-   (void)      setSelectedFillColor:(UIColor *)selectedFillColor{
    if ( _selectedFillColor !=  NULL)
        CGColorRelease(_selectedFillColor);
    
    if (selectedFillColor   !=  nil){
        _selectedFillColor  =   selectedFillColor.CGColor;
        CGColorRetain(_selectedFillColor);
    }else
        _selectedFillColor  =   NULL;
    
    [self   redraw];
}

    //STROKE COLOR
-   (UIColor*)  strokeColor{
    return _strokeColor ==  NULL    ?   nil :   [UIColor    colorWithCGColor:_strokeColor];
}

-   (void)      setStrokeColor:(UIColor *)strokeColor{
    if (_strokeColor    !=  NULL)
        CGColorRelease(_strokeColor);
    
    if (strokeColor !=  nil){
        _strokeColor    =   strokeColor.CGColor;
        CGColorRetain(_strokeColor);
    }else
        _strokeColor    =   NULL;
    
    [self   redraw];
}

    //SELECTED STROKE COLOR
-   (UIColor*)  selectedStrokeColor{
    return _selectedStrokeColor ==  NULL    ?   nil :   [UIColor    colorWithCGColor:_selectedStrokeColor];
}

-   (void)      setSelectedStrokeColor:(UIColor *)selectedStrokeColor{
    if (_selectedStrokeColor    !=  NULL)
        CGColorRelease(_selectedStrokeColor);
    
    if (selectedStrokeColor !=  nil){
        _selectedStrokeColor    =   selectedStrokeColor.CGColor;
        CGColorRetain(_selectedStrokeColor);
    }else
        _selectedStrokeColor    =   NULL;
    
    [self   redraw];
}

    //TITLE COLOR
-   (void)      setTitleColor:(UIColor *)titleColor{
    if (_titleColor ==   titleColor)
        return;
    
    _titleColor =   titleColor;
    
//    [self   redraw];
    [self   relayoutTitle];
    [self   redraw];
}

    //SELECTED TITLE COLOR
-   (void)      setSelectedTitleColor:(UIColor *)selectedTitleColor{
    if (_selectedTitleColor ==   selectedTitleColor)
        return;
    
    _selectedTitleColor =   selectedTitleColor;
    
    [self   relayoutTitle];
    [self   redraw];
}

    //TITLE
-   (void)  setTitleText:(NSString *)titleText{
    if ([_titleText isEqualToString:titleText])
        return;
    
    _titleText  =   titleText;
    
    [self   relayoutTitle];
}

    //FONT
-   (void)      setTitleFont:(UIFont *)titleFont{
    if ([_titleFont isEqual:titleFont])
        return;
    
    _titleFont  =   titleFont;
    
    [self   relayoutTitle];
}

    //POINT
-   (void)  setTitlePoint:(CGPoint)titlePoint{
    if (CGPointEqualToPoint(_titlePoint, titlePoint))
        return;
    
    _titlePoint =   titlePoint;
    
    [self   relayoutTitle];
}

    //ANGLE
-   (void)  setTitleAngle:(CGFloat)titleAngle{
    if (_titleAngle ==  titleAngle)
        return;
    
//    _angleToken =   NO;
    _titleAngle =   titleAngle;
    
//    CATransform3D   rt  =   CATransform3DMakeRotation(_titleAngle, 0, 0, 1);
//    _titleLayer.transform   =   rt;
    
    [self   relayoutTitle];
}

@end


@implementation UIColor (NMSchemeItemColors)

+   (UIColor*)  schemeItemFillColor{
    static  UIColor*    st_sharedColor  =   nil;
    
    if (st_sharedColor  ==  nil)
        st_sharedColor  =   [UIColor    colorWithRed:50.0/255.0
                                               green:152.0/255.0
                                                blue:200.0/255.0
                                               alpha:1.0];
    
    return st_sharedColor;
}

+   (UIColor*)  schemeItemSelectedFillColor{
    static  UIColor*    st_sharedColor  =   nil;
    
    if (st_sharedColor  ==  nil)
        st_sharedColor  =   [UIColor    colorWithRed:255.0/255.0
                                               green:94.0/255.0
                                                blue:117.0/255.0
                                               alpha:1.0];
    
    return st_sharedColor;
}

+   (UIColor*)  schemeItemStrokeColor{
    static  UIColor*    st_sharedColor  =   nil;
    
    if (st_sharedColor  ==  nil)
        st_sharedColor  =   [UIColor    colorWithRed:7.0/255.0
                                               green:73.0/255.0
                                                blue:124.0/255.0
                                               alpha:1.0];
    
    return st_sharedColor;
}

+   (UIColor*)  schemeItemSelectedStrokeColor{
    static  UIColor*    st_sharedColor  =   nil;
    
    if (st_sharedColor  ==  nil)
        st_sharedColor  =   [UIColor    colorWithRed:124.0/255.0
                                               green:7.0/255.0
                                                blue:27.0/255.0
                                               alpha:1.0];
    
    return st_sharedColor;
}

+   (UIColor*)  schemeItemTitleColor{
    static  UIColor*    st_sharedColor  =   nil;
    
    if (st_sharedColor  ==  nil)
        st_sharedColor  =   [UIColor    colorWithRed:7.0/255.0
                                               green:73.0/255.0
                                                blue:124.0/255.0
                                               alpha:1.0];
    
    return st_sharedColor;
}

+   (UIColor*)  schemeItemTitleSelectedColor{
    static  UIColor*    st_sharedColor  =   nil;
    
    if (st_sharedColor  ==  nil)
        st_sharedColor  =   [UIColor    whiteColor];
    
    return st_sharedColor;
}

+   (UIColor*)  schemeItemLayerFillColor{
    static  UIColor*    st_sharedColor  =   nil;
    
    if (st_sharedColor  ==  nil)
        st_sharedColor  =   [UIColor    grayColor];
    
    return st_sharedColor;
}

+   (UIColor*)  schemeItemLayerStrokeColor{
    static  UIColor*    st_sharedColor  =   nil;
    
    if (st_sharedColor  ==  nil)
        st_sharedColor  =   [UIColor    darkGrayColor];
    
    return st_sharedColor;
}

@end

