//
//  UserModel.h
//  DoorBellAdmin
//
//  Created by My Star on 5/7/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserModel : JSONModel

@property NSString<Optional> * _id;
@property NSString<Optional> *username;
@property NSString<Optional> *realname;
@property NSString<Optional> *phone;
@property NSString<Optional> *email;
@property NSString<Optional> *status;

@end
