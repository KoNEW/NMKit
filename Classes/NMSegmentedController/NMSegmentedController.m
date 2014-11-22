//
//  NMSegmentedController.m
//  Test
//
//  Created by Vladimir Konev on 4/20/13.
//  Copyright (c) 2013 Novilab Mobile. All rights reserved.
//

#import "NMSegmentedController.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <Availability.h>
#import "NMKitDefines.h"

static  NSString* const kNMSegmentedControllerChildDidChangeAttributesNotification  =   @"NMSegmentedController_attributes_did_change_notification";
static  NSTimeInterval  const   kNMSegmentedControllerTranisitionDuration   =   0.4f;

    //TRANSITION ANIMATIONS
typedef void (^NMSegmentedControllerTransitionBlock)(NMSegmentedController* container, NSInteger sourceIndex, NSInteger targetIndex);
typedef BOOL (^NMSegmentedControllerTransitionValidateBlock)(NMSegmentedController* container, NSInteger sourceIndex, NSInteger targetIndex);

static  NMSegmentedControllerTransitionValidateBlock    st_transitionValidateBlock;

static  NMSegmentedControllerTransitionBlock    st_transitionBlockNone;
static  NMSegmentedControllerTransitionBlock    st_transitionBlockSlide;
static  NMSegmentedControllerTransitionBlock    st_transitionBlockFlip;
static  NMSegmentedControllerTransitionBlock    st_transitionBlockCurl;
static  NMSegmentedControllerTransitionBlock    st_transitionBlockDissolve;

@protocol NMSegmentedControllerPrivateProtocol <NSObject>

-   (NSString*) childViewControllerRequestDefaultTitle:(UIViewController*)childController;

@end

@interface NMSegmentedController () <NMSegmentedControllerPrivateProtocol>{
    UINavigationBar*    _selfNavigationBar;
    UINavigationItem*   _selfNavigationItem;
    NSInteger           _segmentedControlPreviousIndex;
    UIView*             _backgroundView;
}

    //Animation container required with two reasons:
    // - View declared inside blocks realeses after block finish
    // - To save background and self navigation bar on required places we can't use transitionFromViewControlloer:toViewController
@property(nonatomic, strong)    UIView* childViewsContainer;

-   (void)          refreshSegmentedControl;
-   (void)          refreshNavigationItems;

-   (void)          segmentedControlValueChanged;

-   (NSUInteger)    indexOfViewController:(UIViewController*)controller;
-   (UIViewController*) childViewControllerAtIndex:(NSInteger)index;
-   (NSArray*)          childViewControllersChainFromIndex:(NSInteger)fromIndex
                                                   toIndex:(NSInteger)toIndex;

-   (void)          childControllerSegmentedAttributesChanged:(NSNotification*)notification;

-   (CGRect)        frameForChildViewController;
-   (CGRect)        frameForContainer;


@end

@interface UIViewController (NMSegmentedControllerItem_Private)
    //PRIVATE VERSION WITH READ-WRITE ACCESS
@property(nonatomic, readwrite) NMSegmentedController*  segmentedController;

@end

@implementation NMSegmentedController

+   (void)  initialize{
        //VALIDATION BLOCK
    st_transitionValidateBlock  =   ^BOOL(NMSegmentedController* container, NSInteger sourceIndex, NSInteger targetIndex){
        UIViewController*   source  =   [container  childViewControllerAtIndex:sourceIndex];
        UIViewController*   target  =   [container  childViewControllerAtIndex:targetIndex];
        
        if (source  ==  nil ||  target  ==  nil){
            NMLog(@"Transition block failed cause target or source controller is nil");
            return NO;
        }
        
        if (targetIndex ==  sourceIndex){
            NMLog(@"Transition block failed cause target and source index is similar");
            return NO;
        }
        
        return YES;
    };
    
        //TRANSITION NONE BLOCK
    st_transitionBlockNone  =   ^(NMSegmentedController* container, NSInteger sourceIndex, NSInteger targetIndex){
            //VALIDATION
        if (!st_transitionValidateBlock(container, sourceIndex, targetIndex))
            return;
        
            //GET TARGETS
        UIViewController*   source  =   [container  childViewControllerAtIndex:sourceIndex];
        UIViewController*   target  =   [container  childViewControllerAtIndex:targetIndex];
        
            //MAKE TRANSITION
        CGRect  childFrame  =   [container  frameForChildViewController];
        target.view.frame   =   childFrame;
        
        [target beginAppearanceTransition:YES
                                 animated:NO];
        [source beginAppearanceTransition:NO
                                 animated:NO];
        [source.view                    removeFromSuperview];
        [container.childViewsContainer  addSubview:target.view];
        [target endAppearanceTransition];
        [source endAppearanceTransition];
    };
    
        //TRANSITION FLIP BLOCK
    st_transitionBlockFlip  =   ^(NMSegmentedController* container, NSInteger sourceIndex, NSInteger targetIndex){
            //VALIDATION
        if (!st_transitionValidateBlock(container, sourceIndex, targetIndex))
            return;

            //GET TARGETS
        UIViewController*   source  =   [container  childViewControllerAtIndex:sourceIndex];
        UIViewController*   target  =   [container  childViewControllerAtIndex:targetIndex];
        
            //MAKE TRANSITION
            //GET OPTIONS
        UIViewAnimationOptions  options =   UIViewAnimationOptionCurveEaseOut;
        if (container.segmentsTransitionStyle   ==  NMSegmentedControllerTransitionStyleFlipHorizontal)
            options =   options |   (targetIndex >  sourceIndex ?   UIViewAnimationOptionTransitionFlipFromRight    :   UIViewAnimationOptionTransitionFlipFromLeft);
        else
            options =   options |   (targetIndex >  sourceIndex ?   UIViewAnimationOptionTransitionFlipFromBottom   :   UIViewAnimationOptionTransitionFlipFromTop);
        
            //GET TARGET FRAME
        CGRect  childFrame  =   [container  frameForChildViewController];
        target.view.frame   =   childFrame;
        source.view.frame   =   childFrame;
        
        [source beginAppearanceTransition:NO
                                 animated:YES];
        [target beginAppearanceTransition:YES
                                 animated:YES];
        [UIView transitionWithView:container.childViewsContainer
                          duration:kNMSegmentedControllerTranisitionDuration
                           options:options | UIViewAnimationOptionShowHideTransitionViews
                        animations:^{
                            [source.view                    removeFromSuperview];
                            [container.childViewsContainer  addSubview:target.view];
                        } completion:^(BOOL finished) {
                            [target         didMoveToParentViewController:container];
                            [source endAppearanceTransition];
                            [target endAppearanceTransition];
                        }];
    };
    
    st_transitionBlockSlide  =   ^(NMSegmentedController* container, NSInteger sourceIndex, NSInteger targetIndex){
            //VALIDATION
        if (!st_transitionValidateBlock(container, sourceIndex, targetIndex))
            return;
        
            //GET TARGETS
        UIViewController*   source  =   [container  childViewControllerAtIndex:sourceIndex];
        UIViewController*   target  =   [container  childViewControllerAtIndex:targetIndex];
        
            //MAKE TRANSITION
        CGRect  childFrame  =   [container  frameForChildViewController];
        CGRect  sFinishFrame;
        CGRect  tStartFrame;
        
        int     sign    =   targetIndex >   sourceIndex ?   1   :   -1;
        
        if (container.segmentsTransitionStyle   ==  NMSegmentedControllerTransitionStyleSlideHorizontal){
            sFinishFrame    =   CGRectOffset(childFrame,    -1 * sign * childFrame.size.width,  0.0);
            tStartFrame     =   CGRectOffset(childFrame,     1 * sign * childFrame.size.width,      0.0);
        }else{
            sFinishFrame    =   CGRectOffset(childFrame,    0.0,    -1 * sign * childFrame.size.height);
            tStartFrame     =   CGRectOffset(childFrame,    0.0,     1 * sign * childFrame.size.height);
        }
        
        source.view.frame   =   childFrame;
        target.view.frame   =   tStartFrame;
        
        [source beginAppearanceTransition:NO
                                 animated:YES];
        [target beginAppearanceTransition:YES
                                 animated:YES];
        [container.childViewsContainer  addSubview:target.view];
            //DOESN'T USE TRANSITION ANIMATION CAUSE THERE IS SOME HELL WITH SOURCE.VIEW REMOVING oO
        [UIView animateWithDuration:kNMSegmentedControllerTranisitionDuration
                         animations:^{
                             target.view.frame = childFrame;
                             source.view.frame = sFinishFrame;
                         }
                         completion:^(BOOL finished) {
                             [source.view   removeFromSuperview];
                             [target    didMoveToParentViewController:container];
                             [target    endAppearanceTransition];
                             [source    endAppearanceTransition];
                         }];
    };
    
    st_transitionBlockCurl  =   ^(NMSegmentedController* container, NSInteger sourceIndex, NSInteger targetIndex){
            //VALIDATION
        if (!st_transitionValidateBlock(container, sourceIndex, targetIndex))
            return;
        
            //GET TARGETS
        UIViewController*   source  =   [container  childViewControllerAtIndex:sourceIndex];
        UIViewController*   target  =   [container  childViewControllerAtIndex:targetIndex];
        
            //MAKE TRANSITION
        CGRect  childFrame  =   [container  frameForChildViewController];
        target.view.frame   =   childFrame;
        
        
        [target beginAppearanceTransition:YES
                                 animated:YES];
        [source beginAppearanceTransition:NO
                                 animated:YES];
        [UIView transitionWithView:container.childViewsContainer
                          duration:kNMSegmentedControllerTranisitionDuration
                           options:targetIndex > sourceIndex? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown
                        animations:^{
                            [source.view removeFromSuperview];
                            [container.childViewsContainer addSubview:target.view];
                        }
                        completion:^(BOOL finished) {
                            [target didMoveToParentViewController:container];
                            [target endAppearanceTransition];
                            [source endAppearanceTransition];
                        }];        
    };
    
    st_transitionBlockDissolve  =   ^(NMSegmentedController* container, NSInteger sourceIndex, NSInteger targetIndex){
            //VALIDATION
        if (!st_transitionValidateBlock(container, sourceIndex, targetIndex))
            return;
        
            //GET TARGETS
        UIViewController*   source  =   [container  childViewControllerAtIndex:sourceIndex];
        UIViewController*   target  =   [container  childViewControllerAtIndex:targetIndex];
        
            //MAKE TRANSITION
        CGRect  childFrame  =   [container  frameForChildViewController];
        target.view.frame   =   childFrame;
        [target beginAppearanceTransition:YES
                                 animated:YES];
        [source beginAppearanceTransition:NO
                                 animated:YES];
        [UIView transitionWithView:container.childViewsContainer
                          duration:kNMSegmentedControllerTranisitionDuration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [source.view                    removeFromSuperview];
                            [container.childViewsContainer  addSubview:target.view];
                        } completion:^(BOOL finished) {
                            [target endAppearanceTransition];
                            [source endAppearanceTransition];
                        }];
    };
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view  setAutoresizesSubviews:YES];
        //DEFAULT TRANSITION STYLE
    _segmentsTransitionStyle    =   NMSegmentedControllerTransitionStyleNone;
    
        //CREATING SEGMENTED CONTROL
    _segmentedControl   =   [[UISegmentedControl    alloc]  initWithItems:@[]];
    [_segmentedControl  addTarget:self
                           action:@selector(segmentedControlValueChanged)
                 forControlEvents:UIControlEventValueChanged];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    [_segmentedControl  setSegmentedControlStyle:UISegmentedControlStyleBar];
#endif
    
        //CREATING NAVIGATION BAR AND ITEM FOR USE IF UINavigationController IS NOT PROVIDED
    _selfNavigationBar  =   [[UINavigationBar   alloc]  initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0)];
    [_selfNavigationBar setHidden:YES];
    [_selfNavigationBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    _selfNavigationBar.layer.zPosition  =   MAXFLOAT;
    [self.view          addSubview:_selfNavigationBar];
    _selfNavigationItem =   [[UINavigationItem  alloc]  initWithTitle:@"Segmented Controller"];
    [_selfNavigationBar pushNavigationItem:_selfNavigationItem
                                  animated:NO];
    
        //INITIAL CREATE WITH 0 COUNT OF CONTROLLERS
    [self   setViewControllers:[[NSArray    alloc]  init]];
    
        //APPEND BACKGROUND - CAUSE WHILE TRANSITION IT MOVES WITH CONTROLLER VIEW
    _backgroundView                 =   [[UIView    alloc]  initWithFrame:[self frameForContainer]];
    _backgroundView.backgroundColor =   [UIColor    segmentedControllerBackgroundColor];
    _backgroundView.autoresizingMask=   UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view  addSubview:_backgroundView];
    
    _childViewsContainer                    =   [[UIView    alloc]  initWithFrame:[self frameForContainer]];
    _childViewsContainer.backgroundColor    =   [UIColor    clearColor];
    _childViewsContainer.autoresizingMask   =   UIViewAutoresizingFlexibleWidth |   UIViewAutoresizingFlexibleHeight;
    [self.view  addSubview:_childViewsContainer];
}

-   (void)  viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    
        //SPIKE FOR FIRST SHOW AND ACCURATE LAYOUT INITIAL VIEW CONTROLLER
    if (_segmentedControl.selectedSegmentIndex  !=  UISegmentedControlNoSegment){
        _segmentedControlPreviousIndex  =   UISegmentedControlNoSegment;
        [_segmentedControl  sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

-   (void)  refreshSegmentedControl{    
    [_segmentedControl  removeAllSegments];
    
    for (int i = 0; i < _viewControllers.count; i++){
        UIViewController*   childController =   _viewControllers[i];
        
            //TRY TO CREATE SEGMENT WITH ICON
        UIImage*    icon    =   childController.segmentedControllerIcon;
        if (icon    !=  nil){
            [_segmentedControl  insertSegmentWithImage:icon
                                               atIndex:i
                                              animated:NO];
            continue;
        }
        
            //ICON DOESN'T PROVIDED, SHOULD CREATE SEGMENT WITH TITLE
        NSString*   title   =   childController.segmentedControllerTitle;
        [_segmentedControl  insertSegmentWithTitle:title
                                           atIndex:i
                                          animated:NO];
    }

    if (self.navigationController   !=  nil){
        [self.navigationItem    setTitleView:_segmentedControl];
        _selfNavigationBar.hidden   =   YES;
    }else{
        [_selfNavigationBar     setHidden:NO];
        [_selfNavigationItem    setTitleView:_segmentedControl];
    }
}

-   (void)  refreshNavigationItems{
    UIViewController*   currentController   =   [self   childViewControllerAtIndex:_segmentedControl.selectedSegmentIndex];
    
    NSMutableArray* items   =   [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    
    [items  addObjectsFromArray:currentController.navigationItem.rightBarButtonItems];
    
    if (self.navigationController   ==  nil)
        [_selfNavigationItem    setRightBarButtonItems:items];
    else
        [self.navigationItem    setRightBarButtonItems:items];
}

-   (NSString*) childViewControllerRequestDefaultTitle:(UIViewController *)childController{
    NSString*   result  =   @"Item";
    
    NSUInteger  childIndex  =   [_viewControllers   indexOfObject:childController];
    if (childIndex  !=  NSNotFound)
        result  =   [NSString   stringWithFormat:@"Item %lu", childIndex + 1];
    
    return result;
}

-   (void)  childControllerSegmentedAttributesChanged:(NSNotification *)notification{
    UIViewController*   sender  =   notification.object;

    if (![sender isKindOfClass:[UIViewController class]])
        return;
    
    NSUInteger  index   =   [self   indexOfViewController:sender];
    if (index   ==  NSNotFound)
        return;
    
    if (sender.segmentedControllerIcon  !=  nil)
        [_segmentedControl  setImage:sender.segmentedControllerIcon
                   forSegmentAtIndex:index];
    else
        [_segmentedControl  setTitle:sender.segmentedControllerTitle
                   forSegmentAtIndex:index];
}

-   (NSUInteger)    indexOfViewController:(UIViewController *)controller{
    return [_viewControllers    indexOfObject:controller];
}

-   (UIViewController*) childViewControllerAtIndex:(NSInteger)index{
    UIViewController*   result  =   nil;
    
    if (index   >=  0   &&  index   <  _viewControllers.count)
        result  =   [_viewControllers   objectAtIndex:index];
    
    return result;
}

-   (NSArray*)  childViewControllersChainFromIndex:(NSInteger)fromIndex
                                           toIndex:(NSInteger)toIndex{
    NSMutableArray* array   =   [[NSMutableArray    alloc]  init];
    
        //VALIDATION
    BOOL    isValid =   YES;
    isValid &=  fromIndex   >=  0;
    isValid &=  fromIndex   <   _viewControllers.count;
    isValid &=  toIndex     >=  0;
    isValid &=  toIndex     <   _viewControllers.count;
    
    if (isValid){
        if (fromIndex   <   toIndex){
            for (NSInteger i = fromIndex; i <= toIndex; i++){
                UIViewController*   vc  =   [self   childViewControllerAtIndex:i];
                if (vc  !=  nil)
                    [array  addObject:vc];
            }
        }else{
            for (NSInteger i = fromIndex; i >= toIndex; i--) {
                UIViewController*   vc  =   [self   childViewControllerAtIndex:i];
                if (vc  !=  nil)
                    [array  addObject:vc];
            }
        }
    }else
        NMLog(@"Construct view controllers chain failed with invalid indexes:\n\tFROM: %ld\n\tTO: %ld\n\tTOTAL VC COUNT: %ld", (long)fromIndex, (long)toIndex, _viewControllers.count);
    
    return [NSArray arrayWithArray:array];
}

#pragma mark    -   View Controllers manipulation
-   (void)  setViewControllers:(NSArray *)viewControllers{
    if ([viewControllers    isEqualToArray:_viewControllers])
        return;
    
        //FLUSH PREVIOUS INDEX
    _segmentedControlPreviousIndex  =   UISegmentedControlNoSegment;
    
        //FILTER FOR UIViewController Item type
    NSArray*    controllers =   [viewControllers    filteredArrayUsingPredicate:[NSPredicate    predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject    isKindOfClass:[UIViewController class]])
            return YES;
        return NO;
    }]];
    
        //REMOVE OLD CHANGES OBSERVING
    for (UIViewController*  child in _viewControllers){
        [[NSNotificationCenter  defaultCenter]  removeObserver:self
                                                          name:kNMSegmentedControllerChildDidChangeAttributesNotification
                                                        object:child];
        [child  willMoveToParentViewController:nil];
        [child  removeFromParentViewController];
    }
    
        //BIND CONTROLLERS
    _viewControllers    =   controllers;
    
        //SET CONTROLLERS PARENT LINK
    for (UIViewController*  childController in _viewControllers){
        [childController        setSegmentedController:self];
        [childController.view   setFrame:[self   frameForChildViewController]];
        [childController.view   setAutoresizingMask: childController.view.autoresizingMask | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self                   addChildViewController:childController];
        [childController        didMoveToParentViewController:self];
    }
    
        //REFRESH UI
    [self   refreshSegmentedControl];
    if ([_segmentedControl  numberOfSegments]   >   0){
        [_segmentedControl  setSelectedSegmentIndex:0];
        [_segmentedControl  sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
        //ADD KVO
    for (UIViewController* child in _viewControllers)
        [[NSNotificationCenter  defaultCenter]  addObserver:self
                                                   selector:@selector(childControllerSegmentedAttributesChanged:)
                                                       name:kNMSegmentedControllerChildDidChangeAttributesNotification
                                                     object:child];
}

-   (void)  setViewControllersByStoryboardIdentifiers:(NSArray *)identifiers{
    NSMutableArray* controllers =   [[NSMutableArray    alloc]  init];
    
    for (int i = 0; i < identifiers.count; i++){
        if (![identifiers[i] isKindOfClass:[NSString class]])
            continue;
        
        NSString*           identifier  =   identifiers[i];
        UIViewController*   controller  =   nil;
        @try {
            controller  =   [self.storyboard    instantiateViewControllerWithIdentifier:identifier];
        }
        @catch (NSException *exception) {
            NMLog(@"\n\tNMSegmentedController. EXCEPTION OCCURRED!!!\n<NAME>:\t\t%@\n<REASON>:\t%@\n\tAppend ViewController with identifier \"%@\" omitted", exception.name, exception.reason, identifier);
            continue;
        }
        
        [controllers    addObject:controller];
    }
    
    [self   setViewControllers:[NSArray arrayWithArray:controllers]];
}

-   (void)  segmentedControlValueChanged{    
    if (_segmentedControl.selectedSegmentIndex  ==  UISegmentedControlNoSegment){
            //CLEAR CONTAINER VIEWS
        [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (obj ==  _selfNavigationBar)
                return;
            
            if (obj ==  _backgroundView)
                return;
            
            if (obj ==  _childViewsContainer)
                return;
            
            [obj    removeFromSuperview];
        }];
        return;
    }
    
    if (_segmentedControlPreviousIndex  ==  _segmentedControl.selectedSegmentIndex)
            //SIMILAR INDEX - OMIT TRANSITION
        return;
    
    if (_segmentedControlPreviousIndex  ==  UISegmentedControlNoSegment){
            //INITIAL TRANSITION
        UIViewController*   target  =   [self   childViewControllerAtIndex:_segmentedControl.selectedSegmentIndex];
        [self.childViewsContainer   addSubview:target.view];
        [target         didMoveToParentViewController:self];
        [target.view    setFrame:[self  frameForChildViewController]];
    }else{
        NSInteger   sIndex  =   _segmentedControlPreviousIndex;
        NSInteger   tIndex  =   _segmentedControl.selectedSegmentIndex;
        
        NMSegmentedControllerTransitionBlock    transitionBlock =   NULL;
        switch (_segmentsTransitionStyle) {
            case NMSegmentedControllerTransitionStyleFlipHorizontal:
            case NMSegmentedControllerTransitionStyleFlipVertical:
                transitionBlock =   st_transitionBlockFlip;
                break;
                
            case NMSegmentedControllerTransitionStyleSlideHorizontal:
            case NMSegmentedControllerTransitionStyleSlideVertical:
                transitionBlock =   st_transitionBlockSlide;
                break;
                
            case NMSegmentedControllerTransitionStyleCurl:
                transitionBlock =   st_transitionBlockCurl;
                break;
                
            case NMSegmentedControllerTransitionStyleDissolve:
                transitionBlock =   st_transitionBlockDissolve;
                break;
                
            case NMSegmentedControllerTransitionStyleNone:
            default:
                transitionBlock =   st_transitionBlockNone;
                break;
        }
        
        transitionBlock(self, sIndex, tIndex);
    }
    
    _segmentedControlPreviousIndex  =   _segmentedControl.selectedSegmentIndex;
    
    [self   refreshNavigationItems];
}

-   (CGRect)    frameForChildViewController{
//    CGRect result   =   self.view.bounds;
    CGRect  result  =   CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height - 112.0);
    if (self.navigationController   ==  nil)
        result  =   CGRectMake(0.0,
                               0.0,
                               result.size.width,
                               result.size.height - _selfNavigationBar.frame.size.height);
    return result;
}

-   (CGRect)    frameForContainer{
    CGRect  result  =   self.view.frame;
    if (self.navigationController   ==  nil)
        result  =   CGRectMake(result.origin.x,
                               result.origin.y + _selfNavigationBar.frame.size.height,
                               result.size.width,
                               result.size.height - _selfNavigationBar.frame.size.height);
    
    return result;
}

@end



#pragma mark - NMSegmentedControllerItem Category

static  NSString* const kNMSegmentedControllerTitleKey  =   @"NMSegmentedControllerTitle_runtime_key";
static  NSString* const kNMSegmentedControllerIconKey   =   @"NMSegmentedControllerIcon_runtime_key";
static  NSString* const kNMSegmentedControllerKey       =   @"NMSegmentedController_runtime_key";

@implementation UIViewController (NMSegmentedControllerItem)
@dynamic segmentedControllerIcon;
@dynamic segmentedControllerTitle;
@dynamic segmentedController;

-   (NSString*) segmentedControllerTitle{
    NSString*   result  =   objc_getAssociatedObject(self, (__bridge const void *)(kNMSegmentedControllerTitleKey));

        //TRY TO REQUEST TITLE FROM PARENT
    if (result  ==  nil){
        if ([self.segmentedController   conformsToProtocol:@protocol(NMSegmentedControllerPrivateProtocol)]){
            result  =   [self.segmentedController   childViewControllerRequestDefaultTitle:self];
            
            if ([result isKindOfClass:[NSString class]])
                self.segmentedControllerTitle   =   result;
        }
    }
    
    if (![result isKindOfClass:[NSString class]])
        result  =   nil;
    
    return result;
}

-   (void)      setSegmentedControllerTitle:(NSString *)segmentedControllerTitle{
    if (segmentedControllerTitle    !=  nil &&  ![segmentedControllerTitle  isKindOfClass:[NSString class]])
        return;
    
    objc_setAssociatedObject(self, (__bridge const void *)(kNMSegmentedControllerTitleKey), segmentedControllerTitle, OBJC_ASSOCIATION_COPY);
    [[NSNotificationCenter  defaultCenter]  postNotificationName:kNMSegmentedControllerChildDidChangeAttributesNotification
                                                          object:self];
}

-   (UIImage*)  segmentedControllerIcon{
    UIImage*    result  =   objc_getAssociatedObject(self, (__bridge const void *)(kNMSegmentedControllerIconKey));
    if (![result isKindOfClass:[UIImage class]])
        result  =   nil;
    
    return  result;
}

-   (void)      setSegmentedControllerIcon:(UIImage *)segmentedConttollerIcon{
    if (segmentedConttollerIcon !=  nil &&  ![segmentedConttollerIcon   isKindOfClass:[UIImage class]])
        return;

    objc_setAssociatedObject(self, (__bridge const void *)(kNMSegmentedControllerIconKey), segmentedConttollerIcon, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[NSNotificationCenter  defaultCenter]  postNotificationName:kNMSegmentedControllerChildDidChangeAttributesNotification
                                                          object:self];
}

@end

@implementation UIViewController (NMSegmentedControllerItem_Private)
@dynamic segmentedController;

-   (NMSegmentedController*)    segmentedController{
    NMSegmentedController*  result  =   objc_getAssociatedObject(self, (__bridge const void*)kNMSegmentedControllerKey);
    if (![result    isKindOfClass:[NMSegmentedController    class]])
        result  =   nil;
    
    return result;
}

-   (void)  setSegmentedController:(NMSegmentedController *)segmentedController{
    if (segmentedController !=  nil &&  ![segmentedController   isKindOfClass:[NMSegmentedController    class]])
        return;
    
        //FORBID ASSOCIATE WITH NOT REAL PARENT CONTROLLER
    if (![segmentedController.viewControllers    containsObject:self])
        return;
    
    objc_setAssociatedObject(self, (__bridge const void*)kNMSegmentedControllerKey, segmentedController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIColor (NMSegmentedControllerColors)

+   (UIColor*)  segmentedControllerBackgroundColor{
    static UIColor* st_sharedColor = nil;
    
    if (st_sharedColor == nil)
        st_sharedColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"segmented_controller_background"]];
    
    return st_sharedColor;
}

@end


