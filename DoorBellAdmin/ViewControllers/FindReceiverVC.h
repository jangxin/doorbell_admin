//
//  FindReceiverVC.h
//  DoorBellAdmin
//
//  Created by My Star on 5/8/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "CompanyModel.h"
#import "UserModel.h"
#import "VisiterModel.h"
#import "SharedRef.h"
#import <Toast/UIView+Toast.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import "ReceiverCell.h"
#import "AdminModel.h"
#import "ApiManager.h"
#import "WifiGetInfoVC.h"

@interface FindReceiverVC : UIViewController<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mTxtSearch;
@property (weak, nonatomic) IBOutlet UIImageView *mImgReceiverPIC;
@property (weak, nonatomic) IBOutlet UILabel *mLblReceiverComID;
@property (weak, nonatomic) IBOutlet UILabel *mLblRecevierName;
@property (weak, nonatomic) IBOutlet UILabel *mLblReceiverMobile;
@property (weak, nonatomic) IBOutlet UITableView *mTblAdmins;
@property (weak, nonatomic) IBOutlet UIButton *mBtnSeeAll;

@property (weak, nonatomic) IBOutlet UIImageView *mImgBack;
@end
