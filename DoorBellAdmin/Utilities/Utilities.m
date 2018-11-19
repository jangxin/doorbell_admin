//
//  Utilities.m
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import "Utilities.h"
#import <UIKit/UIKit.h>
@implementation Utilities
#pragma mark GenerateRandomID

+ (NSString *)generateRandomID
{
    NSInteger len = 12;
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}
+(NSString *)getDeviceID{
    NSString *UDID;
    UDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"output is : %@", UDID);
    return UDID;
}
+ (void)saveUserObject:(UserModel *)object{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"USERMODEL"];
    [defaults synchronize];
    
}

+ (UserModel *)loadUserObjectWithKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"USERMODEL"];
    UserModel *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

+ (void)saveAppSetModelObject:(AppSettingModel *)object{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"AppSettingModel"];
    [defaults synchronize];
    
}

+ (AppSettingModel *)loadAppSetModelObjectWithKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"AppSettingModel"];
    AppSettingModel *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}
+ (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}
#pragma mark Send Push Notification with RegistToken
+ (void)sendEmailNotification:(NSString *)toEmail withToEmail:(NSString *)fromEmail withBody:(NSMutableDictionary *)notificationBody
{
    
    
    
    NSDictionary *bodyDic = @{@"personalizations":
                                  @[
                                      @{@"to": @[
                                                @{@"email": toEmail}
                                                ]
                                        }
                                      ],
                              @"from": @{
                                      @"email": fromEmail
                                      },
                              @"subject": @"New Expenses ",
                              @"content": @[
                                      @{@"type": @"text/plain",
                                        @"value": notificationBody}
                                      ]};
    
    
    NSString *baseURL = @"https://api.sendgrid.com/v3/mail/send";
    
    
    NSLog(@"%@",bodyDic);
    __block NSMutableDictionary *resultsDictionary;
    
    if ([NSJSONSerialization isValidJSONObject:bodyDic]) {
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error: &error];
        NSURL* url = [NSURL URLWithString:baseURL];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-length"];
        
        [request setValue:[NSString stringWithFormat:@"Bearer %@", @"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"]forHTTPHeaderField:@"Authorization"];
        
        
        [request setHTTPBody:jsonData];//set data
        __block NSError *error1 = [[NSError alloc] init];
        
        //use async way to connect network
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response,NSData *data,NSError* error)
         {
             if ([data length] > 0 && error == nil) {
                 resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
                 NSLog(@"resultsDictionary is %@", resultsDictionary);
                 
             } else if ([data length]==0 && error ==nil) {
                 NSLog(@" download data is null");
             } else if( error!=nil) {
                 NSLog(@" error is %@",error);
             }
         }];
    }
}

@end
