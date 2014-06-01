//
//  NMTimeMarker.h
//  Scheme
//
//  Created by Vladimir Konev on 4/28/13.
//  Copyright (c) 2013 Novilab Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `NMTimeMetrics` - это логический класс, используемый для измерения времени исполнения частей программы. Используется только для отладки приложения. Для каждой добавляемой марки время исполнения измеряется от времени окончания предыдущего измерения.
 
 Пример использования:
        //CONSTRUCT
     NMTimeMetrics* tm   =   [NMTimeMetrics  timeMetrics];
 
         //SLEEP OPERATION
     sleep(1);
     [tm appendMark:@"Sleep for 1 second"];
     
         //LONG NETWORK SYNC OPERATION
     [NMURLRequest  requestWithUrl:@"www.google.com"
                         andParams:nil
                     andHttpMethod:kNMURLRequestHttpMethodGet
                  andParsingEngine:kNMURLRequestParsingEngineRawData
                    andFinishBlock:NULL
                      andFailBlock:NULL
                 andConnectionType:kNMURLRequestConnectionTypeSync];
     [tm appendMark:@"Get google front page in sync mode"];
     
         //LARGE ARRAY OPERATION
     NSUInteger count = 10000000;
     NSMutableArray* array   =   [[NSMutableArray    alloc]  initWithCapacity:count];
     for (NSUInteger i = 0; i < count; i++)
        [array  addObject:@(i+1)];
     [tm appendMark:@"Large array filling"];
     
         //PRINT RESULTS
     [tm print];
 
 В результате в консоль приложения будут выведены полное время измерения, и для каждой добавленной марки времени будут выведены ее абсолютное время исполнения в секундах и значение доли от общего времени исполнения в процентах:
     2013-05-10 18:18:12.867 AviaShopper[7696:907] NMTimeMarker Stats. Full: 11.989239 sec.
     2013-05-10 18:18:12.868 AviaShopper[7696:907] 1) "Sleep for 1 second". 1.001128 sec. <8.35%>
     2013-05-10 18:18:12.870 AviaShopper[7696:907] 2) "Get google front page in sync mode". 0.016030 sec. <0.13%>
     2013-05-10 18:18:12.871 AviaShopper[7696:907] 3) "Large array filling". 10.972065 sec. <91.52%>
 
 @bug Добавить возможность приостановки измерений - метода pause.
 */

@interface NMTimeMetrics : NSObject


/** @name Конструкторы */
/**
 Назначенный конструктор
 
 @return Проинициализированный экземпляр метрик
 @since Available since iOS 2.0 and later
 */
-   (instancetype)  init    __attribute__((availability(ios, introduced=2.0)));
/**
 Статический конструктор
 
 @return Проинициализированный экземпляр метрик с запущенным исполнением
 @since Available since iOS 2.0 and later
 */
+   (instancetype)  timeMetrics __attribute__((availability(ios, introduced=2.0)));

/** @name Методы*/
/**
 Запуск измерений
 
 Запускает процесс измерения времени исполнения кусков программного кода.
 @since Available since iOS 2.0 and later
 */
-   (void)  start __attribute__((availability(ios, introduced=2.0)));
/**
 Вывод результатов
 
 Выводит в отладочную консоль приложения измеренные метрики исполнения программы.
 
 @since Available since iOS 2.0 and later
 */
-   (void)  print __attribute__((availability(ios, introduced=2.0)));

-   (void)  printWithTitle:(NSString*)title
             andShortStyle:(BOOL)shortStyle;
/**
 Добавление марки
 
 Добавляет в измеряемые метрики новую запись с указанным текстовым аттрибутом.
 
 @param mark Текстовый аттрибут используемый при выводе результатов измерений в консоль.
 
 @since Available since iOS 2.0 and later
 */
-   (void)  appendMark:(NSString*)mark __attribute__((availability(ios, introduced=2.0)));



@end
