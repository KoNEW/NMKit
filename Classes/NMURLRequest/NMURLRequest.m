//
//  NMURLRequest.m
//  CustomRequest
//
//  Created by Николай Сычев on 08.06.11.
//  Copyright 2011 СКИБ. All rights reserved.
//

#import "NMURLRequest.h"
#import "NSString+NMKit_Extenstion.h"


NSString * kNMURLRequestHttpMethodPost = @"POST";
NSString * kNMURLRequestHttpMethodGet = @"GET";
NSString * kNMURLRequestHttpMethodPut = @"PUT";
NSString * kNMURLRequestHttpMethodDelete = @"DELETE";

NSString * kNMURLRequestParsingEngineRawData = @"NMURLRequest_parse_response_as_NSData";
NSString * kNMURLRequestParsingEngineString = @"NMURLRequest_parse_response_as_NSString";
NSString * kNMURLRequestParsingEngineJSON = @"NMURLRequest_parse_response_as_JSON";


NSString * kNMURLRequestConnectionTypeAsync = @"NMURLRequest_asynchronous_connection";
NSString * kNMURLRequestConnectionTypeSync = @"NMURLRequest_synchronous_connection";



@interface NMURLRequest (){
    long long _expectedContentLength;
    NSMutableData* _data;
    NSURLConnection* _connection;
    
    NMURLRequestFinishBlock _finishBlock;
    NMURLRequestFailBlock _failBlock;
    NMURLRequestFinalizeBlock _finalizeBlock;
    NMURLRequestUploadProgressBlock _uploadProgressBlock;
    NMURLRequestDownloadProgressBlock _downloadProgressBlock;
}


-   (NSMutableURLRequest*)  preparePostRequest;
-   (NSMutableURLRequest*)  prepareGetRequest;
-   (NSString*)             getRandomBoundary;
-   (NSError*)              prepareErrorWithDomain:(NSString*)errorDomain
                                      andErrorCode:(NSInteger)errorCode
                                        andMessage:(NSString*)errorMessage;

-   (NSString*) parseResponseAsStringWithError:(NSError**)error;
-   (id)        parseResponseAsJSONWithError:(NSError**)error;

@end

@implementation NMURLRequest


#pragma mark    -   Constructors
-   (void)  dealloc{
    [_connection    cancel];
}

-   (instancetype) initWithUrl:(NSString *)url
                      andParams:(NSDictionary *)params
                  andHttpMethod:(NSString *)httpMethod
               andParsingEngine:(NSString *)parsingEngine
                 andFinishBlock:(NMURLRequestFinishBlock)finishBlock
                   andFailBlock:(NMURLRequestFailBlock)failBlock{
    
    self    =   [self   initWithUrl:url
                          andParams:params
                      andHttpMethod:httpMethod
                   andParsingEngine:parsingEngine
                     andFinishBlock:finishBlock
                       andFailBlock:failBlock
                  andConnectionType:kNMURLRequestConnectionTypeAsync];

    return self;
}

-   (instancetype) initWithUrl:(NSString *)url
                      andParams:(NSDictionary *)params
                  andHttpMethod:(NSString *)httpMethod
               andParsingEngine:(NSString *)parsingEngine
                 andFinishBlock:(NMURLRequestFinishBlock)finishBlock
                   andFailBlock:(NMURLRequestFailBlock)failBlock
              andConnectionType:(NSString *)connectionType {
    
    self = [super init];
    
    if (self){
        self.url = url;
        self.params = params;
        self.httpMethod = httpMethod;
        self.parsingEngine = parsingEngine;
        self.finishBlock = finishBlock;
        self.failBlock = failBlock;
        self.connectionType = connectionType;
    }
    
    return self;
}

+   (instancetype) requestWithUrl:(NSString *)url
                         andParams:(NSDictionary *)params
                     andHttpMethod:(NSString *)httpMethod
                  andParsingEngine:(NSString *)parsingEngine
                    andFinishBlock:(NMURLRequestFinishBlock)finishBlock
                      andFailBlock:(NMURLRequestFailBlock)failBlock{
    @autoreleasepool {
        NMURLRequest*   request =   [[NMURLRequest  alloc]  initWithUrl:url
                                                              andParams:params
                                                          andHttpMethod:httpMethod
                                                       andParsingEngine:parsingEngine
                                                         andFinishBlock:finishBlock
                                                           andFailBlock:failBlock];
        
        [request    start];
        
        return request;
    }
}

+   (instancetype) requestWithUrl:(NSString *)url
                         andParams:(NSDictionary *)params
                     andHttpMethod:(NSString *)httpMethod
                  andParsingEngine:(NSString *)parsingEngine
                    andFinishBlock:(NMURLRequestFinishBlock)finishBlock
                      andFailBlock:(NMURLRequestFailBlock)failBlock
                 andConnectionType:(NSString *)connectionType {
    
    @autoreleasepool {
        NMURLRequest*   request =   [[NMURLRequest  alloc]  initWithUrl:url
                                                              andParams:params
                                                          andHttpMethod:httpMethod
                                                       andParsingEngine:parsingEngine
                                                         andFinishBlock:finishBlock
                                                           andFailBlock:failBlock
                                                      andConnectionType:connectionType];
        [request    start];
        
        return request;
    }
}

- (instancetype) init{
    return nil;
}

#pragma mark    -   LifeCycle


-   (void)  start{
    [self   cancel];
    
    NSMutableURLRequest*    request;
    
    if ([_httpMethod    isEqualToString:kNMURLRequestHttpMethodPost])
        request =   [self   preparePostRequest];
    else
        request =   [self   prepareGetRequest];

    NMLog(@"%@",request);
    
    if ([_connectionType isEqualToString:kNMURLRequestConnectionTypeAsync]) {
        
        _connection =   [NSURLConnection    connectionWithRequest:request
                                                         delegate:self];
        _expectedContentLength =   NSURLResponseUnknownLength;
    }
    else if ([_connectionType   isEqualToString:kNMURLRequestConnectionTypeSync]) {

        NSURLResponse*  response    =   nil;
        NSError*        error       =   nil;
        _data   =   [NSMutableData  dataWithData:[NSURLConnection    sendSynchronousRequest:request
                                                                          returningResponse:&response error:&error]];
        
        if (_data) {
            [self   connectionDidFinishLoading:nil];
        }
        else {
            [self   connection:nil didFailWithError:error];
        }
    }
    
}

-   (void)  cancel{
    [_connection    cancel];
    _connection =   nil;
    _data       =   nil;
}

#pragma mark    -   Blocks
-   (void)  setFinishBlock:(NMURLRequestFinishBlock)finishBlock{
    _finishBlock  =   finishBlock;
}

-   (void)  setFailBlock:(NMURLRequestFailBlock)failBlock{
    _failBlock  =   failBlock;
}

-   (void)  setFinalizeBlock:(NMURLRequestFinalizeBlock)finalizeBlock{
    _finalizeBlock  =   finalizeBlock;
}

-   (void)  setUploadProgressBlock:(NMURLRequestUploadProgressBlock)uploadProgressBlock{
    _uploadProgressBlock    =   uploadProgressBlock;
}

-   (void)  setDownloadProgressBlock:(NMURLRequestDownloadProgressBlock)downloadProgressBlock{
    _downloadProgressBlock  =   downloadProgressBlock;
}


#pragma mark    -   Internal Methods

-   (NSMutableURLRequest*)  prepareGetRequest{
    NSMutableURLRequest*    request =   [[NSMutableURLRequest   alloc]  init];
    
        //GENERAL
    [request    setHTTPMethod:kNMURLRequestHttpMethodGet];
    NSString*   effectiveUrl    =   [_url preparedGetURLWithParams:_params];
    [request    setURL:[NSURL   URLWithString:effectiveUrl]];
    
    return request;
}

-   (NSMutableURLRequest*)  preparePostRequest{
    NSMutableURLRequest*    request =   [[NSMutableURLRequest   alloc]  init];
    
        //GENERAL
    [request    setHTTPMethod:kNMURLRequestHttpMethodPost];
    [request    setURL:[NSURL   URLWithString:_url]];
    
        //HTTP HEADERS
    NSString*   boundary    =   [NSString   stringWithFormat:@"%@", [self   getRandomBoundary]];
    [request    setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
      forHTTPHeaderField:@"Content-Type"];
    
    
        //PREPARE BODY
    NSMutableData*  httpBody=   [[NSMutableData alloc]  init];
    [httpBody   appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    for (NSString*  paramName in [_params.allKeys objectEnumerator]){
        id  value   =   [_params    objectForKey:paramName];
        NSString*   contentType         =   nil;
        NSString*   contentAdditional   =   nil;
        NSData* representation;
        if ([value  isKindOfClass:[NSString class]] ||  [value  isKindOfClass:[NSNumber class]]){
            representation  =   [[value  description]   dataUsingEncoding:NSUTF8StringEncoding];
        }else if ([value isKindOfClass:[NSData class]]){
            representation  =   value;
            contentType     =   @"Content-Type: application/octet-stream;";
        } else if ([value isKindOfClass:[UIImage class]]){
            representation  =   UIImagePNGRepresentation(value);
            contentType     =   @"Content-Type: image/png;";
            contentAdditional   =   [NSString stringWithFormat:@" filename=\"%@\".png",paramName];
        }else
            continue;
        
        [httpBody   appendData:[[NSString   stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        if (contentAdditional   ==  nil)
            [httpBody   appendData:[[NSString   stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", paramName]  dataUsingEncoding:NSUTF8StringEncoding]];
        else
            [httpBody   appendData:[[NSString   stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; %@\r\n", paramName, contentAdditional]  dataUsingEncoding:NSUTF8StringEncoding]];
            
        if (contentType !=  nil)
            [httpBody   appendData:[[NSString   stringWithFormat:@"%@\r\n", contentType]    dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody   appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody   appendData:representation];
    }
    
    [httpBody   appendData:[[NSString   stringWithFormat:@"\r\n--%@--\r\n", boundary]   dataUsingEncoding:NSUTF8StringEncoding]];
    [request    setHTTPBody:httpBody];
    
    [request    setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[request.HTTPBody length]]
      forHTTPHeaderField:@"Content-Length"];
    
    return request;
}


-   (NSString*) getRandomBoundary{
    srand(time(NULL));
    
    NSString*   randomString    =   [NSString   stringWithFormat:@"%i", arc4random()];
    
    return [randomString    MD5_HEX];
}

-   (void)  setHttpMethod:(NSString *)httpMethod{
    if (httpMethod  ==  _httpMethod)
        return;
    
    static  NSArray*    validMethods    =   nil;
    if (validMethods    !=  nil)
        validMethods    =   [NSArray    arrayWithObjects:kNMURLRequestHttpMethodGet, kNMURLRequestHttpMethodPost, nil];
    
    if ([validMethods   containsObject:httpMethod])
        _httpMethod =   httpMethod;
}

-   (void)  setConnectionType:(NSString *)connectionType{
    if (connectionType  ==  _connectionType)
        return;
    
    static  NSArray*    validTypes  =   nil;
    if (validTypes  ==  nil)
        validTypes  =   [NSArray    arrayWithObjects:kNMURLRequestConnectionTypeSync, kNMURLRequestConnectionTypeAsync, nil];
    
    if ([validTypes containsObject:connectionType])
        _connectionType =   connectionType;
}



-   (NSError*)  prepareErrorWithDomain:(NSString *)errorDomain
                          andErrorCode:(NSInteger)errorCode
                            andMessage:(NSString *)errorMessage{ 
    NSError*    error   =   [[NSError   alloc]  initWithDomain:errorDomain
                                                          code:errorCode
                                                      userInfo:[NSDictionary    dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey]];
    
    return error;
}

#pragma mark    -   NMURLRequestParserEngines
-   (NSString*) parseResponseAsStringWithError:(NSError **)error{
    NSString*   result  =   [[NSString  alloc]  initWithData:_data
                                                    encoding:NSUTF8StringEncoding];
    
    return result;
}

-   (id)    parseResponseAsJSONWithError:(NSError **)error{
    id result = [NSJSONSerialization JSONObjectWithData:_data
                                                options:0
                                                  error:error];
    
    if (*error != nil){
        NMLog(@"NMURLRequest. JSON parser failed with reason: %@", *error);
    }
    
    return result;
}


#pragma mark    -   NSURLConnection Protocol

-   (void)  connection:(NSURLConnection *)connection
    didReceiveResponse:(NSURLResponse *)response{
    _expectedContentLength  =   response.expectedContentLength;
}

-   (void)  connection:(NSURLConnection *)connection
        didReceiveData:(NSData *)data{
    if (_data   ==  nil)
        _data   =   [[NSMutableData alloc]  init];
    
    [_data  appendData:data];
    
    if (_expectedContentLength !=  NSURLResponseUnknownLength  &&
        _expectedContentLength >  0 &&
        _downloadProgressBlock  !=  NULL){
        long long bytesReceived =   [_data length];
        long long bytesTotal    =   _expectedContentLength;
        
        _downloadProgressBlock(bytesReceived, bytesTotal);
    }
}

-   (void)  connection:(NSURLConnection *)connection
      didFailWithError:(NSError *)error{
    if (_failBlock  !=  NULL)
        _failBlock(error);
    
    if (_finalizeBlock  !=  NULL)
        _finalizeBlock();
}

-   (void)  connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError*    error   =   nil;
    
    if (_parsingEngine  ==  nil ||  ![_parsingEngine    isKindOfClass:[NSString class]]){
        error   =   [self   prepareErrorWithDomain:kNMURLRequestErrorDomain
                                      andErrorCode:kNMURLRequestErrorDefaultCode
                                        andMessage:kNMUrlRequestErrorParsingUknownEngine];
        [self   connection:connection
          didFailWithError:error];
        return;
    }
    
    id  response    =   nil;
    if ([_parsingEngine isEqualToString:kNMURLRequestParsingEngineRawData])
        response    =   _data;
    else if ([_parsingEngine    isEqualToString:kNMURLRequestParsingEngineString])
        response    =   [self   parseResponseAsStringWithError:&error];
    else if ([_parsingEngine    isEqualToString:kNMURLRequestParsingEngineJSON])
        response = [self parseResponseAsJSONWithError:&error];
    else
        error       =   [self   prepareErrorWithDomain:kNMURLRequestErrorDomain
                                          andErrorCode:kNMURLRequestErrorDefaultCode
                                            andMessage:kNMUrlRequestErrorParsingUknownEngine];
    
    if (error   !=  nil){
        [self   connection:connection
          didFailWithError:error];
        return;
    }else{
        if (_finishBlock    !=  NULL)
            _finishBlock(response);
        
        if (_finalizeBlock  !=  NULL)
            _finalizeBlock();
    }
}

-   (void)  connection:(NSURLConnection *)connection
       didSendBodyData:(NSInteger)bytesWritten
     totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    if (_uploadProgressBlock    !=  NULL){
        long long bytesSent =   (long long) totalBytesWritten;
        long long bytesTotal=   (long long) totalBytesExpectedToWrite;
        _uploadProgressBlock(bytesSent, bytesTotal);
    }
}

/// SSL METHODS

-   (BOOL)  connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

-   (void)  connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
     
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
