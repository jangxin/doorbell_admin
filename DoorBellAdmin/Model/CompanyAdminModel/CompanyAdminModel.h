//
//  CompanyAdminModel.h
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CompanyAdminModel : JSONModel
@property NSString<Optional> *mCompanyLogoURL;
@property NSString<Optional> *mCompanyName;
@property NSString<Optional> *mCompanyID;
@property NSString<Optional> *mCompanyPhoneNumber;
@property NSString<Optional> *mComanyAddress;
@end
