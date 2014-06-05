    //
    //  NSDate+NMKit_Extensions.h
    //  VKMessenger
    //
    //  Created by Mephi Skib on 15.04.12.
    //  Copyright (c) 2012 Novilab Mobile. All rights reserved.
    //

#import <Foundation/Foundation.h>

/**
 Набор категорий для класса NSDate
 */

#define NM_SECONDS_PER_DAY  86400.0f


typedef NS_ENUM(NSUInteger, NMDateType){
    NMDatePast,
    NMDateYesterday,
    NMDateToday,
    NMDateTomorrow,
    NMDateFuture
};

@interface NSDate (NMKit_Extensions)

/** @name Конструкторы*/

/**
 Констркутор времени по формату RFC3339
 
 Статический конструктор класса на основе входящей строки с представлением даты в формате RFC3339.
 
 @param rfc3339Value Представление строки в формате RFC3339. Например значение вида `2013-01-29T17:00:00+04:00`.
 @return Экземпляр класса NSDate с параметрами указанной даты. В случае если на вход подается ограниченная дата (например `2012-01-01`) извлекаются данные о дате, а время устанавливается в 12 часов по полудню. Если входящий параметр rfc3339Value равен nil, возвращается nil.
 */
+   (NSDate*)       dateWithRFC3339Value:(NSString*)rfc3339Value;
-   (NSString*)     rfc3339Value;

/**@name Полночь, полдень*/
/**
 Полночь по дню.
 
 @return Возвращает дату инициализированную по предыдущей полночи по отношению к текущему значению. Например для даты `2012-01-01 15:56:32` будет возвращено значение `2012-01-01 00:00:00`.
 */
-   (NSDate*)   midNightTime;

/**
 Предыдущая полночь.
 
 @return Статический конструктор, возвращает экземпляр `NSDate` инициализированный по ближайшей предыдущей полночи относительно сегодняшнего дня. Например если текущее время `2012-01-01 15:56:32` - возвращается значение `2012-01-01 00:00:00`.
 */
+   (NSDate*)   lastMidNightFromToday;

/**
 Следующая полночь.
 
 @return Статический конструктор, возвращает экземпляр `NSDate` инициализированный по ближайшей следующей полночи относительно сегодняшнего дня. Например если текущее время `2012-01-01 15:56:32` - возвращается значение `2012-01-02 00:00:00`.
 */
+   (NSDate*)   nextMidNightFromToday;


/**@name Логические флаги */
/** Определение типа даты
 
 @return    Возращает тип даты из перечисления `NMDateType`, определенный как
 typedef NS_ENUM(NSInteger, NMDateType){
 NMDatePast,
 NMDateYesterday,
 NMDateToday,
 NMDateTomorrow,
 NMDateFuture
 };
 */
-   (NMDateType)    dateType;

/**
 Логический флаг "Сегодня"
 
 Возвращает истину если вызывающий объект относится к настоящему дню. Важно, ближайшая полночь относится уже к следующему дню.
 
 @return `YES` если вызывающий объект относится к настоящему дню, `NO` - в противном случае.
 @see isTomorrow,isYesterday,isFuture,isPast
 */
-   (BOOL)      isToday;

/**
 Логический флаг "Вчера"
 
 @return `YES` если вызывающий объект относится ко вчерашнему дню, `NO` - в противном случае.
 @see isToday,isYesterday,isFuture,isPast
 */
-   (BOOL)      isTomorrow;

/**
 Логический флаг "Завтра"
 
 @return `YES` если вызывающий объект относится к завтрашнему дню, `NO` - в противном случае.
 @see isToday,isTomorrow,isFuture,isPast
 */
-   (BOOL)      isYesterday;


/**
 Логический флаг "В будущем"
 
 @param strictly Логический флаг, указывающий на жесткость проверки. В случае если его значение равно `YES` для завтрашнего дня будет возвращено значение `NO`.
 @return `YES` если вызывающий объект относится к будущему, `NO` - в противном случае.
 @see isFuture
 */
-   (BOOL)      isFuture:(BOOL)strictly;

/**
 Логический флаг "В будущем"
 
 Перегруженный вариант метода `isFuture:`, со значением параметра жесткости проверки по умолчанию равным `NO`.
 
 @return `YES` если вызывающий объект относится к будущему, `NO` - в противном случае.
 @see isFuture:,isToday,isTomorrow,isYesterday,isPast
 */
-   (BOOL)      isFuture;

/**
 Логический флаг "В будущем"
 
 @param strictly Логический флаг, указывающий на жесткость проверки. В случае если его значение равно `YES` для вчерашнего дня будет возвращено значение `NO`.
 @return `YES` если вызывающий объект относится к будущему, `NO` - в противном случае.
 @see isPast
 */
-   (BOOL)      isPast:(BOOL)strictly;

/**
 Логический флаг "В будущем"
 
 Перегруженный вариант метода `isPast:`, со значением параметра жесткости проверки по умолчанию равным `NO`.
 
 @return `YES` если вызывающий объект относится к будущему, `NO` - в противном случае.
 @see isPast:,isToday,isTomorrow,isYesterday,isFuture
 */
-   (BOOL)      isPast;

-   (BOOL)      isSimilarDay:(NSDate*)date;

- (NSDate*) midDay;
+ (NSDate*) today;


@end
