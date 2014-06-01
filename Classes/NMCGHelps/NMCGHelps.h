//
//  NMCGHelps.h
//  Scheme
//
//  Created by Vladimir Konev on 5/4/13.
//  Copyright (c) 2013 Novilab Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
/** Набор вспомогательных C функций*/

/** @name Обработка массивов представлений*/
/**
 Верхняя левая точка

 Пробегается по всем представлениям в массиве и возвращает верхнюю левую точку охватывающего прямоугольника.
 @param views Массив представлений для обработки
 @return Верхняя левая точка охватывающего прямоугольника. В случае невалидных значений или пустого массива возвращает `CGPointZero`
 @since Available since iOS 2.0 and later
 */
CGPoint NMViewsTopLeftPoint(NSArray* views)     __attribute__((const, availability(ios, introduced=2.0)));

/**
 Правая нижняя точка
 
 Пробегается по всем представлениям в массиве и возвращает правую нижнюю точку охватывающего прямоугольника.
 @param views Массив представлений для обработки
 @return Правая нижняя точка охватывающего прямоугольника. В случае невалидных значений или пустого массива возвращает `CGPointZero`
 @since Available since iOS 2.0 and later
 */
CGPoint NMViewsBottomRightPoint(NSArray* views) __attribute__((const, availability(ios, introduced=2.0)));

/**
 Охватывающий прямоугольник
 
 Пробегается по всем представлениям в массиве и возвращает охватывающий их всех прямоугольник.
 @param views Массив представлений для обработки
 @return Охватываюший прямоугольник. В случае невалидных значений или пустого массива возвращает `CGRectZero`
 @since Available since iOS 2.0 and later
 */
CGRect  NMViewsUnionFrame(NSArray* views)       __attribute__((const, availability(ios, introduced=2.0)));


BOOL    NMPathContainsRect(CGPathRef path, const CGRect rect) __attribute__((const, availability(ios, introduced=2.0)));

CGPoint NMRectGetTopLeft(const CGRect rect)     __attribute__((const, availability(ios, introduced=2.0)));
CGPoint NMRectGetBottomLeft(const CGRect rect)  __attribute__((const, availability(ios, introduced=2.0)));
CGPoint NMRectGetTopRight(const CGRect rect)    __attribute__((const, availability(ios, introduced=2.0)));
CGPoint NMRectGetBottomRight(const CGRect rect) __attribute__((const, availability(ios, introduced=2.0)));
CGPoint NMRectGetCenter(const CGRect rect)      __attribute__((const, availability(ios, introduced=2.0)));