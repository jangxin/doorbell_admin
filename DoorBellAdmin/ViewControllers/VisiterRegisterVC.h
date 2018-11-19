//
//  VisiterRegisterVC.h
//  DoorBellAdmin
//
//  Created by My Star on 5/7/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiManager.h"
#import "VisiterModel.h"
#import <MBProgressHUD.h>
#import <Toast/UIView+Toast.h>
#import "Header.h"
#import "SharedRef.h"
#import <MMNumberKeyboard.h>
#import "NumericKeypadTextField.h"
#import "VisisterShowVC.h"
#import "CodeCell.h"

@interface VisiterRegisterVC : UIViewController
@property (weak, nonatomic) IBOutlet NumericKeypadTextField *mTxtPhoneNumber;

@property (weak, nonatomic) IBOutlet UIButton *mBtnPrevious;
@property (weak, nonatomic) IBOutlet UIButton *mBtnCancel;
@property (weak, nonatomic) IBOutlet UIButton *mBtnNext;
@property (weak, nonatomic) IBOutlet UIImageView *mImgBack;
@property (weak, nonatomic) IBOutlet UITableView *mTblCountryCode;
@property (weak, nonatomic) IBOutlet UIImageView *mImgFlag;
@property (weak, nonatomic) IBOutlet UITextField *mTxtCountryCode;
@property (weak, nonatomic) IBOutlet UIButton *mBtnShowCodeTbl;

@end
