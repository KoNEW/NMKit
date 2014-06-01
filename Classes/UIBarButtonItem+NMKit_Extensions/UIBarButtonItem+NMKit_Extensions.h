//
//  UIBarButtonItem+NMKit_Extensions.h
//  VKMessenger
//
//  Created by Vladimir Konev on 3/20/12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

/**
 Набор категорий для класса `UIBarButtonItem`
 
 #### Пример использования ####
 
     [UIBarButtonItem setBackButtonBackgroundImages:@"navBarButtonBack"];
     [UIBarButtonItem setButtonBackgroundImages:@"navBarButton"];
 */

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (NMKit_Extensions)

/** @name UIAppearance расширения*/

/** Устанавливает фоновую картинку для кнопки "Назад" в `UIBarButtonItem`
 
 Имя файла обрабатывается следующим образом, например для имени @"image":
 
 - `[UIImage imageNamed:@"image"]` для нормального состояния кнопки (`UIControlStateNormal`);
 - `[UIImage imageNamed:@"image_h"]` для подсвеченного состояния кнопки (`UIContrlStateHighlighted`);
 - Если текущее устройство это iPhone / iPod Touch
    - `[UIImage imageNamed:@"image~L"]` для нормального состояния кнопки в альбомной ориентации;
    - `[UIImgae imageNamed:@"image_h~L"]` для подсвеченного состояния кнопки в альбомной ориентации;
 
 @bug Необходимо дописать распознавание устройства, чтобы также автоматически устанавливать фоновое изображние для iPad.
 @bug Необходимо дописать распознавание расширения файла, чтобы файлы типа @"image.png" также распознавались корректно.
 
 @since Available in iOS 5.0 and later
 
 @param imageName Имя изображние для установки
 */
+   (void)  setBackButtonBackgroundImages:(NSString*)imageName  __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_5_0);


/** @name UIAppearance расширения*/

/** Устанавливает фоновую картинку для всех кнопок в `UIBarButtonItem`
 
 Имя файла обрабатывается следующим образом, например для имени @"image":
 
 - `[UIImage imageNamed:@"image"]` для нормального состояния кнопки (`UIControlStateNormal`);
 - `[UIImage imageNamed:@"image_h"]` для подсвеченного состояния кнопки (`UIContrlStateHighlighted`);
 - Если текущее устройство это iPhone / iPod Touch
 - `[UIImage imageNamed:@"image~L"]` для нормального состояния кнопки в альбомной ориентации;
 - `[UIImgae imageNamed:@"image_h~L"]` для подсвеченного состояния кнопки в альбомной ориентации;
 
 @bug Необходимо дописать распознавание устройства, чтобы также автоматически устанавливать фоновое изображние для iPad.
 @bug Необходимо дописать распознавание расширения файла, чтобы файлы типа @"image.png" также распознавались корректно.
 
 @since Available in iOS 5.0 and later
 
 @param imageName Имя изображние для установки
 */
+   (void)  setButtonBackgroundImages:(NSString*)imageName      __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_5_0);

@end
