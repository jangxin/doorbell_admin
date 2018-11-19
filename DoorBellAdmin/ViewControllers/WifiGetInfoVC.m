//
//  WifiGetInfoVC.m
//  DoorBellAdmin
//
//  Created by My Star on 5/8/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import "WifiGetInfoVC.h"

@interface WifiGetInfoVC ()
{
    NSTimer *countTimer;
    int count;
}

@end

@implementation WifiGetInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveNotificationWifiVC:) name:@"AppSetting" object:nil];

}
- (void)onReceiveNotificationWifiVC:(NSNotification *)notification{
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
- (void)initView{
    _mViewNo.layer.borderColor = [UIColor grayColor].CGColor;
    _mViewNo.layer.borderWidth = 3.0f;
    
    _mViewYes.layer.borderColor = [UIColor grayColor].CGColor;
    _mViewYes.layer.borderWidth = 3.0f;
    _mImgYes.hidden = NO;
    _mImgNo.hidden = YES;
     [SharedRef instance].visiterModel.visitor_sms_permission  = @"on";
}
- (void)onChangeBackGround{
    [_mImgBack sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseBGEndPoint, [SharedRef instance].appSettingModel.bgimageurl]] placeholderImage:[UIImage imageNamed:@"imgback"]];
}
- (IBAction)onCancelTapped:(id)sender {
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
        [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
    });
}
- (IBAction)onPreviousTapped:(id)sender {
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
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
- (IBAction)onNextTapped:(id)sender {
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
        if (![[SharedRef instance].appSettingModel.visitor_confirm_set isEqualToString:@"on"]) {
            CompleteRegisterVC *completeRegisterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CompleteRegisterVC"];
            [self.navigationController pushViewController:completeRegisterVC animated:YES];
        }else {
            ConfirmVC *confirmVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmVC"];
            [self.navigationController pushViewController:confirmVC animated:YES];
        }

    });

}
- (IBAction)onYesTapped:(id)sender {
    [SharedRef instance].visiterModel.visitor_sms_permission  = @"on";
    _mImgYes.hidden = NO;
    _mImgNo.hidden = YES;
}
- (IBAction)onNoTapped:(id)sender {
    [SharedRef instance].visiterModel.visitor_sms_permission  = @"off";
    _mImgYes.hidden = YES;
    _mImgNo.hidden = NO;
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
//    if (!countTimer) {
        countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onCount) userInfo:nil repeats:YES];
//    }
    
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
