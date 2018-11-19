//
//  ConfirmVC.h
//  DoorBellAdmin
//
//  Created by My Star on 5/8/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedRef.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Header.h"
#import "CompleteRegisterVC.h"
@interface ConfirmVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mLblGCom;
@property (weak, nonatomic) IBOutlet UILabel *mLblGName;
@property (weak, nonatomic) IBOutlet UILabel *mLblGPhone;
@property (weak, nonatomic) IBOutlet UILabel *mLblRCom;
@property (weak, nonatomic) IBOutlet UILabel *mLblRName;
@property (weak, nonatomic) IBOutlet UILabel *mLblPhone;
@property (weak, nonatomic) IBOutlet UIImageView *mImgRPIC;
@property (weak, nonatomic) IBOutlet UIImageView *mImgBack;

@end
