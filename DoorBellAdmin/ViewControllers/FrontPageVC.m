//
//  FrontPageVC.m
//  DoorBellAdmin
//
//  Created by My Star on 3/17/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import "FrontPageVC.h"

@interface FrontPageVC ()
{
    NSIndexPath *lastIndexPath;
    NSTimer *countTimer;
    int count;
    int divideval;
    NSMutableArray *arrchoose;
    Boolean isFirstLoad;
    NSMutableArray *arrCompanies;
    Boolean isSearching;
}
@end

@implementation FrontPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstLoad = false;
    isSearching = false;
    arrchoose = [NSMutableArray array];
    arrCompanies = [NSMutableArray array];
    _mTxtSearchAndTitle.enabled = NO;
    [_mTxtSearch setHidden:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
    [self.mTxtSearchAndTitle.superview addGestureRecognizer:tapGesture];
    
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.mViewTitle addGestureRecognizer:singleFingerTap];

    
//    lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _txtView.delegate = self;
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.mCollectionCompanies.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(7, 7, 7, 7);
    layout.minimumColumnSpacing = 7.0f;
    layout.minimumInteritemSpacing = 7.0f;
    [self.mCollectionCompanies setBackgroundColor:[UIColor clearColor]];
    
    
    [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(getAllCompanies) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveNotification:) name:@"AppSetting" object:nil];
    // Do any additional setup after loading the view.
}
- (void)onReceiveNotification:(NSNotification *)notification{
    [self onChangeBackGround];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self startTimer];
    [self onChangeBackGround];
    count = 0;
    [SharedRef instance].companyModel = [[CompanyModel alloc] init];
    lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [SharedRef instance].adminModel = [[AdminModel alloc] init];
    [self.navigationController.navigationBar setHidden:YES];
    [self getAllCompanies];
    if (![[SharedRef instance].appSettingModel.company_logo_show isEqualToString:@"on"]){
        [self gotoVisitorShowView];
    }
    divideval = [SharedRef instance].appSettingModel.company_logo_size.intValue;
    if (!arrchoose.count){
        if ([SharedRef instance].arrCompanies.count > 0){
            for (CompanyModel *company in [SharedRef instance].arrCompanies){
                [arrchoose addObject:[NSNumber numberWithBool:NO]];
            }
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self stopTimer];
}
- (void)onChangeBackGround{
    [_mImgBack sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseBGEndPoint, [SharedRef instance].appSettingModel.bgimageurl]] placeholderImage:[UIImage imageNamed:@"imgback"]];
    divideval = [SharedRef instance].appSettingModel.company_logo_size.intValue;
    [self.mCollectionCompanies reloadData];
//    if (![[SharedRef instance].appSettingModel.company_logo_show isEqualToString:@"on"])
//    {
//        [self gotoVisitorShowView];
//    }
}
- (void)getAllCompanies{
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:[Utilities loadUserObjectWithKey]._id,@"userid", nil];
    [ApiManager onPostApi:getallcompanywithid withDic:body withCompletion:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SharedRef instance].arrCompanies = [NSMutableArray array];
            for (NSDictionary *tmpdic in dic[@"data"])
            {
//                if ([tmpdic[@"company_statu"] isEqualToString:@"Active"]) {
                    [[SharedRef instance].arrCompanies addObject:[[CompanyModel alloc] initWithDictionary:tmpdic error:nil]];
//                }
                if (!isFirstLoad){
                    [arrchoose addObject:[NSNumber numberWithBool:NO]];
                    
                }

            }
            
            if ([[SharedRef instance].appSettingModel.company_logo_show isEqualToString:@"on"]){
                if ( [SharedRef instance].companyModel._id.length <2){
                    [SharedRef instance].companyModel = [SharedRef instance].arrCompanies[lastIndexPath.row];
                }
            }
            if (!isFirstLoad)
                arrCompanies = [SharedRef instance].arrCompanies;
            if (!isSearching)
                arrCompanies = [SharedRef instance].arrCompanies;
            [self.mCollectionCompanies reloadData];
            isFirstLoad = true;
        });
        
    } failure:^(NSError *error) {
        [self.view makeToast:error.localizedDescription];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField

{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    return true;
}
- (void)keyboardWillChanged:(NSNotification *)notification{
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
}
- (IBAction)onOKTapped:(id)sender {
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
        [self gotoVisitorRegisterVC];
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (isSearching){
        return arrCompanies.count;
    }else{
        return [SharedRef instance].arrCompanies.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CompanyCollectionCell *cell = (CompanyCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CompanyCollectionCell"                                                                                forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.5f;
   
    CompanyModel *companyModel;
    if (isSearching){
        companyModel = arrCompanies[indexPath.row];
    }else{
        companyModel = [SharedRef instance].arrCompanies[indexPath.row];
    }
    
    
    [cell.mImgLogo  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseLogoURL, companyModel.company_logo]] placeholderImage:[UIImage imageNamed:@"ic_nocompanylogo"]];
//    cell.mLblTitle.text = companyModel.company_name;
    cell.mLblTitle.text = @"";
    if ([arrchoose[indexPath.row] boolValue]) {
        cell.mImgMark.image = [UIImage imageNamed:@"ic_checkbox"];
    }else{
        cell.mImgMark.image = [UIImage imageNamed:@"ic_checkbox1"];
    }
    return cell;
}

#pragma mark - CollectionViewDelegateWaterFallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.mCollectionCompanies.frame.size.height/divideval - 10;
    CGFloat width = self.mCollectionCompanies.frame.size.width/(divideval + 1) - 10;
    return CGSizeMake(width, height);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section
{
    return (divideval + 1);
}

#pragma mark UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![arrchoose[indexPath.row] boolValue]){
        [arrchoose replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
        if (isSearching)
            [SharedRef instance].companyModel = arrCompanies[indexPath.row];
        else
            [SharedRef instance].companyModel = [SharedRef instance].arrCompanies[indexPath.row];
        [self changeArr:indexPath.row];
    }else{
        [arrchoose replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
        [self initArr:0];
    }
    
    lastIndexPath = indexPath;
    [_mCollectionCompanies reloadData];
    
}

- (void) didRecognizeTapGesture:(UITapGestureRecognizer*) gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (CGRectContainsPoint(self.mTxtSearchAndTitle.frame, point)) {
            NSLog(@"%@", @"switched");
            if (!isSearching){
                isSearching = true;
                [_mTxtSearch setHidden:NO];
            }else{
                isSearching = false;
                [_mTxtSearch setHidden:YES];
            }

        }
    }
}


//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    if (CGRectContainsPoint(self.mViewTitle.frame, location)) {
        if (!isSearching){
            isSearching = true;
            [_mTxtSearch setHidden:NO];
        }else{
            isSearching = false;
            [_mTxtSearch setHidden:YES];
            [_mCollectionCompanies reloadData];
        }
    }
    //Do stuff here...
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
    if ([SharedRef instance].arrCompanies.count > 0) {
        UITextField *txtField = (UITextField *)sender;
        [self searchTextChangedFromSuper:txtField.text];
    }else{
        [self getAllCompanies];
    }
}
#pragma mark uitextfield bar delegate
- (void)searchTextChangedFromSuper:(NSString *)searchText{
    if (searchText.length == 0) {
        isSearching = false;
        [_mCollectionCompanies reloadData];
        return;
    }
    isSearching = true;
    [arrCompanies removeAllObjects];
    if (searchText != nil && ![searchText isEqualToString:@""]){
        for (CompanyModel *tmpCom in [SharedRef instance].arrCompanies){
            NSString *comtitle = [tmpCom.company_name lowercaseString];
            NSString *serachTxt = [searchText lowercaseString];
            NSLog(@"search %@%@",comtitle,serachTxt);
            NSRange comtitleRange = [comtitle rangeOfString:serachTxt];
            if (comtitleRange.location != NSNotFound){
                [arrCompanies addObject:tmpCom];
            }
        }
    }
    [self initArr:0];
    [self.mCollectionCompanies reloadData];
    
}


- (void)changeArr: (NSInteger)index{
    for (int i = 0; i < [arrchoose count]; i ++){
        if(i != index && [arrchoose[i] boolValue]){
            [arrchoose replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
        }
    }
}
- (void)initArr: (NSInteger)index{
    for (int i = 0; i < [arrchoose count]; i ++){
        if([arrchoose[i] boolValue])
            [arrchoose replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)gotoVisitorRegisterVC {
    VisiterRegisterVC *visitorRegisterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VisiterRegisterVC"];
    [self.navigationController pushViewController:visitorRegisterVC animated:YES];
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
    if (![[SharedRef instance].appSettingModel.company_logo_show isEqualToString:@"on"]){
        [self gotoVisitorShowView];
    }
    [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
}
- (void)gotoVisitorShowView{
    VisiterRegisterVC *visiterRegisterVC  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VisiterRegisterVC"]; //or the homeController
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:visiterRegisterVC];
    [UIApplication sharedApplication].windows.firstObject.rootViewController = navController;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_mTxtSearch setHidden:YES];
    isSearching = false;
    [_mCollectionCompanies reloadData];
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
