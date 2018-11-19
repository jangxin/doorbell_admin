//
//  AdminModel.h
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//


///////////////

//if mAdminAutority == 1
//    superAdmin
//else
//    companyAdmin
///////////////
#import <JSONModel/JSONModel.h>
#import "Constant.h"

@interface AdminModel : JSONModel
@property NSString<Optional> * __v;
@property NSString<Optional> * _id;
@property NSString<Optional> * admin_company_id;
@property NSString<Optional> * admin_company_name;
@property NSString<Optional> * admin_email;
@property NSString<Optional> * admin_logo;
@property NSString<Optional> * admin_name;
@property NSString<Optional> * admin_phone;
@property NSString<Optional> * admin_status;
@property NSString<Optional> * user_id;
@property NSString<Optional> * passcode;
@property NSString<Optional> * distance;
@property NSString<Optional> * email_noti_set;
@property NSString<Optional> * sms_noti_set;
@property NSString<Optional> * officetime_from;
@property NSString<Optional> * officetime_to;
@property NSString<Optional> * strweekavailable;
@property NSString<Optional> * devicetoken;
@property NSString<Optional> * isduty;

@end



