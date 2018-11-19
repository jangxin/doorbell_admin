//
//  ApiManager.m
//  DoorBellAdmin
//
//  Created by My Star on 5/7/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import "ApiManager.h"

@implementation ApiManager
+ (void)onPostApi:(NSString *)endPoint withDic:(NSDictionary *)body withCompletion:(void (^)(NSDictionary *))completion failure:(void (^)(NSError *))failure
{
    NSDictionary *headers = @{ @"content-type": @"application/json"};
    NSData *postData;
    if (body == nil) {
        postData = nil;
    }else {
        postData = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    }
    NSString *strURL = [NSString stringWithFormat:@"%@%@",baseURL,endPoint];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        failure(error);
                                                    } else {
                                                        NSDictionary* json = [NSJSONSerialization
                                                                              JSONObjectWithData:data
                                                                              options:kNilOptions
                                                                              error:&error];
                                                        completion(json);
                                                    }
                                                }];
    [dataTask resume];
    
}

+ (void)onPostLoginApi:(NSDictionary *)body withCompletion:(void (^)(NSDictionary *))completion failure:(void (^)(NSError *))failure
{
    NSDictionary *headers = @{ @"content-type": @"application/json"};
    NSData *postData;
    if (body == nil) {
        postData = nil;
    }else {
        postData = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    }
    NSString *strURL = [NSString stringWithFormat:@"%@%@",baseLogInURL,login];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        failure(error);
                                                    } else {
                                                        NSDictionary* json = [NSJSONSerialization
                                                                              JSONObjectWithData:data
                                                                              options:kNilOptions
                                                                              error:&error];
                                                        completion(json);
                                                    }
                                                }];
    [dataTask resume];
    
}
@end
