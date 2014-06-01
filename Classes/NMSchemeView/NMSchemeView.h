//
//  NMSchemeView.h
//  Scheme
//
//  Created by Vladimir Konev on 4/27/13.
//  Copyright (c) 2013 Novilab Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMSchemeItem.h"

extern  const   NSInteger   kNMSchemeViewCurrentNoLayer;

@protocol NMSchemeViewDataSource;
@protocol NMSchemeViewDelegate;
@interface NMSchemeView : UIView

@property(nonatomic, assign)    IBOutlet    id<NMSchemeViewDataSource>  dataSource;
@property(nonatomic, assign)    IBOutlet    id<NMSchemeViewDelegate>    delegate;
@property(nonatomic, assign)    BOOL        showHeaderView;

-   (void)  setShowHeaderView:(BOOL)showHeaderView
                    animated:(BOOL)animated;

-   (void)  reloadData;
-   (void)  reloadDataForLayer:(NSUInteger)layerIndex;
-   (void)  reloadDataForLayer:(NSUInteger)layerIndex
                   andSubLayer:(NSUInteger)subLayerIndex;

-   (NMSchemeItem*) schemeItemAtIndexPath:(NSIndexPath*)indexPath;

    //SELECTION SUPPOR
-   (void)  deselectSchemeItemAtIndexPath:(NSIndexPath*)indexPath;
-   (void)  selectSchemeItemAtIndexPath:(NSIndexPath*)indexPath;

@end

    //DATA SOURCE
@protocol NMSchemeViewDataSource <NSObject>

-   (NSUInteger)    numberOfLayersInSchemeView:(NMSchemeView*)schemeView;

-   (NSUInteger)    schemeView:(NMSchemeView*)schemeView
      numberOfSublayersInLayer:(NSUInteger)layerIndex;

-   (NSUInteger)    schemeView:(NMSchemeView*)schemeView
      numberOfItemsAtIndexPath:(NSIndexPath*)indexPath;

-   (NMSchemeItem*) schemeView:(NMSchemeView*)schemeView
               itemAtIndexPath:(NSIndexPath*)indexPath;

@optional 
-   (NSString*) schemeView:(NMSchemeView*)schemeView
     titleOfHeaderForLayer:(NSUInteger)layerIndex;

@end


    //DELEGATE
@protocol NMSchemeViewDelegate <NSObject>

@optional
-   (void)  schemeView:(NMSchemeView*)schemeView
      didSwitchToLayer:(NSUInteger)layerIndex;

-   (void)      schemeView:(NMSchemeView*)schemeView
didDeselectItemAtIndexPath:(NSIndexPath*)indexPath;

-   (void)      schemeView:(NMSchemeView*)schemeView
  didSelectItemAtIndexPath:(NSIndexPath*)indexPath;

-   (void)      schemeView:(NMSchemeView*)schemeView
         didTapLayerButton:(NSUInteger)layerIndex;

@end


    //NSIndexPath support
@interface NSIndexPath (NMSchemeViewSupport)

@property(nonatomic, readonly)  NSUInteger  layer;
@property(nonatomic, readonly)  NSUInteger  subLayer;
@property(nonatomic, readonly)  NSUInteger  itemIndex;

+   (NSIndexPath*)  indexPathWithLayer:(NSUInteger)layer
                           andSubLayer:(NSUInteger)subLayer
                          andItemIndex:(NSUInteger)itemIndex;

+   (NSIndexPath*)  indexPathWithLayer:(NSUInteger)layer
                           andSubLayer:(NSUInteger)subLayer;
@end