//
//  VisisterShowVC.m
//  DoorBellAdmin
//
//  Created by My Star on 5/8/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import "VisisterShowVC.h"

@interface VisisterShowVC ()
{
 
    NSTimer *countTimer;
    int count;
}
@end

@implementation VisisterShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([SharedRef instance].visiterModel != nil && [SharedRef instance].companyModel != nil) {
        _mTxtCompanyName.text = [SharedRef instance].visiterModel.visitor_company_name;
        _mTxtVisitorName.text = [SharedRef instance].visiterModel.visitor_name;
        
    }
    _mTxtVisitorMobile.text = [SharedRef instance].strVisitorPhone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveNotificationShowVC:) name:@"AppSetting" object:nil];
}
- (void)onReceiveNotificationShowVC:(NSNotification *)notification{
    [self onChangeBackGround];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self startTimer];
    [self onChangeBackGround];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self stopTimer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onChangeBackGround{
    [_mImgBack sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseBGEndPoint, [SharedRef instance].appSettingModel.bgimageurl]] placeholderImage:[UIImage imageNamed:@"imgback"]];
}
//- (void)onCreateVisitorModel{
//    if (_mTxtCompanyName.text.length > 0 && _mTxtCompanyName.text.length > 0 && _mTxtVisitorMobile.text.length > 0) {
//        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
//                                          _mTxtVisitorName.text , @"visitor_name"
//                                          ,_mTxtVisitorMobile.text ,@"visitor_mobile"
//                                          ,@"" ,@"visitor_receiver_id"
//                                          ,@"",@"visitor_receiver_name"
//                                          ,@"",@"visitor_company_id"
//                                          ,_mTxtCompanyName.text,@"visitor_company_name"
//                                          ,@"", User_id
//                                          ,@"on",@"visitor_sms_permission"
//                                          ,nil];
//                    [ApiManager onPostApi:add_visitor withDic:body withCompletion:^(NSDictionary *dic) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [MBProgressHUD hideHUDForView:self.view animated:YES];
//                            if ([dic[@"status"] isEqualToString:@"success"]) {
//                                [SharedRef instance].visiterModel = [[VisiterModel alloc] initWithDictionary:body error:nil];
//                                [self gotoNextView];
//                            }else{
//                                [self.view makeToast:@"Already exist the visitor!"];
//                                [self gotoNextView];
//                            }
//                        });
//                    } failure:^(NSError *error) {
//                        [MBProgressHUD hideHUDForView:self.view animated:YES];
//                        [self.view makeToast:error.localizedDescription];
//                    }];
//    }else{
//        [self.view makeToast:@"Please fill all of field."];
//    }
//}
- (IBAction)onNoTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onYesTapped:(id)sender {
    UIButton *tempBtn = (UIButton *)sender;
    if (tempBtn.isTouchInside) {
        [tempBtn setBackgroundColor:selectColor];
    }else{
        [tempBtn setBackgroundColor:unselectColor];
    }
    double delayInSeconds = delay_time;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [tempBtn setBackgroundColor:unselectColor];
        [SharedRef instance].visiterModel.visitor_company_name = _mTxtCompanyName.text;
        [SharedRef instance].visiterModel.visitor_name = _mTxtVisitorName.text;
        [SharedRef instance].visiterModel.visitor_mobile = _mTxtVisitorMobile.text;
        if ([SharedRef instance].visiterModel.visitor_name.length > 1)
        {
            [self gotoNextView];
        }else{
            [self.view makeToast:@"Please fill name of field." duration:2.0f position:CSToastPositionCenter];
        }
    });
}
- (void)gotoNextView{
    if ([SharedRef instance].visiterModel.visitor_receiver_id.length > 0)
    {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedRef instance].visiterModel.visitor_receiver_id,userID, nil];
            [ApiManager onPostApi:get_single_admin withDic:dic withCompletion:^(NSDictionary *dic) {
                NSLog(@"%@",dic);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [SharedRef instance].adminModel = [[AdminModel alloc] initWithDictionary:dic[@"data"][0] error:nil];
                    [self gotoFindReceiverVC];
                });
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self gotoFindReceiverVC];
                });
            }];
        }else{
            [self gotoFindReceiverVC];
        }
    
        
 
}
- (void)gotoFindReceiverVC{
    FindReceiverVC *findReceiverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindReceiverVC"];
    [self.navigationController pushViewController:findReceiverVC animated:YES];
}
- (void)onCount{
    count ++;
    if (count == [SharedRef instance].appSettingModel.disp_period.integerValue) {
        count = 0;
        [countTimer invalidate];
        countTimer = nil;
        [self goBackNewRegistrationVC];
    }
    
}
- (void)startTimer{
        countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onCount) userInfo:nil repeats:YES];

    
}
- (void)stopTimer{
    if ([countTimer isValid]) {
        [countTimer invalidate];
    }
    countTimer = nil;
}
- (void)goBackNewRegistrationVC{
    if ([[SharedRef instance].appSettingModel.company_logo_show isEqualToString:@"on"]){
        [self gotoFrontPageView];
    }else{
        [self gotoVisitorShowView];
    }
    
    //    [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
}

- (void)gotoFrontPageView{
    FrontPageVC *frontPageVC  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FrontPageVC"]; //or the homeController
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:frontPageVC];
    [UIApplication sharedApplication].windows.firstObject.rootViewController = navController;
}
- (void)gotoVisitorShowView{
    VisiterRegisterVC *visiterRegisterVC  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VisiterRegisterVC"]; //or the homeController
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:visiterRegisterVC];
    [UIApplication sharedApplication].windows.firstObject.rootViewController = navController;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
