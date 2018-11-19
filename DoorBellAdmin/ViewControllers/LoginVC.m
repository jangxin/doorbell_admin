//
//  LoginVC.m
//  DoorBellAdmin
//
//  Created by My Star on 6/21/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveNotificationLoginVC:) name:@"AppSetting" object:nil];
}
- (void)onReceiveNotificationLoginVC:(NSNotification *)notification{
    [self onChangeBackGround:notification.object];
}
- (void)viewWillAppear:(BOOL)animated
{
    _mBtnLogin.layer.cornerRadius = 3.0f;
    _mBtnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    _mBtnLogin.layer.borderWidth = 1.5f;
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onLoginTapped:(id)sender {
    if (_mTxtEmail.text.length < 1 || _mTxtPass.text.length < 3) {
        [self.view makeToast:@"Please fill all of fields." duration:2.0 position:CSToastPositionCenter];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *email = [_mTxtEmail.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *password = [_mTxtPass.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:email,@"username",password,@"password",nil];
        [ApiManager onPostLoginApi:dic withCompletion:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([dic[@"status"] isEqualToString:@"success"]) {
                    UserModel *userModel = [[UserModel alloc] initWithDictionary:dic[@"data"] error:nil];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if ([userModel.status isEqualToString:@"0"])
                    {
                        
                        [self.view makeToast:@"In order to use this app, you must be super admin."];
                        return;
                    }else if([userModel.status isEqualToString:@"1"]){
                        
                    }else if([userModel.status isEqualToString:@"2"]){
                        
                    }
                    [Utilities saveUserObject:userModel];
                    [SharedRef instance].userModel = userModel;
                    NSDictionary *setDic = [NSDictionary dictionaryWithObjectsAndKeys:userModel._id,@"userid", nil];
                    [ApiManager onPostApi:appsettingwithuseridOnMobile withDic:setDic withCompletion:^(NSDictionary *setdic) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            if (![dic[@"status"] isEqualToString:@"success"])
                            {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                [self.view makeToast:@"Can not connect server!"];
                                return;
                            }
                            AppSettingModel *appSettingModel = [[AppSettingModel alloc] initWithDictionary:setdic[@"data"] error:nil];
                            [Utilities saveAppSetModelObject:appSettingModel];
                            [SharedRef instance].appSettingModel = appSettingModel;
                            [self onChangeBackGround:appSettingModel];
                            [self onSuccessLogin];
                        });
                    } failure:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [self.view makeToast:error.localizedDescription];
                        });
                    }];
                }else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.view makeToast:dic[@"status"] duration:2.0f position:CSToastPositionCenter];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.view makeToast:error.localizedDescription];
            });
        }];
    }
}

- (void)onSuccessLogin{
    FrontPageVC *frontPageVC  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FrontPageVC"]; //or the homeController
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:frontPageVC];
    [UIApplication sharedApplication].windows.firstObject.rootViewController = navController;
//    self.window.rootViewController = navController;
}
- (void)onChangeBackGround:(AppSettingModel *)appSettingModel{
        [_mImgBack sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseBGEndPoint, appSettingModel.bgimageurl]] placeholderImage:[UIImage imageNamed:@"imgback"]];
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
