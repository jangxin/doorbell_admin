//
//  SharedRef.h
//  Doorbell_user
//
//  Created by My Star on 4/15/17.
//  Copyright © 2017 Doorbell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdminModel.h"
#import "VisiterModel.h"
#import "CompanyModel.h"
#import "UserModel.h"
#import "AppSettingModel.h"
#import <UIKit/UIKit.h>
@interface SharedRef : NSObject
@property NSMutableArray *arrUsers;
@property NSMutableArray *arrCompanies;
@property NSMutableArray *arrVisitors;
@property NSMutableArray *arrAdmins;
@property AdminModel *adminModel;
@property VisiterModel *visiterModel;
@property CompanyModel *companyModel;
@property UserModel *userModel;
@property AppSettingModel *appSettingModel;
@property NSString *strLat;
@property NSString *strLong;
@property NSInteger selectedCompany_Index;
@property NSString *strVisitorPhone;
@property NSString *selectedVisitor_ID;
@property NSDictionary *dictCountryCodes;
@property NSString *strCountryCode;
@property NSString *strISOCode;
@property UIImage *mFlag;
+ (SharedRef *) instance;
@end
