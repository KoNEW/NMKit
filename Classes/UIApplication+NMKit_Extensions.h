//
//  UIApplication+NMKit_Extensions.h
//  VKMessenger
//
//  Created by Mephi Skib on 22.03.12.
//  Copyright (c) 2012 Novilab Mobile. All rights reserved.
//

/** 
 Набор категорий для класса UIApplication
 
 ### Примеры использования ### 
 
     [UIApplication redirectLogOutputToDocumentsFolder];
     [UIApplication redirectLogOutputToDocumentsFolderWithFileName:@"logfile.log"];
     [UIApplication openURL:@"http://www.novilabmobile.ru"];
     [UIApplication callPhone:@"+7(999)111-11-11"];
     [UIApplication sendSMS:@"+7(999)111-11-11"];
 
 */

#import <Foundation/Foundation.h>

@interface UIApplication (NMKit_Extensions)

/** @name Перенаправление записей логов */

/** Перенавправляет все логи в файл в папке документов приложения.
 
 При старте приложения создается специальный файл логов с указанием даты и времени первой записи в него.
 Формат названия файла LogConsole_MM-dd_HH:mm:ss.log.
 Вытащить файл можно потом через iTunes, предварительно установив для приложения флаг iTunesFileSharing в YES в plist файле настроек проекта.
 
 */
+   (void)  redirectLogOutputToDocumentsFolder;

/** Перенаправляет все логи в указанный файл.
 
 @param fileName Полный путь к файлу куда необходимо записывать логи.
 */
+   (void)  redirectLogOutputToDocumentsFolderWithFileName:(NSString*)fileName;

/** @name Открытие различных URL адресов */

/** Открытие заданного URL адреса.

 @warning *Как это работает:* Распознается URL-схема и происходит вызов соответствующего системного или стороннего обработчика.
 
 #### Например ####
 - Схемы http, https открывают Safari
 - Схема tel пытается открыть приложение "Телефон" и осуществить звонок по указанному номеру телефона
 - Схема itms пытается открыть App Store или iTunes на устройстве и найти указанный объект
 
 @param url Полный URL-адрес открываемого объекта
 */
+   (void)  openURL:(NSString*)url;

/** Пытается осуществить звонок на указанный номер телефона
 
 @param phoneNumber Номер телефона в произвольном формате, например "+7(999)111-11-11"
 */
+   (void)  callPhone:(NSString*)phoneNumber;

/** Пытается открыть интерфейс отправки SMS сообщения на указанный номер телефона.
 
 @param phoneNumber Номер телефона в произвольном формате, например "+7(999)111-11-11"
 */
+   (void)  sendSMS:(NSString*)phoneNumber;

@end
