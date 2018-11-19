//
//  Utilities.h
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "AppSettingModel.h"
@interface Utilities : NSObject
+ (NSString *)generateRandomID;
+ (NSString *)getDeviceID;
+ (void)sendEmailNotification:(NSString *)toEmail withToEmail:(NSString *)fromEmail withBody:(NSMutableDictionary *)notificationBody;
+ (void)saveUserObject:(UserModel *)object;
+ (UserModel *)loadUserObjectWithKey;
+ (void)saveAppSetModelObject:(AppSettingModel *)object;
+ (AppSettingModel *)loadAppSetModelObjectWithKey;
+ (void)resetDefaults ;
@end
