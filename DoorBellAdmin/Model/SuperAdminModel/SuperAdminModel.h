//
//  SuperAdminModel.h
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SuperAdminModel : JSONModel
@property NSString<Optional> *mSuperAdminID;
@property NSString<Optional> *mSpuerAdminEmail;
@property NSString<Optional> *mSuperAdminPhoneNumber;
@property NSString<Optional> *mSuperAdminPhotoURL;

@end
