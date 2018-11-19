//
//  FrontPageVC.h
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "CompanyCollectionCell.h"
#import "ApiManager.h"
#import <MBProgressHUD.h>
#import "SharedRef.h"
#import "CompanyModel.h"
#import <Toast/UIView+Toast.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utilities.h"
#import "VisiterRegisterVC.h"
@interface FrontPageVC : UIViewController<UITextFieldDelegate,CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtView;
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionCompanies;
@property (weak, nonatomic) IBOutlet UIImageView *mImgBack;

@property (weak, nonatomic) IBOutlet UITextField *mTxtSearchAndTitle;
@property (weak, nonatomic) IBOutlet UITextField *mTxtSearch;

@property (weak, nonatomic) IBOutlet UIView *mViewTitle;

@end
