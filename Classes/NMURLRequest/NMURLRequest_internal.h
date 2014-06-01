//
//  NMURLRequest_internal.h
//  VKMessenger
//
//  Created by Mephi Skib on 27.03.12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

//#import "NMURLRequest.h"



@interface NMURLRequest (InternalMethods)

    ///@name Private methods
/**
 Подготовка `POST` запроса
 
 @warning *PRIVATE METHOD* - Метод предназначен только для переопределения в дочерних классах с целью реализации специфичного поведения класса.
 @return Возвращает проинициализированный экземпляр `NSMutableURLRequest` с методом исполнения `POST`. Переданные ранее через свойство `params` параметры записываются в тело запроса.
 @see   prepareGetRequest, params, httpMethod, getRandomBoundary
 @since Available since iOS 4.0 and later
 */
-   (NSMutableURLRequest*)  preparePostRequest;
/**
 Подготовка `GET` запроса
 
 @warning *PRIVATE METHOD* - Метод предназначен только для переопределения в дочерних классах с целью реализации специфичного поведения класса.
 @return Возвращает проинициализированный экземпляр `NSMutableURLRequest` с методом исполнения `GET`. Переданные ранее через свойство `params` параметры дописываются к url запроса.
 @see   preparePostRequest, params, httpMethod
 @since Available since iOS 4.0 and later
 @since Available since iOS 4.0 and later
 */
-   (NSMutableURLRequest*)  prepareGetRequest;

/**
 Генерация Boundary
 
 @warning *PRIVATE METHOD* - Метод предназначен только для переопределения в дочерних классах с целью реализации специфичного поведения класса.
 @return Возвращает случайную строку `NSString`, которая может быть в дальнейшем использована для разделения тела POST запроса
 @since Available since iOS 4.0 and later
 */
-   (NSString*)             getRandomBoundary;

-   (NSError*)              prepareErrorWithDomain:(NSString*)errorDomain
                                      andErrorCode:(NSInteger)errorCode
                                        andMessage:(NSString*)errorMessage;

    ///@name Engines
/**
 Интерпретация в виде строки
 
 @warning *PRIVATE METHOD* - Метод предназначен только для переопределения в дочерних классах с целью реализации специфичного поведения класса.
 @param error В случае если не удается разобрать ответ в виде строки, `error` содержит код возникшей ошибки.
 @see parseResponseWithSBJSON:
 @since Available in iOS 4.0 and later
 */
-   (NSString*) parseResponseAsStringWithError:(NSError**)error;

/**
 Интерпретация в виде `JSON` объекта
 
 В своей работе метод опирается предварительно на метод parseResponseAsStringWithError:
 
 @warning *PRIVATE METHOD* - Метод предназначен только для переопределения в дочерних классах с целью реализации специфичного поведения класса.
 @param error В случае если не удасться разобрать ответ в виде `JSON`, `error` содержит код возникшей ошибки.
 @see parseResponseAsStringWithError:
 @since Available in iOS 4.0 and later
 */
-   (id)        parseResponseAsSBJsonWithError:(NSError**)error;

@end
