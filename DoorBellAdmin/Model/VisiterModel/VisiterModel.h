//
//  VisiterModel.h
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface VisiterModel : JSONModel
@property NSString<Optional> *visitor_name;
@property NSString<Optional> *visitor_mobile;
@property NSString<Optional> *visitor_receiver_id;
@property NSString<Optional> *visitor_receiver_name;
@property NSString<Optional> *visitor_company_id;
@property NSString<Optional> *visitor_company_name;
@property NSString<Optional> *visitor_sms_permission;
@property NSString<Optional> *user_id;
@property NSString<Optional> * __v;
@property NSString<Optional> * _id;


@end
