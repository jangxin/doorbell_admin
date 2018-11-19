//
//  CompleteRegisterVC.h
//  DoorBellAdmin
//
//  Created by My Star on 5/9/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "ApiManager.h"
#import <MBProgressHUD.h>
#import "SharedRef.h"
#import <Toast/UIView+Toast.h>
#import <LCLoadingHUD.h>
#import "FrontPageVC.h"
#import "VisisterShowVC.h"
#import "VisiterRegisterVC.h"

@interface CompleteRegisterVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mLblCount;
@property (weak, nonatomic) IBOutlet UIView *mProgressView;
@property (weak, nonatomic) IBOutlet UIView *mViewProgress;
@property (weak, nonatomic) IBOutlet UILabel *mLblProgress;
@property (weak, nonatomic) IBOutlet UIView *mViewContent;
@end
