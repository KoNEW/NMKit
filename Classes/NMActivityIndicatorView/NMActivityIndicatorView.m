//
//  NMActivityIndicatorView.m
//
//  Created by Konev Vladimir. Novilab-Mobile, LLC 2011
//

#import "NMActivityIndicatorView.h"


@interface NMActivityIndicatorView (){
    UIActivityIndicatorView*    _activityIndicator;
    UILabel*                    _activityLabel;
}

@end


@implementation NMActivityIndicatorView

#pragma mark - LifeCycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self   setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
        
        _activityIndicator  =   [[UIActivityIndicatorView    alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        [self   addSubview:_activityIndicator];
        
        _activityLabel      =   [[UILabel    alloc] initWithFrame:CGRectZero];
        [_activityLabel     setBackgroundColor:[UIColor clearColor]];
        [_activityLabel     setTextColor:[UIColor       whiteColor]];
        [_activityLabel     setTextAlignment:NSTextAlignmentCenter];
        [_activityLabel     setShadowColor:[UIColor     blackColor]];
        [_activityLabel     setShadowOffset:CGSizeMake(0.0, -1.0)];
        [_activityLabel     setFont:[UIFont boldSystemFontOfSize:18.0]];
        [self   addSubview:_activityLabel];
        [self   setFrame:frame];
        
        [self   setHidesWhenStopped:YES];
    }
    return self;
}

-   (void)  setFrame:(CGRect)frame{
    [super  setFrame:frame];
    
    [_activityIndicator setFrame:CGRectMake(frame.size.width / 2 - 15.0,
                                            frame.size.height / 2 - 15.0,
                                            30.0,
                                            30.0)];
    
    [_activityLabel     setFrame:CGRectMake(10.0,
                                            frame.size.height / 2 + 30.0,
                                            frame.size.width - 20.0,
                                            25.0)];
}

#pragma mark    -   Custom Properties getters and setters
-   (void)  setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle{
    [_activityIndicator setActivityIndicatorViewStyle:activityIndicatorViewStyle];
}

-   (UIActivityIndicatorViewStyle)activityIndicatorViewStyle{
    return [_activityIndicator  activityIndicatorViewStyle];
}

-   (void)  setActivityIndicatorViewText:(NSString *)activityIndicatorViewText{
    [_activityLabel setText:activityIndicatorViewText];
}

-   (NSString*) activityIndicatorViewText{
    return [_activityLabel  text];
}

-   (void)  setColor:(UIColor *)color{
    [_activityIndicator setColor:color];
}

-   (UIColor*)  color{
    return [_activityIndicator  color];
}

-   (void)  setHidesWhenStopped:(BOOL)hidesWhenStopped{
    _hidesWhenStopped   =   hidesWhenStopped;
    
    if (_hidesWhenStopped   && ![_activityIndicator  isAnimating])
        [self   setHidden:YES];
}

-   (BOOL)  isHidesWhenStopped{
    return _hidesWhenStopped;
}

-   (BOOL)  isAnimating{
    return ![self    isHidden] && [_activityIndicator   isAnimating];
}

#pragma mark Logic
-   (void)start{
    [self   setHidden:NO];
    [_activityIndicator startAnimating];
    
    if ([_delegate  respondsToSelector:@selector(activityIndicatorViewDidStart:)])
        [_delegate  activityIndicatorViewDidStart:self];
}

-   (void)  stop{
    [_activityIndicator stopAnimating];
    if (_hidesWhenStopped)
        [self   setHidden:YES];
    
    if ([_delegate  respondsToSelector:@selector(activityIndicatorViewDidStop:)])
        [_delegate  activityIndicatorViewDidStop:self];
}


@end
