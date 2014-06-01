
//
//  NSData+NMKit_Extensions.h
//  VKMessenger
//
//  Created by Mephi Skib on 27.03.12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//


/** Набор категорий для класса NSData*/
@interface NSData (NMKit_Extensions)

/** 
 Интерпретация в HEX
 Каждый байт интерпретируется как число в шестьнадцатиричной системе счисления и на выход записывается его строковое представление (при необходимости с ведущим нулем).
 @return Возвращает интерпретацию данных как HEX строки.
 @since Available in iOS 2.0 and later
 */
-   (NSString*) hexValue __attribute__((const, availability(ios, introduced=2.0)));

/**
 Интерпретация в Base64
 Все данные интепретируются как Base64 строка.
 @return Возвращает интерпретацию данных как Base64 строки
 @since Available in iOS 2.0 and later
 */
-   (NSString*) base64Value __attribute__((const, availability(ios, introduced=2.0)));;

@end
