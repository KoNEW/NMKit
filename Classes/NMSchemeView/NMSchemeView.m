//
//  NMSchemeView.m
//  Scheme
//
//  Created by Vladimir Konev on 4/27/13.
//  Copyright (c) 2013 Novilab Mobile. All rights reserved.
//

#import "NMSchemeView.h"
#import "NMSchemeHeaderView.h"

const   NSInteger   kNMSchemeViewCurrentNoLayer =   -1;

@interface NMSchemeView () <NMSchemeHeaderViewDelegate, UIScrollViewDelegate>
{
    NMSchemeHeaderView* _headerView;
    
    UIScrollView*       _scrollView;
    UIView*             _container;
    
    NSMutableArray*     _layers;
}

@property(nonatomic, strong)    UILabel*    debugLabel;
@property(nonatomic, strong)    UILabel*    infoLabel;

@property(nonatomic, assign)    NSInteger   currentLayerIndex;
 
    //Method required to correct work with initWithCoder:(used when loaded from storyboard) and initWithFrame: (used when loaded programmatically typical) initializers
-   (void)  construct;

-   (void)  refreshContent;
-   (void)  refreshZoomRates;

-   (void)  centerScrollViewContents;

-   (void)  commonTapGestureHandler:(UITapGestureRecognizer*)commonTapRecognizer;//для сокрытия клавиатуры
-   (void)  tapGestureHandler:(UITapGestureRecognizer*)tapRecognizer;
-   (void)  doubleTapGestureHandler:(UITapGestureRecognizer*)doubleTapRecognizer;
//-   (void)  rotationGestureHandler:(UIRotationGestureRecognizer*)rotationRecognizer;
//- (void)rotateGestureHandler:(UIRotationGestureRecognizer*)rotateRecognizer;
//- (void)pinchGestureHandler:(UIPinchGestureRecognizer*)pinchRecognizer;

-   (void)  reloadDataForLayer:(NSUInteger)layerIndex
                 shouldRefresh:(BOOL)shouldRefresh;

-   (void)  reloadDataForLayer:(NSUInteger)layerIndex
                   andSubLayer:(NSUInteger)subLayerIndex
                 shouldRefresh:(BOOL)shouldRefresh;

-   (NSArray*)      selectableItems;
-   (NMSchemeItem*) selectedItem;
-   (NSIndexPath*)  indexPathForItem:(NMSchemeItem*)item;

@end

@implementation NMSchemeView

#pragma mark    -   LifeCycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self   construct];
    }
    
    return self;
}

-   (instancetype)  initWithCoder:(NSCoder *)aDecoder
{
    self    =   [super  initWithCoder:aDecoder];
    
    if (self) {
        [self   construct];
    }
    
    return self;
}

-   (void)  construct
{
        //BACKGROUND COLOR
    [self   setBackgroundColor:[UIColor whiteColor]];
    
        //SHOW HEADER
    _showHeaderView =   YES;
    
        //PREPARE HEADER
    _headerView =   [[NMSchemeHeaderView    alloc]  initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, kNMSchemeHeaderDefaultHeight)];
    [_headerView    setBackgroundColor:[UIColor clearColor]];
    [_headerView    setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
    [_headerView    setDelegate:self];
    [self   addSubview:_headerView];
    
        //INTERNAL SCROLL VIEW CONTAINER
    _scrollView    =   [[UIScrollView  alloc]  initWithFrame:CGRectMake(0.0,
                                                                         _headerView.frame.size.height,
                                                                         self.frame.size.width,
                                                                         self.frame.size.height - _headerView.frame.size.height)];
    [_scrollView    setMinimumZoomScale:1.0f];
    [_scrollView    setMaximumZoomScale:1.0f];
    [_scrollView    setScrollEnabled:YES];
    [_scrollView    setShowsHorizontalScrollIndicator:NO];
    [_scrollView    setShowsVerticalScrollIndicator:NO];
    [_scrollView    setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [_scrollView    setDelegate:self];
    [self           addSubview:_scrollView];
    
        //REAL CONTENT CONTAINER
    _container   =   [[UIView    alloc]  initWithFrame:CGRectMake(0.0, 0.0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    [_container setBackgroundColor:[UIColor whiteColor]];
    [_scrollView    addSubview:_container];
    
        //ADD GESTURE RECOGNIZER
    //скроем клавиатуру при клике
    UITapGestureRecognizer* commonTapRecognizer   =   [[UITapGestureRecognizer    alloc]  initWithTarget:self
                                                                                            action:@selector(commonTapGestureHandler:)];
    [commonTapRecognizer  setNumberOfTapsRequired:1];
    [commonTapRecognizer setCancelsTouchesInView:NO];
    [self addGestureRecognizer:commonTapRecognizer];
    
    
    UITapGestureRecognizer* tapRecognizer   =   [[UITapGestureRecognizer    alloc]  initWithTarget:self
                                                                                            action:@selector(tapGestureHandler:)];
    [tapRecognizer  setNumberOfTapsRequired:1];
    [_container addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer* doubleTapRecognizer =   [[UITapGestureRecognizer    alloc]  initWithTarget:self
                                                                                                action:@selector(doubleTapGestureHandler:)];
    [doubleTapRecognizer    setNumberOfTapsRequired:2];
    [_container addGestureRecognizer:doubleTapRecognizer];
    /*
    UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGestureHandler:)];
    [_scrollView addGestureRecognizer:rotateRecognizer];
    */
    /*
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandler:)];
    [_container addGestureRecognizer:pinchRecognizer];
    */
//    
//    UIRotationGestureRecognizer*    rotationRecognizer  =   [[UIRotationGestureRecognizer   alloc]  initWithTarget:self
//                                                                                                            action:@selector(rotationGestureHandler:)];
//    [_container addGestureRecognizer:rotationRecognizer];
    
        //PREINIT LAYERS
    _layers =   [[NSMutableArray    alloc]  init];
    
    _infoLabel  =   [[UILabel   alloc]  initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [_infoLabel setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_infoLabel setTextAlignment:NSTextAlignmentCenter];
    [_infoLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_infoLabel setTextColor:[UIColor   grayColor]];
    [_infoLabel setBackgroundColor:[UIColor clearColor]];
    [_infoLabel setText:@"Нет данных"];
//    [_infoLabel setHidden:YES];
    [self       addSubview:_infoLabel];
    
        //DEBUG LABEL
//    _debugLabel                 =   [[UILabel   alloc]  initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 40.0)];
//    _debugLabel.backgroundColor =   [UIColor    clearColor];
//    _debugLabel.textColor       =   [UIColor    purpleColor];
//    [self       addSubview:_debugLabel];
    
    
    [self bringSubviewToFront:_headerView];//нужно, чтобы он не перекрывался при вращении scrollView
    
}

-   (void)  setShowHeaderView:(BOOL)showHeaderView
{
    return  [self   setShowHeaderView:showHeaderView
                            animated:NO];
}

-   (void)  drawRect:(CGRect)rect
{
    NSDate* now =   [NSDate date];
    [super  drawRect:rect];
    
    NSLog(@"    SCROLL DRAW: %f", [[NSDate date] timeIntervalSinceDate:now]);
}

-   (void)  setShowHeaderView:(BOOL)showHeaderView
                    animated:(BOOL)animated
{
    if (showHeaderView  ==  _showHeaderView)
        return;
    
    _showHeaderView =   showHeaderView;
    
    CGRect  headerRect;
    CGRect  contentRect;
    if (_showHeaderView)
    {
        headerRect  =   CGRectMake(0.0,
                                   0.0,
                                   self.frame.size.width,
                                   _headerView.frame.size.height);
        contentRect =   CGRectMake(0.0,
                                   _headerView.frame.size.height,
                                   self.frame.size.width,
                                   self.frame.size.height - _headerView.frame.size.height);
    }
    else
    {
        headerRect  =   CGRectMake(0.0,
                                   -1 * _headerView.frame.size.height,
                                   self.frame.size.width,
                                   _headerView.frame.size.height);
        contentRect =   CGRectMake(0.0,
                                   0.0,
                                   self.frame.size.width,
                                   self.frame.size.height);
    }
    
    CGFloat duration    =   animated    ?   0.3f : 0.0f;
    
    [UIView animateWithDuration:duration
                     animations:^{
                         _headerView.frame  =   headerRect;
                         _scrollView.frame =   contentRect;
                         [_headerView   setHidden:!_showHeaderView];
                     }];
}


-   (void)  setFrame:(CGRect)frame
{
    [super  setFrame:frame];
    [self   centerScrollViewContents];
}

#pragma mark    -   Filling Data
-   (void)  setDataSource:(id<NMSchemeViewDataSource>)dataSource
{
    _dataSource =   dataSource;
    
    [self   reloadData];
}

-   (void)  reloadData
{
    if (![_dataSource    conformsToProtocol:@protocol(NMSchemeViewDataSource)])
    {
        NSLog(@"NMSchemeView doesn't provided with data source");
        return;
    }
    
    [_layers    removeAllObjects];
    _currentLayerIndex  =   kNMSchemeViewCurrentNoLayer;
    
    NSInteger   layersCount =   [_dataSource    numberOfLayersInSchemeView:self];
    
    if (layersCount <=  0)
        return;
    
    for (int i = 0; i < layersCount; i++)
    {
        NSMutableArray* layer    =   [[NSMutableArray    alloc]  init];
        
        [_layers    addObject:layer];
        
        [self   reloadDataForLayer:i
                     shouldRefresh:NO];
    }
    
    [self   setCurrentLayerIndex:0];
}

-   (void)  reloadDataForLayer:(NSUInteger)layerIndex
{
    [self   reloadDataForLayer:layerIndex
                 shouldRefresh:YES];
}

-   (void)  reloadDataForLayer:(NSUInteger)layerIndex
                 shouldRefresh:(BOOL)shouldRefresh
{
    if (![_dataSource    conformsToProtocol:@protocol(NMSchemeViewDataSource)])
    {
        NSLog(@"NMSchemeView doesn't provided with data source");
        return;
    }
    
    if (layerIndex   >   _layers.count - 1)
    {
        NSLog(@"Invalid layer index. Data would not be reloaded");
        return;
    }
    
    NSMutableArray* layer   =   _layers[layerIndex];
    
    [layer  removeAllObjects];
    
    NSUInteger  sublayersCount  =   [_dataSource    schemeView:self
                                      numberOfSublayersInLayer:layerIndex];
    
    for (NSUInteger i = 0; i < sublayersCount; i++)
    {
        NSMutableArray* sublayer    =   [[NSMutableArray    alloc]  init];
        
        [layer  addObject:sublayer];
        
        [self   reloadDataForLayer:layerIndex
                       andSubLayer:i
                     shouldRefresh:NO];
    }
    
    if (shouldRefresh)
        [self   refreshContent];
}

-   (void)  reloadDataForLayer:(NSUInteger)layerIndex
                   andSubLayer:(NSUInteger)subLayerIndex
{
    return  [self   reloadDataForLayer:layerIndex
                           andSubLayer:subLayerIndex
                         shouldRefresh:YES];
}

-   (void)  reloadDataForLayer:(NSUInteger)layerIndex
                   andSubLayer:(NSUInteger)subLayerIndex
                 shouldRefresh:(BOOL)shouldRefresh
{
    if (![_dataSource   conformsToProtocol:@protocol(NMSchemeViewDataSource)]){
        NSLog(@"NMSchemeView doesn't provided with data source");
        return;
    }
    
    if (layerIndex > _layers.count - 1){
        NSLog(@"Invalid layer index. Data would not be reloaded");
        return;
    }
    
    NSMutableArray* layer   =   _layers[layerIndex];
    
    if (subLayerIndex   >   layer.count - 1){
        NSLog(@"Invalid sublayer index. Data would not be reloaded");
        return;
    }
    
    NSMutableArray* sublayer    =   layer[subLayerIndex];
    [sublayer   removeAllObjects];
    NSUInteger  itemsCount      =   [_dataSource    schemeView:self
                                      numberOfItemsAtIndexPath:[NSIndexPath indexPathWithLayer:layerIndex
                                                                                   andSubLayer:subLayerIndex]];
    for (NSUInteger i = 0; i < itemsCount; i++)
    {
            //SHOULD APPEND REAL ITEM HERE
        NMSchemeItem*   item    =   [_dataSource    schemeView:self
                                               itemAtIndexPath:[NSIndexPath indexPathWithLayer:layerIndex
                                                                                   andSubLayer:subLayerIndex
                                                                                  andItemIndex:i]];
        
        if ([item   isKindOfClass:[NMSchemeItem class]])
            [sublayer   addObject:item];
    }
    
    if (shouldRefresh)
        [self   refreshContent];
}

#pragma mark    -   Logic Manipulations
-   (void)  refreshContent
{
        //CLEAR OLD VIEWS
    for (UIView* childView in _container.subviews)
        [childView  removeFromSuperview];
    [_scrollView    setZoomScale:1.0f];
    
        //VALIDATION
    if (_currentLayerIndex  ==  kNMSchemeViewCurrentNoLayer)
        return;
    
    if (_currentLayerIndex  >   _layers.count - 1){
        NSLog(@"Invalid current layer index. Scroll view will not be filled with any data");
        return;
    }
    
        //CALCULATE SIZE
    NSMutableArray* subviews    =   [[NSMutableArray    alloc]  init];
    NSMutableArray* curLayer    =   [_layers    objectAtIndex:_currentLayerIndex];
    for (NSUInteger subLayerIndex = 0; subLayerIndex < curLayer.count; subLayerIndex++)
    {
        NSMutableArray* subLayer    =   [curLayer objectAtIndex:subLayerIndex];
        
        for (NSUInteger itemIndex = 0; itemIndex < subLayer.count; itemIndex++){
            NMSchemeItem* item = [subLayer  objectAtIndex:itemIndex];
            
            [subviews   addObject:item];
        }
    }
    
    //CGRect fullFrame    =   NMViewsUnionFrame(subviews);
    CGRect fullFrame = [self viewsUnionFrame:subviews];//свой вариант, ограничивающий размеры схемы и её элементов перед их добавлением в неё
    
//    _debugLabel.text    =   [NSString   stringWithFormat:@"SIZE: %@", NSStringFromCGSize(fullFrame.size)];
    
    _container.frame    =   CGRectMake(0.0,
                                       0.0,
                                       fullFrame.size.width,
                                       fullFrame.size.height);
    for (UIView* child in subviews)
        [_container    addSubview:child];

        //FLUSH SCROLL VIEW
    [self           refreshZoomRates];
    [_scrollView    setContentSize:_container.frame.size];
    [_scrollView    setZoomScale:_scrollView.minimumZoomScale];
    
    if (CGRectIsEmpty(fullFrame))
        [_infoLabel setHidden:NO];//NOTHING TO DRAW
    else
        [_infoLabel setHidden:YES];
        
}

#define kMaxSchemeWidth 3000
#define kMaxSchemeHeight 3000

-(CGRect)viewsUnionFrame:(NSArray*)someViews//найдём прямоугольник, вмещающий все subviews и отмасштабируем при необходимости
{
    if (someViews.count > 0)
    {
        float minLeft = FLT_MAX;
        float maxRight = FLT_MIN;
        float minTop = FLT_MAX;
        float maxBottom = FLT_MIN;
        
        for (NMSchemeItem *someItem in someViews)
        {
            //CGRect frame = CGPathGetPathBoundingBox(someview.path);
            //NSLog(@"%@", NSStringFromCGRect(someview.frame));
            
            if (someItem.frame.origin.x < minLeft) minLeft = someItem.frame.origin.x;
            if (someItem.frame.origin.y < minTop) minTop = someItem.frame.origin.y;
            
            if (someItem.frame.origin.x + someItem.frame.size.width > maxRight) maxRight = someItem.frame.origin.x + someItem.frame.size.width;
            if (someItem.frame.origin.y + someItem.frame.size.height > maxBottom) maxBottom = someItem.frame.origin.y + someItem.frame.size.height;
        }
        
        CGRect result = CGRectMake(0, 0, maxRight - minLeft, maxBottom - minTop);
        
        //NSLog(@"big frame %@", NSStringFromCGRect(result));
        
        //если получилось слишком большое поле - отмасштабируем его до определённых пределов
        float heightScale = kMaxSchemeHeight / result.size.height;
        float widthScale = kMaxSchemeWidth / result.size.width;
        float scaleFactor = MIN(heightScale, widthScale);
        if (scaleFactor < 1.0)
        {
            for (NMSchemeItem *someItem in someViews)
            {
                if (someItem.path)
                {
                    CGPathRef simplePath = [someItem getTransformedPath];
                    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:simplePath];
                    CGPathRelease(simplePath);
                    
                    CGAffineTransform tScale    =   CGAffineTransformMakeScale(scaleFactor, scaleFactor);
                    [path       applyTransform:tScale];
                    
                    [someItem   setTitlePoint:CGPointApplyAffineTransform(someItem.titlePoint, tScale)];
                    [someItem setTitleFont:[UIFont fontWithName:someItem.titleFont.fontName size:(someItem.titleFont.pointSize * scaleFactor)]];
                    [someItem   setPath:path.CGPath];
                }
            }
            
            float minLeft = FLT_MAX;
            float maxRight = FLT_MIN;
            float minTop = FLT_MAX;
            float maxBottom = FLT_MIN;
            
            for (NMSchemeItem *someItem in someViews)
            {
                //CGRect frame = CGPathGetPathBoundingBox(someview.path);
                //NSLog(@"%@", NSStringFromCGRect(someview.frame));
                
                if (someItem.frame.origin.x < minLeft) minLeft = someItem.frame.origin.x;
                if (someItem.frame.origin.y < minTop) minTop = someItem.frame.origin.y;
                
                if (someItem.frame.origin.x + someItem.frame.size.width > maxRight) maxRight = someItem.frame.origin.x + someItem.frame.size.width;
                if (someItem.frame.origin.y + someItem.frame.size.height > maxBottom) maxBottom = someItem.frame.origin.y + someItem.frame.size.height;
            }
            
            result = CGRectMake(0, 0, maxRight - minLeft, maxBottom - minTop);
        }
        //завершение блока масштабирования
        
        //NSLog(@"big frame %@", NSStringFromCGRect(result));
        return result;
    }
    else return CGRectZero;
}

-   (void)  refreshZoomRates
{
    CGRect  contentFrame   =   CGRectZero;
    for (UIView* child in _container.subviews)
        contentFrame   =   CGRectUnion(contentFrame, child.frame);
    
    CGRect  scrollRect  =   _scrollView.frame;
    
    CGFloat scaleWidth  =   scrollRect.size.width / contentFrame.size.width;
    CGFloat scaleHeight =   scrollRect.size.height/ contentFrame.size.height;
    CGFloat minScale    =   MIN(scaleWidth, scaleHeight);
    if (minScale    >   1.0f)
        minScale    =   1.0f;
    _scrollView.minimumZoomScale    =   minScale;
}

-   (void)  setCurrentLayerIndex:(NSInteger)currentLayerIndex
{
        //CHECK VALID AND CYCLE
    NSInteger   realLayer   =   currentLayerIndex;
    
    if (_layers.count   ==  0)
        realLayer   =   kNMSchemeViewCurrentNoLayer;
    else if (realLayer < 0)
        realLayer   =   _layers.count - 1;
    else if (realLayer > _layers.count - 1)
        realLayer   =   0;
    
    _currentLayerIndex   =   realLayer;
    
        //REDRAW CONTENT
    [self   refreshContent];
    
        //CALLS FOR DELEGATE AND DATA SOURCE FOR NOTIFY ABOUT CHANGES
    if ([_dataSource    respondsToSelector:@selector(schemeView:titleOfHeaderForLayer:)])
        _headerView.title   =   [_dataSource    schemeView:self
                                     titleOfHeaderForLayer:_currentLayerIndex];
    else
        _headerView.title   =   [NSString   stringWithFormat:@"Layer %ld", _currentLayerIndex + 1];
    
    if ([_delegate      respondsToSelector:@selector(schemeView:didSwitchToLayer:)])
        [_delegate  schemeView:self
              didSwitchToLayer:_currentLayerIndex];
}

-   (UIView*)   viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _container;
}

-   (void)  scrollViewDidZoom:(UIScrollView *)scrollView{
    [self   centerScrollViewContents];
}

-   (void)  centerScrollViewContents
{
    CGRect  contentFrame=   _container.frame;
    CGSize  scrollSize  =   _scrollView.bounds.size;
    
    if (contentFrame.size.width < scrollSize.width)
        contentFrame.origin.x   =   (scrollSize.width - contentFrame.size.width) / 2.0f;
    else
        contentFrame.origin.x   =   0.0f;
    
    if (contentFrame.size.height < scrollSize.height)
        contentFrame.origin.y   =   (scrollSize.height - contentFrame.size.height) / 2.0f;
    else
        contentFrame.origin.y   =   0.0f;
    
    _container.frame =   contentFrame;
}

-(void) commonTapGestureHandler:(UITapGestureRecognizer *)commonTapRecognizer
{
    [self hideKeyBoard];
    [self clearSearch];
}

-   (void)  tapGestureHandler:(UITapGestureRecognizer *)tapRecognizer
{
    [self hideKeyBoard];
    [self clearSearch];
    
    CGPoint pos =   [tapRecognizer  locationInView:_container];
//    pos =   CGPointApplyAffineTransform(pos, CGAffineTransformMakeScale(1/_scrollView.zoomScale, 1/_scrollView.zoomScale));
    
    NMSchemeItem*   selectedItem    =   [self   selectedItem];
    if (selectedItem){
        selectedItem.selected           =   NO;
        if ([_delegate  respondsToSelector:@selector(schemeView:didDeselectItemAtIndexPath:)])
            [_delegate              schemeView:self
                    didDeselectItemAtIndexPath:[self    indexPathForItem:selectedItem]];
    }

    
    NSArray*        selectableItems =   [self   selectableItems];
    
    for (NMSchemeItem* item in selectableItems)
    {
        CGPathRef usuablePath = [item getTransformedPath];
        if (CGPathContainsPoint(usuablePath, NULL, pos, false))
        {
            if ([item   isEqual:selectedItem])
            {
                NSLog(@"Already deselected");
                return;
            }
            
            item.selected   =   YES;
            if ([_delegate  respondsToSelector:@selector(schemeView:didSelectItemAtIndexPath:)])
                [_delegate          schemeView:self
                      didSelectItemAtIndexPath:[self indexPathForItem:item]];
        }
        CGPathRelease(usuablePath);
    }
}

-   (void)  doubleTapGestureHandler:(UITapGestureRecognizer *)doubleTapRecognizer
{
    [self hideKeyBoard];
    [self clearSearch];
    
    [_scrollView    setZoomScale:_scrollView.minimumZoomScale
                        animated:YES];
    [self           centerScrollViewContents];
}
/*
- (void)rotateGestureHandler:(UIRotationGestureRecognizer*)rotateRecognizer
{
    _scrollView.transform = CGAffineTransformRotate(_scrollView.transform, rotateRecognizer.rotation);//вращая сам scroll, а не conteiner избавляемся от проблем с рассогласованием зума и вращения
    //_container.transform = CGAffineTransformRotate(_container.transform, rotateRecognizer.rotation);
    rotateRecognizer.rotation = 0;//без этого раскручивается очень быстро из-за накопления поворота
    
    //NSLog(@"%@", NSStringFromCGRect(_container.frame));
    
    //[_scrollView setContentSize:_container.frame.size];
    
    //_container.frame = CGRectMake(0, 0, _container.frame.size.width, _container.frame.size.height);
}
*/
/*
- (void)pinchGestureHandler:(UIPinchGestureRecognizer *)pinchRecognizer
{
    _container.transform = CGAffineTransformScale(_container.transform, pinchRecognizer.scale, pinchRecognizer.scale);
    pinchRecognizer.scale = 1;
    
    NSLog(@"%@", NSStringFromCGRect(_container.frame));
}
*/
//-   (void)  rotationGestureHandler:(UIRotationGestureRecognizer *)rotationRecognizer{
//    CGFloat angle   =   rotationRecognizer.rotation;
//    
//    CGAffineTransform   rt  =   CGAffineTransformMakeRotation( angle);
//    rotationRecognizer.rotation =   0.0;
////    
//    _container.transform    =   CGAffineTransformConcat(_container.transform, rt);
////    _container.transform    =   rt;
//    
//    NMLog(@"Rotation: %f", angle);
//}

#pragma mark    -   Helpers
-   (NSArray*)  selectableItems
{
    NSMutableArray* result  =   [[NSMutableArray    alloc]  init];
    
    if (_currentLayerIndex   !=  kNMSchemeViewCurrentNoLayer)
    {
        NSMutableArray* layer   =   [_layers    objectAtIndex:_currentLayerIndex];
        
        for (int i = (int)layer.count - 1; i >=0; i--){
            NSMutableArray* subLayer    =   [layer  objectAtIndex:i];
            
            [result addObjectsFromArray:[subLayer filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                NMSchemeItem* item  =   evaluatedObject;
                
                return item.selectable;
            }]]];
        }
    }
    
    return [NSArray arrayWithArray:result];
}

-   (NMSchemeItem*) selectedItem{
    NSArray*    selectableItems =   [self   selectableItems];
    
    for (NMSchemeItem* item in selectableItems)
        if (item.selected)
            return item;
    
    return nil;
}

-   (NSIndexPath*)  indexPathForItem:(NMSchemeItem *)item{
    NSUInteger  layerIndex;
    NSUInteger  subLayerIndex;
    NSUInteger  itemIndex;
    
    for (layerIndex = 0; layerIndex < _layers.count; layerIndex++){
        NSMutableArray* layer = _layers[layerIndex];
        for (subLayerIndex = 0; subLayerIndex < layer.count; subLayerIndex++){
            NSMutableArray* subLayer = layer[subLayerIndex];
            for (itemIndex = 0; itemIndex < subLayer.count; itemIndex++)
                if ([subLayer[itemIndex] isEqual:item]){
                    return [NSIndexPath indexPathWithLayer:layerIndex
                                               andSubLayer:subLayerIndex
                                              andItemIndex:itemIndex];
                }
        }
    }
    
    return nil;
}

-   (NMSchemeItem*) schemeItemAtIndexPath:(NSIndexPath *)indexPath{
    NMSchemeItem*   result  =   nil;
    
    if (indexPath.length    >   2){
        NSUInteger  layer       =   indexPath.layer;
        NSUInteger  subLayer    =   indexPath.subLayer;
        NSUInteger  itemIndex   =   indexPath.itemIndex;
        
        if (layer   <   _layers.count){
            NSMutableArray* aLayer = _layers[layer];
            if (subLayer < aLayer.count){
                NSMutableArray* items = aLayer[subLayer];
                if (itemIndex < items.count)
                    result  =   items[itemIndex];
            }
        }
    }else
        NSLog(@"Invalid index path length");
    
    return result;
}

-   (void)  deselectSchemeItemAtIndexPath:(NSIndexPath *)indexPath{
    NMSchemeItem*   item    =   [self   schemeItemAtIndexPath:indexPath];
    
    if (!item)
        return;
    
    item.selected   =   NO;
}

-   (void)  selectSchemeItemAtIndexPath:(NSIndexPath *)indexPath{
    NMSchemeItem*   targetItem  =   [self   schemeItemAtIndexPath:indexPath];
    NMSchemeItem*   selectedItem=   [self   selectedItem];
    
    if (targetItem  ==  selectedItem){
        NSLog(@"Selection skipped. Item already selected");
        return;
    }
    
    if (selectedItem    !=  nil){
        [selectedItem   setSelected:NO];
        if ([_delegate  respondsToSelector:@selector(schemeView:didDeselectItemAtIndexPath:)])
            [_delegate  schemeView:self
        didDeselectItemAtIndexPath:[self indexPathForItem:selectedItem]];
    }
    if (targetItem.selectable){
        [targetItem setSelected:YES];
        if ([_delegate  respondsToSelector:@selector(schemeView:didSelectItemAtIndexPath:)])
            [_delegate  schemeView:self
          didSelectItemAtIndexPath:[self indexPathForItem:targetItem]];
    }else
        NSLog(@"Error occurred. Try to select unselectable item.");
}

- (void)hideKeyBoard
{
    [self endEditing:YES];
}

-(void)clearSearch
{
    for (NMSchemeItem *item in _container.subviews)
    {
        if ([item isKindOfClass:[NMSchemeItem class]])
        {
            [item setSearchSelected:NO];
        }
    }
}

#pragma mark    -   NMSchemeHeaderViewDelegate

-   (void)  schemeHeaderViewDownButtonClicked:(NMSchemeHeaderView *)schemeHeaderView{
    [self   setCurrentLayerIndex:_currentLayerIndex - 1];
}

-   (void)  schemeHeaderViewUpButtonClicked:(NMSchemeHeaderView *)schemeHeaderView{
    [self   setCurrentLayerIndex:_currentLayerIndex + 1];
}

-   (void)  schemeheaderViewMiddleButtonClicked:(NMSchemeHeaderView *)schemeHeaderView{
    if ([_delegate  respondsToSelector:@selector(schemeView:didTapLayerButton:)])
        [_delegate  schemeView:self
             didTapLayerButton:_currentLayerIndex];
}

-   (void)  schemeHeaderViewSearchButtonClicked:(UISearchBar *)searchBar
{
    [self clearSearch];//уберём предыдущие результаты поиска
    
    //NSLog(@"searchBar %@", searchBar.text);
    NSMutableArray *foundItems = [NSMutableArray arrayWithCapacity:15];
    for (NMSchemeItem *item in _container.subviews)
    {
        if ([item isKindOfClass:[NMSchemeItem class]])
        {
            if ([[item.titleText uppercaseString] rangeOfString:[searchBar.text uppercaseString]].location == 0)//совпадение по началу
            {
                //NSLog(@"%@", item.titleText);
                [foundItems addObject:item];
            }
        }
    }
    
    if (foundItems.count > 0)//нашли объекты, значит показываем
    {
        if (foundItems.count == 1)
        {
            NMSchemeItem *item = [foundItems objectAtIndex:0];
            
            [_scrollView    setZoomScale:_scrollView.maximumZoomScale
                                animated:NO];
            [_scrollView scrollRectToVisible:CGRectMake(item.titlePoint.x - _scrollView.frame.size.width*0.4, item.titlePoint.y - _scrollView.frame.size.height*0.4, _scrollView.frame.size.height*0.8, _scrollView.frame.size.height*0.8) animated:YES];//показываем искомый объект в центре экрана
        }
        else
        {
            [_scrollView    setZoomScale:_scrollView.minimumZoomScale
                                animated:NO];
            [self centerScrollViewContents];
            
            for (NMSchemeItem *item in foundItems)
            {
                [item setSearchSelected:YES];
            }
        }
        
    }
    
}

@end

@implementation NSIndexPath (NMSchemeViewSupport)

-   (NSUInteger)    layer{
    if (self.length <   1)
        return NSNotFound;
    return [self    indexAtPosition:0];
}

-   (NSUInteger)    subLayer{
    if (self.length <   2)
        return NSNotFound;
    return [self    indexAtPosition:1];
}

-   (NSUInteger)    itemIndex{
    if (self.length <   3)
        return NSNotFound;
    return [self    indexAtPosition:2];
}

+   (NSIndexPath*)  indexPathWithLayer:(NSUInteger)layer
                           andSubLayer:(NSUInteger)subLayer
                          andItemIndex:(NSUInteger)itemIndex{
    NSIndexPath*    result  =   [NSIndexPath    indexPathWithIndex:layer];
    result  =   [result indexPathByAddingIndex:subLayer];
    result  =   [result indexPathByAddingIndex:itemIndex];
    
    return result;
}

+   (NSIndexPath*)  indexPathWithLayer:(NSUInteger)layer
                           andSubLayer:(NSUInteger)subLayer{
    NSIndexPath*    result  =   [NSIndexPath    indexPathWithIndex:layer];
    result  =   [result indexPathByAddingIndex:subLayer];
    
    return result;
}

@end
