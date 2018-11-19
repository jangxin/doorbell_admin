//
//  AppDelegate.h
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "IQKeyboardManager.h"
#import "ApiManager.h"
#import "SharedRef.h"
#import "UserModel.h"
#import "FrontPageVC.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "LoginVC.h"
#import "Utilities.h"
#import <CoreLocation/CoreLocation.h>

@import Firebase;
@import FirebaseMessaging;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property CLLocationManager *locationManager;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

