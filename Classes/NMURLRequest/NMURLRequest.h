//
//  NMURLRequest.h
//  CustomRequest
//
//  Created by Николай Сычев on 08.06.11.
//  Copyright 2011 СКИБ. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString* kNMURLRequestHttpMethodPost;
extern NSString* kNMURLRequestHttpMethodGet;
extern NSString* kNMURLRequestHttpMethodPut;
extern NSString* kNMURLRequestHttpMethodDelete;

extern NSString* kNMURLRequestParsingEngineRawData;
extern NSString* kNMURLRequestParsingEngineString;
extern NSString* kNMURLRequestParsingEngineJSON;

extern NSString* kNMURLRequestConnectionTypeAsync;
extern NSString* kNMURLRequestConnectionTypeSync;

    //ERROR Constants
#define kNMURLRequestErrorDomain                @"ru.novilab-mobile.nmurlrequest.error"
#define kNMUrlRequestErrorParsingUknownEngine   @"NMURLRequest error uknown engine"
#define kNMURLRequestErrorParsingWrongFormat    @"NMURLRequest error wrong format"
#define kNMURLRequestErrorDefaultCode           -1000


/** 
 Обертка вокруг класса NSURLRequest для более высокоуровневого исполнения кода.
 
 ###Пример использования###
 Вариант работы на блоках:
    -   (void) someMethod{
        ..
        NSString*   host    =   @"http://www.example.com";

        NMURLRequestFinishBlock finishBlock =   ^(id response){
        NMLog(@"Finished with response: %@", response);
        };

        NMURLRequestFailBlock   failBlock   =   ^(NSError*  error){
        NMLog(@"Sync request failed with error: %@", error);
        };

        [NMURLRequest  requestWithUrl:host
                            andParams:nil
                        andHttpMethod:kNMURLRequestHttpMethodPost
                     andParsingEngine:kNMURLRequestParsingEngineSBJSON
                       andFinishBlock:finishBlock
                         andFailBlock:failBlock]; 
        ..
    }
 
 ###БЛОКИ###
 
    **Finish Block**
    typedef void (^NMURLRequestFinishBlock)(id response);
    _response_ - Содержит разобранный согласно представленному движку ответ от запрашиваемого URL адреса
 
    **Fail Block**
    typedef void (^NMURLRequestFailBlock)(NSError*  error);
    _error_ - Содержит описание, возникшей при исполнении или разборе запроса ошибки
 
    **Finalize Block**
    typedef void (^NMURLRequestFinalizeBlock);
 
    **Upload Progress Block**
    typedef void (^NMURLRequestUploadProgressBlock)(long long bytesSent, long long bytesTotal);
     _bytesSent_ - Отправленный объем данных в байтах
     _bytesTotal_ - Общий прогнозируемый объем отправляемых данных
 
    **Download Progress Block**
    typedef void (^NMURLRequestDownloadProgressBlock)(long long bytesReceived, long long bytesTotal);
     _bytesReceived_ - Полученный объем данных в байтах
     _bytesTotal_ - Общий прогнозируемый объем скачиваемых данных
 
 ###DEFINES###
     #define kNMURLRequestHttpMethodPost             @"POST"
     #define kNMURLRequestHttpMethodGet              @"GET"
     
     #define kNMURLRequestParsingEngineRawData       @"NMURLRequest_parse_response_as_NSData"
     #define kNMUrlRequestParsingEngineString        @"NMURLRequest_parse_response_as_NSString"
     #define kNMURLRequestParsingEngineSBJSON        @"NMURLRequest_parse_response_with_SBJSON_engine"
 */

typedef void (^NMURLRequestFinishBlock)(id response);
typedef void (^NMURLRequestFailBlock)(NSError*  error);
typedef void (^NMURLRequestFinalizeBlock)(void);
typedef void (^NMURLRequestUploadProgressBlock)(long long bytesSent, long long bytesTotal);
typedef void (^NMURLRequestDownloadProgressBlock)(long long bytesReceived, long long bytesTotal);


@interface NMURLRequest : NSObject  <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

/** @name Свойства */
/**
 Запрашиваемый URL адрес.
 */

@property(nonatomic, copy)      NSString*       url;
/**
 Словарь с параметрами.
 
 В качестве ключей принимает на вход экземпляры классов NSNumber, NSString.
 
 - При GET запросе может принимать в качестве значений словаря также только экземпляры `NSString`, `NSNumber`, все прочие значения игнорируются.
 - При POST запроса словарь может включать в себя также экземпляры `NSData`, `UIImage`. Все прочие значения игнорируются.
 */
@property(nonatomic, strong)    NSDictionary*   params;

/** 
 Метод выполнения HTTP запроса.
 
 На текущий момент реализованы только два метода исполнения запроса - GET и POST.
 
 Для установки метода рекоменудется использовать константные значения из числа:
 
 - `kNMURLRequestHttpMethodGet` - GET запроса
 - `kNMURLRequestHttpMethodPost` - POST запроса
 */
@property(nonatomic, strong, setter = setHttpMethod:)      NSString*       httpMethod;

/**
 Метод разбора данных запроса.
 
 Возможные значения из перечня:
 
 - `kNMURLRequestParsingEngineRawData` - вернуть "сырые данные", возвращаемый делегатом объект является экземпляром класса NSData
 - `kNMUrlRequestParsingEngineString` - проинтерпретировать сырые данные в виде строки в кодировке UTF8, возвращаемый делегатом объект является экземпляром класса `NSString`
 - `kNMURLRequestParsingEngineSBJSON` - проинтерпретировать сырые данные в виде JSON объекта, возвращаемый делегатом объект является в зависимости от вида верхнеуровневого JSON объекта либо экземпляром `NSArray`, либо `NSDictionary`
 */
@property(nonatomic, strong)    NSString*       parsingEngine;

/**
 Стратегия выполнения запроса.
 
 Запрос может быть выполнен в синхронном и асинхронном режимах.
 
 Возможные значения из перечня:
 
 - `kNMURLRequestConnectionTypeAsync` - асинхронное выполнение запроса
 - `kNMURLRequestConnectionTypeSync`- синхронное выполнение запроса
 */
@property(nonatomic, strong)    NSString*       connectionType;


/** @name   Конструкторы */
/** 
 Тривиальный конструктор.
 Возвращает экземпляр класса с параметрами по умолчанию, то есть: `url=nil`,`params=nil`.
 @return Проинициализированный экземпляр класса `NMURLRequest`
 */
-   (instancetype) init;

/**
 Возвращает экземпляр класса с заданными параметрами `url, params, httpMethod, parsingEngine, finishBlock, failBlock`.
 
 По умолчанию запрос будет испольняться в асинхронном режиме.
 
 @param url Запрашиваемый URL адрес
 @param params Словарь с параметрами запроса
 @param httpMethod Метод выполнения запроса
 @param parsingEngine Используемый для разбора данных движок
 @param finishBlock Блок кода вызываемый по результатам успешного исполнения запроса
 @param failBlock Блок кода вызываемый по результатам завершения исполнения запроса с ошибкой
 @since Available since iOS 4.0 and later
 @return Проинициализированный с заданными параметрами экемпляр класса `NMURLRequest`.
 @see url, params, httpMethod, parsingEngine, setFinishBlock, setFailBlock
 */
-   (instancetype) initWithUrl:(NSString*)url
                      andParams:(NSDictionary*)params
                  andHttpMethod:(NSString*)httpMethod
               andParsingEngine:(NSString*)parsingEngine
                 andFinishBlock:(NMURLRequestFinishBlock)finishBlock
                   andFailBlock:(NMURLRequestFailBlock)failBlock;

/**
 Возвращает экземпляр класса с заданными параметрами `url, params, httpMethod, parsingEngine, finishBlock, failBlock, connectionType`.
 @param url Запрашиваемый URL адрес
 @param params Словарь с параметрами запроса
 @param httpMethod Метод выполнения запроса
 @param parsingEngine Используемый для разбора данных движок
 @param finishBlock Блок кода вызываемый по результатам успешного исполнения запроса
 @param failBlock Блок кода вызываемый по результатам завершения исполнения запроса с ошибкой
 @param connectionType Режим выполнения запроса, синхронный или асинхронный
 @since Available since iOS 4.0 and later
 @return Проинициализированный с заданными параметрами экемпляр класса `NMURLRequest`.
 @see url, params, httpMethod, parsingEngine, connectionType, setFinishBlock, setFailBlock
 */
-   (instancetype) initWithUrl:(NSString*)url
                      andParams:(NSDictionary*)params
                  andHttpMethod:(NSString*)httpMethod
               andParsingEngine:(NSString*)parsingEngine
                 andFinishBlock:(NMURLRequestFinishBlock)finishBlock
                   andFailBlock:(NMURLRequestFailBlock)failBlock
              andConnectionType:(NSString*)connectionType;

/**
 Возвращает экземпляр класса с заданными параметрами `url, params, httpMethod, parsingEngine, finishBlock, failBlock`.
 
 Создаваемый экземпляр класса при этом автоматически отправляется в очередь запросов.
 
 @param url Запрашиваемый URL адрес
 @param params Словарь с параметрами запроса
 @param httpMethod Метод выполнения запроса
 @param parsingEngine Используемый для разбора данных движок
 @param finishBlock Блок кода вызываемый по результатам успешного исполнения запроса
 @param failBlock Блок кода вызываемый по результатам завершения исполнения запроса с ошибкой
 @since Available since iOS 4.0 and later
 @return Проинициализированный с заданными параметрами экемпляр класса `NMURLRequest`.
 @see url, params, httpMethod, parsingEngine, setFinishBlock, setFailBlock
 */
+   (instancetype) requestWithUrl:(NSString*)url
                         andParams:(NSDictionary*)params
                     andHttpMethod:(NSString*)httpMethod
                  andParsingEngine:(NSString*)parsingEngine
                    andFinishBlock:(NMURLRequestFinishBlock)finishBlock
                      andFailBlock:(NMURLRequestFailBlock)failBlock;

/**
 Возвращает экземпляр класса с заданными параметрами `url, params, httpMethod, parsingEngine, finishBlock, failBlock, connectionType`.
 
 Создаваемый экземпляр класса при этом автоматически отправляется в очередь запросов.
 
 @param url Запрашиваемый URL адрес
 @param params Словарь с параметрами запроса
 @param httpMethod Метод выполнения запроса
 @param parsingEngine Используемый для разбора данных движок
 @param finishBlock Блок кода вызываемый по результатам успешного исполнения запроса
 @param failBlock Блок кода вызываемый по результатам завершения исполнения запроса с ошибкой
 @since Available since iOS 4.0 and later
 @return Проинициализированный с заданными параметрами экемпляр класса `NMURLRequest`.
 @see url, params, httpMethod, parsingEngine,connectionType, setFinishBlock, setFailBlock
 @param connectionType Режим выполнения запроса, синхронный или асинхронный
 */
+   (instancetype) requestWithUrl:(NSString*)url
                         andParams:(NSDictionary*)params
                     andHttpMethod:(NSString*)httpMethod
                  andParsingEngine:(NSString*)parsingEngine
                    andFinishBlock:(NMURLRequestFinishBlock)finishBlock
                      andFailBlock:(NMURLRequestFailBlock)failBlock
                 andConnectionType:(NSString*)connectionType;

    /// @name Методы экземпляра
/**
 Остановка запроса
 
 Обраывается исполнение текущего запроса. Внутренний запрос и скачанные данные обнуляются.
 
 @see   start
 @since Available since iOS 4.0 and later
 */
-   (void)  cancel;

/**
 Запуск запроса
 
 Начинает исполнение запроса к указанному URL адресу с заданными параметрами. Если в момент запуска запрос находится в активном состоянии, он обрывается вызовом метода cancel.
 @see   cancel
 @since Available since iOS 4.0 and later
 */
-   (void)  start;


/**
 Блок удачного исполнения кода
 
 @param finishBlock Данный блок кода вызывается по результатам успешного выполнения запроса - экземпляр `NMURLRequestFinishBlock`.
 @since Available since iOS 4.0 and later
 */

-   (void)  setFinishBlock:(NMURLRequestFinishBlock)finishBlock;
/**
 Блок возникновения ошибки
 
 @param failBlock Данный блок кода вызывается в случае если при исполнении запроса возникла та или иная ошибка - экземпляр `NMURLRequestFailBlock`
 @since Available since iOS 4.0 and later
 */
-   (void)  setFailBlock:(NMURLRequestFailBlock)failBlock;

/**
 Финальный блок
 
 @param finalizeBlock Данный блок кода вызывается после завершения выполнения запроса как при успешном завершении запроса, так и в случае ошибки - экземпляр `NMURLRequestFinalizeBlock`
 @since Available since iOS 4.0 and later
 */
-   (void)  setFinalizeBlock:(NMURLRequestFinalizeBlock)finalizeBlock;

/**
 Блок прогресса загрузки запроса
 
 @param uploadProgressBlock Данный блок кода вызывается по мере загрузки тела запроса на сервер - экземпляр `NMURLRequestUploadProgressBlock`
 @since Available since iOS 4.0 and later
 */
-   (void)  setUploadProgressBlock:(NMURLRequestUploadProgressBlock)uploadProgressBlock;

/**
 Блок прогресса загрузки ответа
 
 @param downloadProgressBlock Данный блок кода вызывается по мере загрузки тела ответа - экземпляр `NMURLRequestDownloadProgressBlock`
 @since Available since iOS 4.0 and later
 */
-   (void)  setDownloadProgressBlock:(NMURLRequestDownloadProgressBlock)downloadProgressBlock;

@end