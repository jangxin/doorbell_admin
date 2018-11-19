//
//  WifiGetInfoVC.h
//  DoorBellAdmin
//
//  Created by My Star on 5/8/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedRef.h"
#import "ConfirmVC.h"

@interface WifiGetInfoVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *mViewYes;
@property (weak, nonatomic) IBOutlet UIView *mViewNo;
@property (weak, nonatomic) IBOutlet UIImageView *mImgYes;
@property (weak, nonatomic) IBOutlet UIImageView *mImgNo;
@property (weak, nonatomic) IBOutlet UIImageView *mImgBack;

@end
