//
//  Constant.h
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#ifndef Constant_h
#define Constant_h
#define mainRef [[FIRDatabase database] referenceFromURL:@"https://doorbell-1cf1b.firebaseio.com/"]
#define mainStorageRef [[FIRStorage storage] referenceForURL:@"gs://doorbell-1cf1b.appspot.com"]

#define IS_EMPLOY_INACTIVE    0
#define IS_EMPLOY_ACTIVE      1

#define IS_COMPANY_INACTIVE    0
#define IS_COMPANY_ACTIVE      1

#define IS_COMPANY_ADMIN     0
#define IS_SUPER_ADMIN       1

// VisiterModel Macro

#define VisiterID              @"mVisiterID"
#define VisiterName            @"mVisiterName"
#define VisiterEmail           @"mVisiterEmail"
#define VisiterPhoneNumber     @"mVisiterPhoneNumber"
#define VisiterPhotoURL        @"mVisiterPhotoURL"

// AdminModel Macro

#define AdminID                 @"mAdminID"
#define AdminName               @"mAdminName"
#define AdminEmail              @"mAdminEmail"
#define AdminPhoneNumber        @"mAdminPhoneNumber"
#define AdminPhotoURL           @"mAdminPhotoURL"
#define AdminAuthority          @"mAdminAuthority"


// EmployModel macro

#define EmployID                @"mEmployID"
#define EmployName              @"mEmployName"
#define EmployEmail             @"mEmployEmail"
#define EmployPhoneNumber       @"mEmployPhoneNumber"
#define EmployPhotoURL          @"mEmployPhotoURL"
#define EmployCompanyID         @"mEmployCompanyID"
#define EmplyActiveStatus       @"mEmplyActiveStatus"

// CompanyModel Macro

#define CompanyLogoURL           @"mCompanyLogoURL"
#define CompanyName              @"mCompanyName"
#define CompanyID                @"mCompanyID"
#define CompanyPhoneNumber       @"mCompanyPhoneNumber"
#define CompanyAddress           @"mCompanyAddress"
#define CompanyActiveStatus      @"mCompanyActiveStatus"

// 0 -> ordinary 1-> travel

#define VISITER_TABLE           @"VISITER_TABLE"
#define ADMIN_TABLE             @"ADMIN_TABLE"
#define EMPLOY_TABLE            @"EMPLOY_TABLE"
#define COMPANY_TABLE           @"COMPANY_TABLE"


#endif /* Constant_h */
