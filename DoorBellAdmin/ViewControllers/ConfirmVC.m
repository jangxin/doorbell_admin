//
//  ConfirmVC.m
//  DoorBellAdmin
//
//  Created by My Star on 5/8/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import "ConfirmVC.h"

@interface ConfirmVC ()
{
    NSTimer *countTimer;
    int count;
    
}
@end

@implementation ConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"VisiterModel %@",[SharedRef instance].visiterModel);
    NSLog(@"AdminModel %@",[SharedRef instance].adminModel);
    [self initViewLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveNotificationConfirmVC:) name:@"AppSetting" object:nil];
    if (![[SharedRef instance].appSettingModel.visitor_confirm_set isEqualToString:@"on"]) {
        CompleteRegisterVC *completeRegisterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CompleteRegisterVC"];
        [self.navigationController pushViewController:completeRegisterVC animated:YES];
    }
}
- (void)onReceiveNotificationConfirmVC:(NSNotification *)notification{
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
- (void)initViewLoad{
    self.mLblGCom.text = [SharedRef instance].visiterModel.visitor_company_name;
    self.mLblGName.text = [SharedRef instance].visiterModel.visitor_name;
    self.mLblGPhone.text = [SharedRef instance].visiterModel.visitor_mobile;
    
    if ([[SharedRef instance].adminModel.admin_logo rangeOfString:@"firebase"].location == NSNotFound)
    {
        [_mImgRPIC  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseLogoURL, [SharedRef instance].adminModel.admin_logo]] placeholderImage:[UIImage imageNamed:@"ic_nouser"]];
    }else{
        [_mImgRPIC  sd_setImageWithURL:[NSURL URLWithString: [SharedRef instance].adminModel.admin_logo] placeholderImage:[UIImage imageNamed:@"ic_nouser"]];
    }
    
    self.mLblRCom.text = [SharedRef instance].adminModel.admin_company_name;
    self.mLblRName.text = [SharedRef instance].adminModel.admin_name;
    self.mLblPhone.text = [SharedRef instance].adminModel.admin_phone;
    
}
- (void)onChangeBackGround{
    [_mImgBack sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseBGEndPoint, [SharedRef instance].appSettingModel.bgimageurl]] placeholderImage:[UIImage imageNamed:@"imgback"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)onCompleteTapped:(id)sender {
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
        CompleteRegisterVC *completeRegisterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CompleteRegisterVC"];
        [self.navigationController pushViewController:completeRegisterVC animated:YES];
    });
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
