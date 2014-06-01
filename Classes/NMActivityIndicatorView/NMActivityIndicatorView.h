//
//  SKActivityIndicatorView.h
//  seeker-client
//
//  Created by Владимир Конев on 10.05.11.
//  Copyright 2011 МИФИ. All rights reserved.
//

/**
 Расширенное представление стандартного индикатора активности.
 
 Представляет собой подкласс от UIView.
 
 
 #### Пример использования ####
    ...В рамках какого-либо UIViewController например...
     _activityIndicatorView  =   [[NMActivityIndicatorView   alloc]  initWithFrame:self.view.frame];
     [_activityIndicatorView setHidesWhenStopped:YES];
     [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
     [_activityIndicatorView setDelegate:self];
     [_activityIndicatorView setActivityIndicatorViewText:@"Идет загрузка..."];
     [_activityIndicatorView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
     [self.view              addSubview:_activityIndicatorView];
     [self.view              sendSubviewToBack:_activityIndicatorView];
 */

#import <UIKit/UIKit.h>

@protocol NMActivityIndicatorViewDelegate;
@interface NMActivityIndicatorView : UIView 

/** @name Свойства */

/**
 Стиль индикатора
 
 Свойство устанавливает стиль внутреннего индикатора активности.
 
 @since Available in iOS 2.0 and later
 */
@property(nonatomic, assign)    UIActivityIndicatorViewStyle    activityIndicatorViewStyle  __attribute__((availability(ios, introduced=2.0)));

/**
 Подпись под индикатором
 
 Свойство устанавливает значение текстовой подписи под встроенным индикатором активности.
 
 @since Available in iOS 2.0 and later
 */
@property(nonatomic, copy)      NSString*                       activityIndicatorViewText   __attribute__((availability(ios, introduced=2.0)));

/**
 Цвет индикатора загрузки
 
 Цвет внутреннего индикатора загрузки - опирается внутри на протоколо UIAppearance, поэтому доступен только с версии 5.0 операционной системы.
 
 @since Available in iOS 5.0 and later
 */
@property(nonatomic, strong)    UIColor*                        color                       __attribute__((availability(ios, introduced=5.0)));

/**
 Видимость индикатора
 
 Свойство для автоматического управления видимостью представления.
 
 Когда установлено в YES, представление автоматически становится видимым при его активации методом start, и скрывается при его остановке методом stop.
 
 @since Available in iOS 2.0 and later
 */
@property(nonatomic, assign)    BOOL                            hidesWhenStopped            __attribute__((availability(ios, introduced=2.0)));

/**
 Логический флаг активности
 
 Принимает значение YES если индикатор активен (анимируется и видим в текущий момент), NO - в противном случае.
 
 @since Available in iOS 2.0 and later
 */
@property(nonatomic, readonly)  BOOL                            isAnimating                 __attribute__((availability(ios, introduced=2.0)));

/**
 Делегат
 
 Делегает индикатора активности, должен соответствовать протоколу `NMActivityIndicatorViewDelegate`.
 
 @see NMActivityIndicatorViewDelegate
 @since Available in iOS 2.0 and later
 */
@property(nonatomic, unsafe_unretained) id<NMActivityIndicatorViewDelegate> delegate        __attribute__((availability(ios, introduced=2.0)));

/** @name Управление активностью индикатора */

/**
 Запуск анимации
 
 Метод запускает внутренний индикатор активности
 
 В случае если свойство hidesWhenStopped установлено в YES, делает представление видимым.
 @see hidesWhenStopped
 @since Available in iOS 2.0 and later
 */
-   (void)  start __attribute__((availability(ios, introduced=2.0)));;

/**
 Остановка анимации
 
 Метод останавливает внутренний индикатор активности
 
 В случае если свойство hidesWhenStopped утсановлено в YES, делает представление невидимым.
 @see hidesWhenStopped
 @since Available in iOS 2.0 and later
 */
-   (void)  stop __attribute__((availability(ios, introduced=2.0)));;

@end

/** 
 Протокол индикатора активности NMActivityIndicatorView. Все методы протокола являются опциональными.
 @see NMActivityIndicatorView
 */
@protocol NMActivityIndicatorViewDelegate <NSObject>

@optional

/**
 Извещает делегат о том, что индикатор активности был запущен.
 @param activityIndicator Указатель на индикатор активности, который вызвал данный метод.
 @since Available in iOS 2.0 and later
 */
-   (void)  activityIndicatorViewDidStart:(NMActivityIndicatorView*)activityIndicator;

/** 
 Извещает делегат о том, что индикатор активности был остановлен.
 @param activityIndicator Указатель на индикатор активности, который вызвал данный метод.
 @since Available in iOS 2.0 and later
 */
-   (void)  activityIndicatorViewDidStop:(NMActivityIndicatorView*)activityIndicator;

@end
