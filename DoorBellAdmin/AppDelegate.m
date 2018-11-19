//
//  AppDelegate.m
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    NSTimer *countTimer;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FIRApp configure];
    [Fabric with:@[[Crashlytics class]]];

    UIUserNotificationType allNotificationTypes =
    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    [IQKeyboardManager sharedManager].enable = true;
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:) name:kFIRInstanceIDScopeFirebaseMessaging  object:nil];
    [self getNeededInfos];
    [self initLocationManager];
    [self startTimer];
    return YES;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Received Notifications = %@", userInfo);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    NSLog(@"Received Notifications = %@", userInfo);

    completionHandler(UIApplicationBackgroundFetchIntervalNever);
        
    
    
    
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"Terminate");
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

#pragma mark FireBase Pushnotification

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to appliation server.
}

- (void)initLocationManager{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    [clGeoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error){
            NSLog(@"Errors %@",error);
        }else{
            NSLog(@"PlaceMarks %@",placemarks);
            CLPlacemark *clPlaceMark = [placemarks objectAtIndex:0];
            NSString *isoCode = clPlaceMark.ISOcountryCode;
            if ([[SharedRef instance].dictCountryCodes objectForKey:isoCode]) {
                [SharedRef instance].mFlag =  [UIImage imageNamed: [NSString stringWithFormat:@"CountryPicker.bundle/%@",isoCode]];
                [SharedRef instance].strCountryCode = [NSString stringWithFormat:@"+%@",[[SharedRef instance].dictCountryCodes objectForKey:isoCode][1]];
                _locationManager.delegate = nil;
                
            }
            NSString *countryName = clPlaceMark.country;
            NSLog(@"%@ %@",isoCode,countryName);
        }
       
            

    }];
    [SharedRef instance].strLat = [NSString stringWithFormat:@"%2f",location.coordinate.latitude];
    [SharedRef instance].strLong = [NSString stringWithFormat:@"%2f",location.coordinate.longitude];
}
- (void)getNeededInfos{
    if ([Utilities loadUserObjectWithKey] != nil && [Utilities loadAppSetModelObjectWithKey])
    {
        [SharedRef instance].userModel = [Utilities loadUserObjectWithKey];
        [SharedRef instance].appSettingModel = [Utilities loadAppSetModelObjectWithKey];
        if ([[SharedRef instance].appSettingModel.company_logo_show isEqualToString:@"on"]){
            [self gotoFrontPageView];
        }else{
            [self gotoVisitorShowView];
        }
        
    }else{
        [self gotoLoginView];
    }
}
- (void)gotoFrontPageView{
    FrontPageVC *frontPageVC  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FrontPageVC"]; //or the homeController
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:frontPageVC];
    self.window.rootViewController = navController;
}
- (void)gotoVisitorShowView{
    VisiterRegisterVC *visiterRegisterVC  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VisiterRegisterVC"]; //or the homeController
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:visiterRegisterVC];
    self.window.rootViewController = navController;
}
- (void)gotoLoginView{
    LoginVC *loginVC  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVC"]; //or the homeController
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = navController;
}

- (void)onCount{
    if ([SharedRef instance].userModel != nil) {
        NSDictionary *setDic = [NSDictionary dictionaryWithObjectsAndKeys:[SharedRef instance].userModel._id,@"userid", nil];
        [ApiManager onPostApi:appsettingwithuseridOnMobile withDic:setDic withCompletion:^(NSDictionary *setdic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![setdic[@"status"] isEqualToString:@"success"])
                {
                    return;
                }
                AppSettingModel *appSettingModel = [[AppSettingModel alloc] initWithDictionary:setdic[@"data"] error:nil];
                [Utilities saveAppSetModelObject:appSettingModel];
                [SharedRef instance].appSettingModel = appSettingModel;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AppSetting" object:appSettingModel];
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AppSetting" object: [SharedRef instance].appSettingModel];
            });
        }];

    }
}
- (void)startTimer{
    if (!countTimer) {
        countTimer = [NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(onCount) userInfo:nil repeats:YES];
    }
    
}
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self connectToFcm];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}





#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"DoorBellAdmin"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
