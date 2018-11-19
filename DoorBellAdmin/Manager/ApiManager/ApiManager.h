//
//  ApiManager.h
//  DoorBellAdmin
//
//  Created by My Star on 5/7/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"
@interface ApiManager : NSObject
+ (void)onPostApi:(NSString *)endPoint withDic:(NSDictionary *)body withCompletion:(void (^)(NSDictionary *dic))completion failure:(void (^)(NSError *error))failure;
+ (void)onPostLoginApi:(NSDictionary *)body withCompletion:(void (^)(NSDictionary *))completion failure:(void (^)(NSError *))failure;
@end
