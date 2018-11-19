//
//  EmployModel.h
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Constant.h"
@interface EmployModel : JSONModel
@property NSString<Optional> * _id;
@property NSString<Optional> *username;
@property NSString<Optional> *password;
@property NSString<Optional> *realname;
@property NSString<Optional> *phone;
@property NSString<Optional> *status;
@property NSString<Optional> *__v;
@end
