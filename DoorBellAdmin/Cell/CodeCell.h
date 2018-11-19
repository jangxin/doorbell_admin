//
//  CodeCell.h
//  DoorBellAdmin
//
//  Created by My Star on 7/4/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImgFlag;
@property (weak, nonatomic) IBOutlet UILabel *mLblName;
@property (weak, nonatomic) IBOutlet UILabel *mLblCode;

@end
