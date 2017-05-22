//
//  HttpClient.m
//  HuiXin
//
//  Created by 文俊 on 15/11/6.
//  Copyright © 2015年 文俊. All rights reserved.
//

#import "HttpClient.h"

static NSString *kAppUrl;

@implementation HttpClient

+ (void)startWithURL:(NSString *)url{
//    kAppUrl = url;
    [self sharedInstance];
}

+ (instancetype)sharedInstance{
    static HttpClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[HttpClient alloc] init];
        client.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        client.securityPolicy.allowInvalidCertificates = YES;
        client.responseType = ResponseJSON;
        client.requestType = RequestOther;
        
    });
    return client;
}

#pragma mark - Get & set methods
- (void)setResponseType:(ResponseType)responseType{
    _responseType = responseType;
    if(responseType == ResponseXML){
        self.responseSerializer = [AFXMLParserResponseSerializer serializer];
    }else if(responseType == ResponseJSON){
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"multipart/form-data,application/json", @"text/json", @"text/javascript",@"text/html", nil];
    }else{
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
}

- (void)setRequestType:(RequestType)requestType{
    _requestType = requestType;
    if(requestType == RequestXML){
        self.requestSerializer = [AFPropertyListRequestSerializer serializer];
    }else if(requestType == RequestJSON){
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestSerializer.timeoutInterval = 30;
    }else{
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
}

@end
