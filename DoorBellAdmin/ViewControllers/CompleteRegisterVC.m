//
//  CompleteRegisterVC.m
//  DoorBellAdmin
//
//  Created by My Star on 5/9/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import "CompleteRegisterVC.h"

@interface CompleteRegisterVC ()
{
    MBProgressHUD *mbProgressHUD;
    int count;
    NSTimer *countTimer;
}
@end

@implementation CompleteRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_mViewContent setHidden:YES];
    count = [SharedRef instance].appSettingModel.disp_period.integerValue;
    self.mLblCount.text = [NSString stringWithFormat:@"%@ %d.", @"Please wait at the reception until you are picked up",count];
    mbProgressHUD = [[MBProgressHUD alloc] init];
    mbProgressHUD.labelText = @"The receiver will be notified of your arrival.";
    [_mViewProgress setHidden:YES];
    [self updateVisiterInfo];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    if (!countTimer) {
        [countTimer invalidate];
        
    }
    countTimer = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onNewRegisterTapped:(id)sender {
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
        [self goBackNewRegistrationVC];
    });
}
- (void)sendCall{
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:[SharedRef instance].adminModel.admin_phone,tophonenumber,nil];
    [ApiManager onPostApi:send_call withDic:body withCompletion:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if ([dic[@"status"] isEqualToString:@"success"]) {
                NSLog(@"%@", @"calling ok");
             }else{
                 NSLog(@"%@", @"calling failed");
            }
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:error.localizedDescription];
        });
    }];
}

- (void)sendSMSToGuys{
    NSString *name;
    if ([SharedRef instance].visiterModel.visitor_name.length > 0){
        name = [SharedRef instance].visiterModel.visitor_name;
    }else{
        name =@"Someone";
    }

//    if ([[SharedRef instance].adminModel.strweekavailable containsString:[self getDayOfWeek]] && [self getCurrentTime].intValue < [SharedRef instance].adminModel.officetime_to.intValue &&  [self getCurrentTime].intValue > [SharedRef instance].adminModel.officetime_from.intValue)
//    {
        NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:[SharedRef instance].adminModel.admin_phone,tophonenumber,name,toname, [SharedRef instance].adminModel.admin_company_name,@"companyname",nil];
        if ([[SharedRef instance].adminModel.sms_noti_set isEqualToString:@"on"] ) {
            [ApiManager onPostApi:sendsmstoguys withDic:body withCompletion:^(NSDictionary *dic) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([dic[@"status"] isEqualToString:@"success"]) {
                        if ([[SharedRef instance].visiterModel.visitor_sms_permission isEqualToString:@"on"] && [[SharedRef instance].appSettingModel.wifi_info_send isEqualToString:@"on"]) {
                            
                        }else{
                            [self.mViewContent setHidden:NO];
                            //                    [self startTimer];
                            [MBProgressHUD hideHUDForView:self.mProgressView animated:YES];
                            _mViewProgress.hidden = YES;
                        }
                    }else{
                        [MBProgressHUD hideHUDForView:self.mProgressView animated:YES];
                        _mViewProgress.hidden = YES;
                        _mViewContent.hidden = NO;
                        //                [self startTimer];
                    }
                });
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.mProgressView animated:YES];
                    _mViewProgress.hidden = YES;
                    _mViewContent.hidden = NO;
                    //            [self startTimer];
                });
            }];
        }
        

        if ([[SharedRef instance].adminModel.email_noti_set isEqualToString:@"on"] && ![[SharedRef instance].adminModel.devicetoken isEqualToString:@"devicetoken"]) {
            NSString *message = [NSString stringWithFormat:@"%@\n%@%@\n%@%@\n",@"You have a visitor at the door" , @"Name: ", name ,@"Company: ",[SharedRef instance].adminModel.admin_company_name];
            NSDictionary *notibody = [NSDictionary dictionaryWithObjectsAndKeys:[SharedRef instance].adminModel.devicetoken,@"token",message,@"message", nil];
            [self sendPushNotificationToGuys:[SharedRef instance].adminModel.devicetoken withBody:notibody];/////
        }
//    }
    

}
- (NSString *)getDayOfWeek{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"EEEE"];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    NSString *strDay;
    NSString *strDayofWeek = [dateFormatter stringFromDate:[NSDate date]];
    if ([strDayofWeek isEqualToString:@"Monday"]){
        strDay = @"M";
    }else if ([strDayofWeek isEqualToString:@"Tuesday"]){
        strDay = @"T";
    }else if ([strDayofWeek isEqualToString:@"Wednesday"]){
        strDay = @"W";
    }else if ([strDayofWeek isEqualToString:@"Thursday"]){
        strDay = @"H";
    }else if ([strDayofWeek isEqualToString:@"Friday"]){
        strDay = @"F";
    }else if ([strDayofWeek isEqualToString:@"Saturday"]){
       strDay = @"A";
    }else if ([strDayofWeek isEqualToString:@"Sunday"]){
       strDay = @"U";
    }
    NSLog(@"%@",strDay);
        
    return strDay;
    
}
- (NSString *)getCurrentTime{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    return [dateFormatter stringFromDate:[NSDate date]];
}
- (void)sendSMSWifiInfo{
    NSString *strMsg = [NSString stringWithFormat:@"Wifi username : %@ \n Wifi Password : %@", [SharedRef instance].appSettingModel.wifi_name ,[SharedRef instance].appSettingModel.wifi_pass];
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:[SharedRef instance].visiterModel.visitor_mobile,tophonenumber,strMsg,@"message" ,nil];
    [ApiManager onPostApi:sendsmswifiinfo withDic:body withCompletion:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.mProgressView animated:YES];
            _mViewProgress.hidden = YES;
            if ([dic[@"status"] isEqualToString:@"success"]) {
                
                [self.mViewContent setHidden:NO];
                
            }else{
                [self.mViewContent setHidden:NO];
//                [self startTimer];
            }
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.mProgressView animated:YES];
            _mViewProgress.hidden = YES;
            _mViewContent.hidden = NO;
//            [self startTimer];
        });
    }];

}
- (void)sendPushNotificationToGuys:(NSString *)token withBody :(NSDictionary *)body{

    [ApiManager onPostApi:send_pushnotification withDic:body withCompletion:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:dic[@"status"]];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:error.localizedDescription];
        });
    }];
}
- (void)updateVisiterInfo
{
    if ([SharedRef instance].visiterModel.visitor_mobile.length > 3) {
        NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                              [SharedRef instance].visiterModel.visitor_name , @"visitor_name"
                              ,[SharedRef instance].visiterModel.visitor_mobile ,@"visitor_mobile"
                              
                              ,[SharedRef instance].adminModel._id ,@"visitor_receiver_id"
                              ,[SharedRef instance].adminModel.admin_name,@"visitor_receiver_name"
                              ,[SharedRef instance].visiterModel.visitor_company_id,@"visitor_company_id"
                              ,[SharedRef instance].visiterModel.visitor_company_name,@"visitor_company_name"
                              ,[SharedRef instance].adminModel.user_id, User_id
                              ,[SharedRef instance].visiterModel.visitor_sms_permission,@"visitor_sms_permission"
                              ,nil];
            _mViewProgress.hidden = NO;

            [MBProgressHUD showHUDAddedTo:self.mProgressView animated:YES];
            [ApiManager onPostApi:add_visitor withDic:body withCompletion:^(NSDictionary *dic) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([dic[@"status"] isEqualToString:@"success"]) {
                        
                        [MBProgressHUD hideHUDForView:self.mProgressView animated:YES];
                        _mViewProgress.hidden = YES;
                        _mViewContent.hidden = NO;
                        [self startTimer];
                        
                    }else{
                        [MBProgressHUD hideHUDForView:self.mProgressView animated:YES];
                        _mViewProgress.hidden = YES;
                        _mViewContent.hidden = NO;
                        [self startTimer];
                        
                        //                    [self.view makeToast:@"Failed updating of visitor info"];
                    }
                    [SharedRef instance].visiterModel = [[VisiterModel alloc] initWithDictionary:body error:nil];
                    [self sendSMSToGuys];
                    if ([[SharedRef instance].visiterModel.visitor_sms_permission isEqualToString:@"on"] && [[SharedRef instance].appSettingModel.wifi_info_send isEqualToString:@"on"]) {
                        [self sendSMSWifiInfo];
                    }
                    
                });
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.mProgressView animated:YES];
                    _mViewProgress.hidden = YES;
                    _mViewContent.hidden = NO;
                    [self.view makeToast:error.localizedDescription];
                    [self startTimer];
                });
            }];
        

    }else{
//        [SharedRef instance].visiterModel = [[VisiterModel alloc] initWithDictionary:body error:nil];
        [self sendSMSToGuys];
        if ([[SharedRef instance].visiterModel.visitor_sms_permission isEqualToString:@"on"] && [[SharedRef instance].appSettingModel.wifi_info_send isEqualToString:@"on"]) {
            [self sendSMSWifiInfo];
        }
        [MBProgressHUD hideHUDForView:self.mProgressView animated:YES];
        _mViewProgress.hidden = YES;
        _mViewContent.hidden = NO;
        [self startTimer];
    }
    
}
- (void)updatePickUpLabel
{
    count --;
    if (count == 0) {
        [self goBackNewRegistrationVC];
    }
    self.mLblCount.text = [NSString stringWithFormat:@"%@ %d.", @"Please wait at the reception until you are picked up",count];
}

- (void)startTimer{
    if (!countTimer) {
        countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updatePickUpLabel) userInfo:nil repeats:YES];
    }
 
}
- (void)stopTimer{
    if ([countTimer isValid]) {
        [countTimer invalidate];
    }
    countTimer = nil;
}
- (void)goBackNewRegistrationVC{
    [SharedRef instance].arrAdmins = [NSMutableArray array];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
