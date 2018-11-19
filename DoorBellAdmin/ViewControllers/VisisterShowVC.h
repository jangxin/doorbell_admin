//
//  VisisterShowVC.h
//  DoorBellAdmin
//
//  Created by My Star on 5/8/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumericKeypadTextField.h"
#import "VisiterModel.h"
#import "Header.h"
#import <MBProgressHUD.h>
#import <Toast/UIView+Toast.h>
#import "ApiManager.h"
#import "UserModel.h"
#import "CompanyModel.h"
#import "SharedRef.h"
#import "FindReceiverVC.h"

@interface VisisterShowVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mTxtCompanyName;
@property (weak, nonatomic) IBOutlet UITextField *mTxtVisitorName;
@property (weak, nonatomic) IBOutlet NumericKeypadTextField *mTxtVisitorMobile;
@property (weak, nonatomic) IBOutlet UIImageView *mImgBack;


@end
