//
//  NMKitDefines.h
//  NMKit
//
//  Created by Vladimir Konev on 12/3/11.
//  Copyright (c) 2011 Novilab Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Здесь перечислены основные рабочие макросы
 */

/**
 @def   IS_PAD()
 
 Вовзращает YES если текущее устройство это iPad, и NO если это iPhone или iPod Touch.
 */
#ifdef  UI_USER_INTERFACE_IDIOM
    #define IS_PAD()    (UI_USER_INTERFACE_IDIOM()  ==  UIUserInterfaceIdiomPad)
#else
    #define IS_PAD()    NO
#endif

/**
 @def IS_PHONE()
 Сокращение для опредения является ли текущее устройство iPhone / iPod Touch
 */
#define IS_PHONE()      !IS_PAD()

/*
Short version of interface orientation checking for given UIInterfaceOrientation
 */
#define IS_PORTRAIT_(_orientation_)   UIInterfaceOrientationIsPortrait(_orientation_)
#define IS_LANDSCAPE_(_orientation_)  !IS_PORTRAIT_(_orientation_)

#define IS_DEVICE_PORTRAIT  UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])
#define IS_DEVICE_NADSCAPE  !IS_DEVICE_PORTRAIT()

/*
 Return Path for Documents directory of currenct application.
 This directory may be marked as shared with iTunes by adding appropriate flag in Info.plist file
 */
#define DOCUMENTS_PATH  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)    objectAtIndex:0]
#define DOCUMENTS_PATH_FILE(_file_) [DOCUMENTS_PATH stringByAppendingPathComponent:_file_]


/*
 Change logging style by prefix additional info about File, Line and Method where this NSLog was called
 */
#ifdef DEBUG
    #define NMLog(format, ...)  NSLog((format), ##__VA_ARGS__)
#elif NM_LOG_STYLE_RICH
    #define NMLog(format, ...)  NSLog(@"<%@:%d:%s> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, [NSString stringWithFormat:(format), ##__VA_ARGS__])
#else
    #define NMLog(format, ...)  
#endif

#define WIDTH(_frame_)  _frame_.size.width
#define HEIGHT(_frame_) _frame_.size.height
#define X(_frame_)      _frame_.origin.x
#define Y(_frame_)      _frame_.origin.y

#define BOTTOM(_frame_) (_frame_.origin.y + _frame_.size.height)
#define RIGHT(_frame_)  (_frame_.origin.x + _frame_.size.width)

#define RIGHT_OFFSET(_frame_, _offset_x)    (RIGHT(_frame_) + _offset_x)
#define BOTTOM_OFFSET(_frame_, _offset_y)   (BOTTOM(_frame_) + _offset_y)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


