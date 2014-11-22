//
//  NSString+NMKit_Extenstion.h
//  NMKit
//
//  Created by Vladimir Konev on 12/3/11.
//  Copyright (c) 2011 Novilab Mobile. All rights reserved.
//
//  Different useful categories on NSString

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "NMKitDefines.h"

@interface NSString (NMKit_Extenstion)

/**
 Набор категория для класса `NSString`
 */


/** @name   Hash sum in RAW format*/
/**
 Вычисление хеш суммы по алгоритму MD5
 @return Результат вычисления хеш-суммы в сыром виде `NSData`
 @see SHA1, HMAC_MD5, HMAC_SHA1
 @since Available since iOS 2.0 and later
 */
-	(NSData*)	MD5 __attribute__((const, availability(ios, introduced=2.0)));

/**
 Вычисление хеш суммы по алгоритму SHA1
 @return Результат вычисления хеш-суммы в сыром виде `NSData`
 @see MD5, HMAC_MD5, HMAC_SHA1
 @since Available since iOS 2.0 and later
 */
-	(NSData*)	SHA1 __attribute__((const, availability(ios, introduced=2.0)));

/**
 Вычисление хеш суммы по алгоритму MD5 с модификацией результата алгоритмом HMAC
 @param hmacKey Строка-ключ для вычисления HMAC
 @return Результат вычисления хеш-суммы и применения алгоритма HMAC в сыром виде `NSData`
 @see MD5, SHA1,  HMAC_SHA1
 @since Available since iOS 2.0 and later
 */
-	(NSData*)	HMAC_MD5:(NSString*)hmacKey __attribute__((const, availability(ios, introduced=2.0)));
/**
 Вычисление хеш суммы по алгоритму SHA1 с модификацией результата алгоритмом HMAC
 @param hmacKey Строка-ключ для вычисления HMAC
 @return Результат вычисления хеш-суммы и применения алгоритма HMAC в сыром виде `NSData`
 @see MD5, SHA1,  HMAC_MD5
 @since Available since iOS 2.0 and later
 */
-	(NSData*)	HMAC_SHA1:(NSString*)hmacKey __attribute__((const, availability(ios, introduced=2.0)));


/** @name Hash sum encoding in Base64 */
/**
 Вычисление хеш суммы по алгоритму MD5 с интерпретацией в Base64
 @return Результат вычисления хеш-суммы в виде экземпляра `NSString` с интерпретацией результатов в кодировке Base64
 @see SHA1_x64, HMAC_MD5_x64, HMAC_SHA1_x64
 @since Available since iOS 2.0 and later
 */
-   (NSString*) MD5_x64 __attribute__((const, availability(ios, introduced=2.0)));
/**
 Вычисление хеш суммы по алгоритму SHA1 с интерпретацией в Base64
 @return Результат вычисления хеш-суммы в виде экземпляра `NSString` с интерпретацией результатов в кодировке Base64
 @see MD5_x64, HMAC_MD5_x64, HMAC_SHA1_x64
 @since Available since iOS 2.0 and later
 */
-   (NSString*) SHA1_x64 __attribute__((const, availability(ios, introduced=2.0)));
/**
 Вычисление хеш суммы по алгоритму MD5 с модификацией результата алгоритмом HMAC и интерпретацией в Base64
 @param hmacKey Строка-ключ для вычисления HMAC
 @return Результат вычисления хеш-суммы и применения алгоритма HMAC в виде экземпляра `NSString` с интерпретацией результатов в кодировке Base64
 @see MD5_x64, SHA1_x64,  HMAC_SHA1_x64
 @since Available since iOS 2.0 and later
 */
-   (NSString*) HMAC_MD5_x64:(NSString*)hmacKey __attribute__((const, availability(ios, introduced=2.0)));
/**
 Вычисление хеш суммы по алгоритму SHA1 с модификацией результата алгоритмом HMAC и интерпретацией в Base64
 @param hmacKey Строка-ключ для вычисления HMAC
 @return Результат вычисления хеш-суммы и применения алгоритма HMAC в виде экземпляра `NSString` с интерпретацией результатов в кодировке Base64
 @see MD5_x64, SHA1_x64,  HMAC_MD5_x64
 @since Available since iOS 2.0 and later
 */
-   (NSString*) HMAC_SHA1_x64:(NSString*)hmacKey __attribute__((const, availability(ios, introduced=2.0)));


/** @name Hash sum encoding in HEX */
/**
 Вычисление хеш суммы по алгоритму MD5 с интерпретацией в HEX
 @return Результат вычисления хеш-суммы в виде экземпляра `NSString` с интерпретацией результатов в кодировке BHEX
 @see SHA1_HEX, HMAC_MD5_HEX, HMAC_SHA1_HEX
 @since Available since iOS 2.0 and later
 */
-   (NSString*) MD5_HEX __attribute__((const, availability(ios, introduced=2.0)));
/**
 Вычисление хеш суммы по алгоритму SHA1 с интерпретацией в HEX
 @return Результат вычисления хеш-суммы в виде экземпляра `NSString` с интерпретацией результатов в кодировке HEX
 @see MD5_HEX, HMAC_MD5_HEX, HMAC_SHA1_HEX
 @since Available since iOS 2.0 and later
 */
-   (NSString*) SHA1_HEX __attribute__((const, availability(ios, introduced=2.0)));
/**
 Вычисление хеш суммы по алгоритму MD5 с модификацией результата алгоритмом HMAC и интерпретацией в HEX
 @param hmacKey Строка-ключ для вычисления HMAC
 @return Результат вычисления хеш-суммы и применения алгоритма HMAC в виде экземпляра `NSString` с интерпретацией результатов в кодировке HEX
 @see MD5_HEX, SHA1_HEX,  HMAC_SHA1_HEX
 @since Available since iOS 2.0 and later
 */
-   (NSString*) HMAC_MD5_HEX:(NSString*)hmacKey __attribute__((const, availability(ios, introduced=2.0)));
/**
 Вычисление хеш суммы по алгоритму SHA1 с модификацией результата алгоритмом HMAC и интерпретацией в HEX
 @param hmacKey Строка-ключ для вычисления HMAC
 @return Результат вычисления хеш-суммы и применения алгоритма HMAC в виде экземпляра `NSString` с интерпретацией результатов в кодировке HEX
 @see MD5_HEX, SHA1_HEX,  HMAC_MD5_HEX
 @since Available since iOS 2.0 and later
 */
-   (NSString*) HMAC_SHA1_HEX:(NSString*)hmacKey __attribute__((const, availability(ios, introduced=2.0)));


/** @name Вспомогательные методы */
/**
 Аналог `[NSString hasPrefix:prefix]` с поиском префикса в CaseInsensetive режиме
 @param prefix Проверяемый префикс строки
 @return YES в случае если стркоа имеет данный префкис, NO - в противном случае.
 @see hasCaseInsensetiveSuffix:
 @since Available since iOS 2.0 and later
 */
-   (BOOL)  hasCaseInsensetivePrefix:(NSString*)prefix __attribute__((const, availability(ios, introduced=2.0)));

-   (BOOL)  hasCaseInsensetivePrefixInAnyWord:(NSString*)prefix __attribute__((const, availability(ios, introduced=2.0)));
/**
 Аналог `[NSString hasSuffix:suffix]` с поиском суфикса в CaseInsensetive режиме
 @param suffix Проверяемый суффикс строки
 @return YES в случае если стркоа имеет данный суфикс, NO - в противном случае.
 @see hasCaseInsensetivePrefix:
 @since Available since iOS 2.0 and later
 */
-   (BOOL)  hasCaseInsensetiveSuffix:(NSString*)suffix __attribute__((const, availability(ios, introduced=2.0)));

/**
 Высота строки заданного шрифта
 
 Может быть полезно например при вычислении требуемой высоты ячейки в `UITableView` в случае если некоторая информация отображается с помощью многострочного `UILabel`.
 @param font Шрифт, для которого будет вычисляться высота строки
 @return Возвращает значение высоты одной строки для заданного шрифта `font`. 
 @since Available since iOS 2.0 and later
 */
+   (CGFloat)   oneLineTextHeightWithFont:(UIFont*)font __attribute__((pure, availability(ios, introduced=2.0)));

/**
 Кодирование URL адреса в ASCII совместимом формате (URL Percent encoding)
 
 Использует данную строку как базовый URL адрес и дополняет его закодированными Percent Encoding парами ключ-значение параметров GET запроса, передаваемых в `params`
 @param params Словарь параметров для построения GET запроса, ключами должны быть экземпляры `NSString`, параметры могу быть любыми, но все значения кроме экземпляров `NSString` и `NSNumber` игнорируются.
 @return Подготовленная строка URL запроса типа GET
 @since Available since iOS 2.0 and later
 */
-   (NSString*) preparedGetURLWithParams:(NSDictionary*)params __attribute__((const, availability(ios, introduced=2.0)));

/** @name Работа с российскими номерами телефонов*/
/**
 Нормализация номера телефона.
 
 Входящая строка рассматривается как номер телефона и производится ее нормализация. Нормализация означает только удаление всех символов из списка (" ", "(", ")", "_") и в случае если ведущей цифрой является "8" она заменяется на "+7".
 @return Нормализованное представление телефонного номера
 @see formattedRussianPhoneNumber
 @since Available since iOS 2.0 and later
 */
-   (NSString*) normalizedRussianPhoneNumber __attribute__((const, availability(ios, introduced=2.0)));
/** @name Работа с российскими номерами телефонов*/
/**
 Форматированный  номер телефона.
 
 Входящая строка рассматривается как номер телефона и возвращается ее форматированное представление. Сначала строка нормализуется, а затем форматируется в представление  "+<код страны> (<код>) <3 цифры>-<2 цифры>-<2 цифры>"
 @return Нормализованное представление телефонного номера
 @see normalizedRussianPhoneNumber
 @since Available since iOS 2.0 and later
 */
-   (NSString*) formattedRussianPhoneNumber __attribute__((const, availability(ios, introduced=2.0)));



@end
