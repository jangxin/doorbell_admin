//
//  CompanyAdminModel.m
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import "CompanyAdminModel.h"

@implementation CompanyAdminModel
-(id)init
{
    self =[super init];
    self.mCompanyPhoneNumber = @"";
    self.mCompanyID= @"";
    self.mCompanyName = @"";
    self.mComanyAddress = @"";
    self.mCompanyLogoURL = @"";
    return self;
}
@end
