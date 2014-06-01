//
//  NSDateFormatter+NMKit_Extensions.h
//  VKMessenger
//
//  Created by Mephi Skib on 15.04.12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Набор категорий для класса NSDateFormatter
 */

@interface NSDateFormatter (NMKit_Extensions)

/** Форматированная строка для даты
 @param date    Дата для преобразования в строку
 @return    Возвращает строчное представление для даты.
 @warning   При работе опирается на метод [NSDate dateType], для специализированных дат вывод значения типа "вчера", "сегодня", "завтра".
 */
-   (NSString*) naturalDayStringFromDate:(NSDate*)date;

@end
