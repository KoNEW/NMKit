//
//  NMSchemeHeaderView.m
//  Scheme
//
//  Created by Vladimir Konev on 4/27/13.
//  Copyright (c) 2013 Novilab Mobile. All rights reserved.
//

#import "NMSchemeHeaderView.h"

@interface NMSchemeHeaderView (){
    UIButton*       _arrowUpButton;
    UIButton*       _arrowDownButton;
    UIButton*       _middleButton;
    
    UIImageView*    _backgroundImageView;
}

-   (void)  arrowDownButtonClicked;
-   (void)  arrowUpButtonClicked;
-   (void)  middleButtonClicked;

@end

static  CGRect  kNMSchemeHeaderRectFull;
static  CGRect  kNMSchemeHeaderRectArrowDown;
static  CGRect  kNMSchemeHeaderRectArrowUp;
static  CGRect  kNMSchemeHeaderRectMiddle;
static  CGRect  kNMSchemeHeaderRectSearch;

CGFloat kNMSchemeHeaderDefaultHeight    =   50.0f;//44

@implementation NMSchemeHeaderView

#pragma mark    -   LifeCycle
+   (void)  initialize{
//    kNMSchemeHeaderRectFull     =   CGRectMake(0.0,    0.0, 320.0, 94.0);//44
    kNMSchemeHeaderRectFull     =   CGRectMake(0.0,    0.0, 320.0, 50.0);//44
    kNMSchemeHeaderRectArrowDown=   CGRectMake(60.0,   7.0, 35.0,  30.0);
    kNMSchemeHeaderRectArrowUp  =   CGRectMake(225.0,  7.0, 35.0,  30.0);
    kNMSchemeHeaderRectMiddle   =   CGRectMake(95.0,   7.0, 130.0, 30.0);
    kNMSchemeHeaderRectSearch   =   CGRectMake(0.0,    44.0,320.0, 50.0);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // - Firstly construct item with default frame
        // - Then set approtiate autoresizing masks
        // - And apply real frame
        [self   setFrame:kNMSchemeHeaderRectFull];
        
            //BACKGROUND
        _backgroundImageView    =   [[UIImageView   alloc]  initWithFrame:kNMSchemeHeaderRectFull];
        _backgroundImageView.backgroundColor    =   [UIColor    clearColor];
        _backgroundImageView.image              =   [UIImage    imageNamed:@"nm_schemeheader_background"];
        _backgroundImageView.autoresizingMask   =   (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        [self   addSubview:_backgroundImageView];
        
            //DOWN BUTTON
        _arrowDownButton    =   [[UIButton  alloc]  initWithFrame:kNMSchemeHeaderRectArrowDown];
        [_arrowDownButton   setBackgroundColor:[UIColor    clearColor]];
        //[_arrowDownButton   setImages:@"nm_schemeheader_down"];
        [_arrowDownButton setImage:[UIImage imageNamed:@"nm_schemeheader_down.png"] forState:UIControlStateNormal];
        [_arrowDownButton   addTarget:self
                               action:@selector(arrowDownButtonClicked)
                     forControlEvents:UIControlEventTouchUpInside];
        [self   addSubview:_arrowDownButton];
        
            //UP BUTTON
        _arrowUpButton      =   [[UIButton  alloc]  initWithFrame:kNMSchemeHeaderRectArrowUp];
        [_arrowUpButton     setBackgroundColor:[UIColor clearColor]];
        //[_arrowUpButton     setImages:@"nm_schemeheader_up"];
        [_arrowUpButton setImage:[UIImage imageNamed:@"nm_schemeheader_up.png"] forState:UIControlStateNormal];
        [_arrowUpButton     setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [_arrowUpButton     addTarget:self
                               action:@selector(arrowUpButtonClicked)
                     forControlEvents:UIControlEventTouchUpInside];
        [self   addSubview:_arrowUpButton];
        
            //MIDDLE BUTTON
        _middleButton       =   [[UIButton  alloc]  initWithFrame:kNMSchemeHeaderRectMiddle];
        [_middleButton      setBackgroundColor:[UIColor clearColor]];
        //[_middleButton      setImages:@"nm_schemeheader_middle"];
        [_middleButton setBackgroundImage:[UIImage imageNamed:@"nm_schemeheader_middle.png"] forState:UIControlStateNormal];
        [_middleButton      setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_middleButton      addTarget:self
                               action:@selector(middleButtonClicked)
                     forControlEvents:UIControlEventTouchUpInside];
        [self   addSubview:_middleButton];
        [_middleButton  setTitleColor:[UIColor colorWithRed:56.0/255.0
                                                      green:56.0/255.0
                                                       blue:56.0/255.0
                                                      alpha:1.0]
                             forState:UIControlStateNormal];
        [_middleButton  setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateHighlighted];
        [_middleButton.titleLabel   setFont:[UIFont boldSystemFontOfSize:14.0]];
        
        
        //search
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.delegate = self;
        [searchBar setFrame:kNMSchemeHeaderRectSearch];
        searchBar.tintColor = [UIColor clearColor];
        //custom searchbar font
        UITextField *searchField = nil;
        for(UIView *subview in searchBar.subviews)
        {
            if([subview isKindOfClass:[UITextField class]])
            {
                searchField = (UITextField*)subview;
            }
        }
        if(!(searchField == nil))
        {
            [searchField setFont:[UIFont systemFontOfSize:15]];
            [searchField setBorderStyle:UITextBorderStyleNone];
        }
        
        [self   setFrame:frame];
    }
    return self;
}

#pragma mark    -   Logic
-   (void)  arrowDownButtonClicked{
    if ([_delegate  respondsToSelector:@selector(schemeHeaderViewDownButtonClicked:)])
        [_delegate  schemeHeaderViewDownButtonClicked:self];
}

-   (void)  arrowUpButtonClicked{
    if ([_delegate  respondsToSelector:@selector(schemeHeaderViewUpButtonClicked:)])
        [_delegate  schemeHeaderViewUpButtonClicked:self];
}

-   (void)  middleButtonClicked{
    if ([_delegate  respondsToSelector:@selector(schemeheaderViewMiddleButtonClicked:)])
        [_delegate  schemeheaderViewMiddleButtonClicked:self];
}

-   (NSString*) title{
    return _middleButton.titleLabel.text;
}

-   (void)  setTitle:(NSString *)title{
    [_middleButton  setTitle:title
                    forState:UIControlStateNormal];
}

//search
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    if ([_delegate  respondsToSelector:@selector(schemeHeaderViewSearchButtonClicked:)])
        [_delegate  schemeHeaderViewSearchButtonClicked:searchBar];
}

@end
