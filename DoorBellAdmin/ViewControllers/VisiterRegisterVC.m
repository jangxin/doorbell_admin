//
//  VisiterRegisterVC.m
//  DoorBellAdmin
//
//  Created by My Star on 5/7/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import "VisiterRegisterVC.h"

@interface VisiterRegisterVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSTimer *countTimer;
    int count;
}
@end

@implementation VisiterRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
    _mTxtPhoneNumber.placeholder = @"Mobile number";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveNotificationRegiVC:) name:@"AppSetting" object:nil];

}
- (void)onReceiveNotificationRegiVC:(NSNotification *)notification{
    [self onChangeBackGround];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
    [self startTimer];
    [self onChangeBackGround];
    

    _mImgFlag.image = [SharedRef instance].mFlag;
    _mTxtCountryCode.text = [SharedRef instance].strCountryCode;
    [_mTblCountryCode setHidden:YES];
    

    
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
//    if ([[SharedRef instance].appSettingModel.company_logo_show isEqualToString:@"on"]){
//        [self gotoFrontPageView];
//    }
}
- (IBAction)onCancel:(id)sender {
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
- (IBAction)onNexttapped:(id)sender {
    if (_mTxtPhoneNumber == nil || _mTxtPhoneNumber.text.length < 6){
        [self.view makeToast:@"Please enter correct phone number" duration:2.0f position:CSToastPositionCenter];

        return;
    }
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
//        if (_mTxtPhoneNumber.text.length > 0) {
            [SharedRef instance].strVisitorPhone = [NSString stringWithFormat:@"%@%@",_mTxtCountryCode.text,_mTxtPhoneNumber.text];
            [self onGetVisitorsWithPhone:[SharedRef instance].strVisitorPhone];
//        }else{
//            [self.view makeToast:@"Please enter correct phone number"];
//        }
    });

    
}
- (IBAction)onShowCodeTblTapped:(id)sender {
    [_mTblCountryCode setHidden:NO];
}

- (void)onGetVisitorsWithPhone:(NSString *)phoneNumber
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"visitor_mobile", nil];
    [ApiManager onPostApi:get_single_visitor_phone withDic:dic withCompletion:^(NSDictionary *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
                
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableArray *arrData = [NSMutableArray arrayWithArray:result[@"data"]];
            if (arrData.count > 0){
                [SharedRef instance].visiterModel = [[VisiterModel alloc] initWithDictionary:result[@"data"][0] error:nil];
            }else{
                [SharedRef instance].visiterModel = [[VisiterModel alloc] init];
            }
            [self gotoNextView];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:error.localizedDescription];
        });
    }];
}
- (void)gotoNextView{
    if ([[SharedRef instance].appSettingModel.skip_visitor_reg isEqualToString:@"on"]) {
        VisisterShowVC *visitorShowVC = [self.storyboard  instantiateViewControllerWithIdentifier:@"VisisterShowVC"];
        [self.navigationController pushViewController:visitorShowVC animated:YES];
    }else{
        FindReceiverVC *findReceiverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindReceiverVC"];
        [self.navigationController pushViewController:findReceiverVC animated:YES];
    }

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
    }
    //    [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
}

- (void)gotoFrontPageView{
    FrontPageVC *frontPageVC  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FrontPageVC"]; //or the homeController
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:frontPageVC];
    [UIApplication sharedApplication].windows.firstObject.rootViewController = navController;
}
#pragma makr UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SharedRef instance].dictCountryCodes.allKeys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CodeCell";
    CodeCell *cell = (CodeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CodeCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *allKeys = [[SharedRef instance].dictCountryCodes allKeys];
    NSArray *sortedKeys  = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [[SharedRef instance].dictCountryCodes objectForKey:a][0];
        NSString *second = [[SharedRef instance].dictCountryCodes objectForKey:b][0];
        return [first compare:second];
    }];
    NSString *txtName = [[SharedRef instance].dictCountryCodes objectForKey:sortedKeys[indexPath.row]][0];
    NSString *txtCode = [[SharedRef instance].dictCountryCodes objectForKey:sortedKeys[indexPath.row]][1];
    NSString *imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@", sortedKeys[indexPath.row]];
    cell.mLblName.text = [NSString stringWithFormat:@"%@ (%@)",txtName,sortedKeys[indexPath.row]];
    cell.mLblCode.text = [NSString stringWithFormat:@"+%@",txtCode];
    cell.mImgFlag.image = [UIImage imageNamed:imagePath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CodeCell *codeCell = [tableView cellForRowAtIndexPath:indexPath];
    _mImgFlag.image = codeCell.mImgFlag.image;
    _mTxtCountryCode.text = codeCell.mLblCode.text;
    [SharedRef instance].mFlag = _mImgFlag.image;
    [SharedRef instance].strCountryCode = _mTxtCountryCode.text;
    [_mTblCountryCode setHidden:YES];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_mTblCountryCode setHidden:YES];
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
