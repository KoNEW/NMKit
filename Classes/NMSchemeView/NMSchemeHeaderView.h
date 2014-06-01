//
//  NMSchemeHeaderView.h
//  Scheme
//
//  Created by Vladimir Konev on 4/27/13.
//  Copyright (c) 2013 Novilab Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

extern  CGFloat kNMSchemeHeaderDefaultHeight;

    //HEADER VIEW
@protocol NMSchemeHeaderViewDelegate;
@interface NMSchemeHeaderView : UIView <UISearchBarDelegate>

@property(nonatomic, assign)    id<NMSchemeHeaderViewDelegate>  delegate;
@property(nonatomic, copy)      NSString*   title;

@end


    //HEADER VIEW PTOROCOL
@protocol NMSchemeHeaderViewDelegate <NSObject>

@optional

-   (void)  schemeHeaderViewDownButtonClicked:(NMSchemeHeaderView*)schemeHeaderView;
-   (void)  schemeHeaderViewUpButtonClicked:(NMSchemeHeaderView*)schemeHeaderView;
-   (void)  schemeheaderViewMiddleButtonClicked:(NMSchemeHeaderView*)schemeHeaderView;

-   (void)  schemeHeaderViewSearchButtonClicked:(UISearchBar*)searchBar;

@end