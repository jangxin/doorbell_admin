//
//  CompanyModel.h
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Constant.h"

@interface CompanyModel : JSONModel
@property NSString<Optional> * __v;
@property NSString<Optional> * _id;
@property NSString<Optional> * company_name;
@property NSString<Optional> * company_email;
@property NSString<Optional> * company_logo;
@property NSString<Optional> * company_statu;
@property NSString<Optional> * user_id;
@property NSString<Optional> * address;
@property NSString<Optional> * latitude;
@property NSString<Optional> * longitude;
@property NSString<Optional> * sms_setting;
@end
