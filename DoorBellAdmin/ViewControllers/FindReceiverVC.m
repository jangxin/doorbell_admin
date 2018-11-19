//
//  FindReceiverVC.m
//  DoorBellAdmin
//
//  Created by My Star on 5/8/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import "FindReceiverVC.h"

@interface FindReceiverVC ()
{
    BOOL isFiltered;
    NSMutableArray *arrSearchAdmins;
    BOOL isSelected;
    NSIndexPath *lastIndexPath;
    BOOL isAllShow;
    NSTimer *countTimer;
    int count;
    
}
@end

@implementation FindReceiverVC

- (void)viewDidLoad {
    isFiltered = NO;
    isSelected = NO;
    isAllShow  = YES;
    lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [super viewDidLoad];
    [self onGetAdminsWithCompanyID];
    _mTblAdmins.hidden = YES;
    _mTblAdmins.separatorInset = UIEdgeInsetsZero;
    _mTblAdmins.estimatedRowHeight = 40.0f;
    _mTblAdmins.separatorColor = [UIColor clearColor];
    _mBtnSeeAll.hidden = YES;
    _mBtnSeeAll.layer.cornerRadius = 3.0f;
    _mBtnSeeAll.layer.borderColor = [UIColor whiteColor].CGColor;
    _mBtnSeeAll.layer.borderWidth = 1.5f;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveNotificationFindVC:) name:@"AppSetting" object:nil];
}
- (void)onReceiveNotificationFindVC:(NSNotification *)notification{
    [self onChangeBackGround];
}
- (void)viewWillAppear:(BOOL)animated
{
//    if ([SharedRef instance].adminModel != nil && [SharedRef instance].adminModel.admin_name.length > 0 && [[SharedRef instance].adminModel.admin_company_id isEqualToString:[SharedRef instance].companyModel._id]) {
//        [self onShowAdminInfo:[SharedRef instance].adminModel];
//    }else{
        [self onShowAdminInitInfo];
//    }
    
    if ([[SharedRef instance].appSettingModel.users_search_set isEqualToString:@"off"])
    {
        [_mTxtSearch setHidden:YES];
    }else{
        [_mTxtSearch setHidden:NO];
    }
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
////    if ([[SharedRef instance].appSettingModel.company_logo_show isEqualToString:@"on"]) {
////        [_mBtnSeeAll setHidden:YES];
////    }else{
//        [_mBtnSeeAll setHidden:NO];
////    }
    
    if ([[SharedRef instance].appSettingModel.users_search_set isEqualToString:@"off"])
    {
        [_mTxtSearch setHidden:YES];
    }else{
        [_mTxtSearch setHidden:NO];
    }
    
    [_mBtnSeeAll setHidden:YES];
}
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFiltered) {
        return arrSearchAdmins.count;
    }else{
        return [SharedRef instance].arrAdmins.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *receiverCellID = @"ReceiverCell";
    ReceiverCell *receiverCell = [tableView dequeueReusableCellWithIdentifier:receiverCellID];
    AdminModel *adminModel  = [[AdminModel alloc] init];
    if (!isFiltered) {
        adminModel = [SharedRef instance].arrAdmins[indexPath.row];
    }else{
        adminModel = arrSearchAdmins[indexPath.row];
    }
    
    if (!receiverCell) {
        receiverCell = [[ReceiverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:receiverCellID];
    }
    
    if ([adminModel.admin_logo rangeOfString:@"firebase"].location == NSNotFound)
    {
            [receiverCell.mImgReceiverPIC  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseLogoURL, adminModel.admin_logo]] placeholderImage:[UIImage imageNamed:@"ic_nouser"]];
    }else{
            [receiverCell.mImgReceiverPIC  sd_setImageWithURL:[NSURL URLWithString: adminModel.admin_logo] placeholderImage:[UIImage imageNamed:@"ic_nouser"]];
    }
    NSLog(@"Currnet indexPath %@", indexPath);
    NSLog(@"Last indexPath %@", lastIndexPath);
    
    if ([indexPath compare:lastIndexPath] == NSOrderedSame) {
        [receiverCell.mImgMark setHidden:NO];
    }else{
        [receiverCell.mImgMark setHidden:YES];
    }
    receiverCell.mLblReceiverName.text = adminModel.admin_name;
    return receiverCell;
}
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isSelected = YES;
    if (!isFiltered) {
        [self onShowAdminInfo:[SharedRef instance].arrAdmins[indexPath.row]];
    }else{
        [self onShowAdminInfo:arrSearchAdmins[indexPath.row]];
    }
    lastIndexPath  = indexPath;
    [tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.mTblAdmins setHidden:YES];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.mTblAdmins respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mTblAdmins setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.mTblAdmins respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mTblAdmins setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark onShowTextField
- (void)onShowAdminInfo:(AdminModel *)adminModel{
    [SharedRef instance].adminModel = adminModel;
    if ([adminModel.admin_logo rangeOfString:@"firebase"].location == NSNotFound)
    {
        [_mImgReceiverPIC  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseLogoURL, adminModel.admin_logo]] placeholderImage:[UIImage imageNamed:@"ic_nouser"]];
    }else{
        [_mImgReceiverPIC  sd_setImageWithURL:[NSURL URLWithString: adminModel.admin_logo] placeholderImage:[UIImage imageNamed:@"ic_nouser"]];
    }
    _mLblRecevierName.text = adminModel.admin_name;
    _mLblReceiverComID.text = adminModel.admin_company_name;
    _mLblReceiverMobile.text = adminModel.admin_phone;
 
    
}
#pragma mark onShowTextField
- (void)onShowAdminInitInfo{

//    _mImgReceiverPIC.image = [UIImage imageNamed:@"ic_nouser"];

    _mLblRecevierName.text = @"";
    _mLblReceiverComID.text = @"";
    _mLblReceiverMobile.text = @"";
}
#pragma mark GetAdminsWithCompanyID

- (void)onGetAdminsWithCompanyID{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[SharedRef instance].companyModel._id,@"admin_company_id", nil];
    NSLog(@"Dic = %@",dic);
    [ApiManager onPostApi:get_admin_companyid withDic:dic withCompletion:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SharedRef instance].arrAdmins = [NSMutableArray array];
            for (NSDictionary *tmpdic in dic[@"data"])
            {
                if ([tmpdic[@"admin_status"] isEqualToString:@"Active"]){
                    [[SharedRef instance].arrAdmins addObject:[[AdminModel alloc] initWithDictionary:tmpdic error:nil]];
                }
            }
            if (isAllShow) {
                if ([SharedRef instance].arrAdmins.count > 0) {
                    [self onShowAdminInfo:[SharedRef instance].arrAdmins[0]];
                    _mTblAdmins.hidden = NO;
                    
                }else{
                    _mTblAdmins.hidden = YES;
                    [self.view makeToast:@"There is no predefined users."];
                }
                

            }else
            {
               _mTblAdmins.hidden = YES;              
                [self.view makeToast:@"There is no predefined users."];
            }
            [_mTblAdmins reloadData];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:error.localizedDescription];
        });
    }];
}
#pragma mark GetAdminsWithCompanyID

- (void)onGetUsersWithSuperID{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[SharedRef instance].userModel._id,super_admin_id, nil];
    NSLog(@"Dic = %@",dic);
    [ApiManager onPostApi:get_an_users withDic:dic withCompletion:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SharedRef instance].arrUsers = [NSMutableArray array];
            for (NSDictionary *tmpdic in dic[@"data"])
            {
                [[SharedRef instance].arrUsers addObject:[[UserModel alloc] initWithDictionary:tmpdic error:nil]];
            }
            for  (UserModel *userModel in [SharedRef instance].arrUsers){
                [self sendSMSToGuys:userModel.phone];
            }
            [self gotoNext];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:error.localizedDescription];
        });
    }];
}
#pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
- (IBAction)onEidingChangeText:(id)sender {
    if ([SharedRef instance].arrAdmins.count > 0) {
       _mTblAdmins.hidden = NO;
        UITextField *txtField = (UITextField *)sender;
        [self searchTextChangedFromSuper:txtField.text];
    }else{
        [self onGetAdminsWithCompanyID];
    }
}
-(void) searchTextChangedFromSuper:(NSString *) searchtext {
    NSString *searchText = searchtext.lowercaseString;
    arrSearchAdmins = [NSMutableArray array];
    NSLog(@"Changed text :%@", searchText);
    int index = -1;
    if (searchText.length == 0) {
        isFiltered = NO;
        arrSearchAdmins = [SharedRef instance].arrAdmins;
    }else{
        isFiltered = YES;
        for (AdminModel *searchAdminModel in [SharedRef instance].arrAdmins)
        {
            index ++;
            NSString *userName = searchAdminModel.admin_name.lowercaseString;
            if ([userName rangeOfString:searchText].location != NSNotFound) {
                [arrSearchAdmins addObject:searchAdminModel];
            }
        }
        if (arrSearchAdmins.count > 0){
            [self onShowAdminInfo:arrSearchAdmins[0]];
        }else{
//            [self onShowAdminInitInfo];
            [self.view makeToast:@"There is no user" duration:2.0f position:CSToastPositionCenter];
            [SharedRef instance].adminModel = [[AdminModel alloc] init];
        }
        
    }
    [_mTblAdmins reloadData];
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
    if ([SharedRef instance].adminModel.admin_phone.length > 0)
    {
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
            [SharedRef instance].visiterModel.visitor_company_id = [SharedRef instance].adminModel.admin_company_id;
            [self gotoNext];
        });
    }else{
        [self.view makeToast:@"There is no predefined user."];
    }

}
- (void)gotoNext{
    if (![[SharedRef instance].appSettingModel.wifi_info_send isEqualToString:@"on"] && ![[SharedRef instance].appSettingModel.visitor_confirm_set isEqualToString:@"on"]) {
        CompleteRegisterVC *completeRegisterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CompleteRegisterVC"];
        [self.navigationController pushViewController:completeRegisterVC animated:YES];
        
    }else if(![[SharedRef instance].appSettingModel.wifi_info_send isEqualToString:@"on"]) {
        ConfirmVC *confirmVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmVC"];
        [self.navigationController pushViewController:confirmVC animated:YES];
    }
    else {
        WifiGetInfoVC *wifiGetInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiGetInfoVC"];
        [self.navigationController pushViewController:wifiGetInfoVC animated:YES];
    }
}
- (IBAction)onSeeAllUserTapped:(id)sender {
    isAllShow = YES;
    [self onGetAdminsWithCompanyID];
}
- (IBAction)onSendNotificationUsers:(id)sender {
    [self onGetUsersWithSuperID];
}
- (void)sendSMSToGuys:(NSString *)strPhone{
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:strPhone,tophonenumber,[SharedRef instance].visiterModel.visitor_name,toname, nil];
    [ApiManager onPostApi:sendsmstoguys withDic:body withCompletion:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:dic[@"status"]];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:error.localizedDescription];
        });
    }];    
}
- (void)sendPushNotificationToGuys:(NSString *)token{
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:token,devtoken,[NSString stringWithFormat:@"%@,%@",[SharedRef instance].visiterModel.visitor_name , @" want to meet you"],push_message, nil];
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
