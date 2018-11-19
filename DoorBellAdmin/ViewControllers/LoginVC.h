//
//  LoginVC.h
//  DoorBellAdmin
//
//  Created by My Star on 6/21/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "SharedRef.h"
#import "CompanyModel.h"
#import <Toast/UIView+Toast.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ApiManager.h"
#import "Header.h"
#import "UserModel.h"
#import "Utilities.h"
#import "FrontPageVC.h"
#import "AppSettingModel.h"

@interface LoginVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mImgBack;
@property (weak, nonatomic) IBOutlet UITextField *mTxtEmail;
@property (weak, nonatomic) IBOutlet UITextField *mTxtPass;
@property (weak, nonatomic) IBOutlet UIButton *mBtnLogin;

@end
