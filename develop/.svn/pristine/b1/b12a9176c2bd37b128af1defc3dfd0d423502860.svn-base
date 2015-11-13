//
//  SetPassWordViewController.m
//  ql
//
//  Created by yunlai on 14-3-5.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "SetPassWordViewController.h"
#import "MBProgressHUD.h"
#import "Common.h"
#import "UIImageScale.h"
#import "loginCell.h"
#import "userInfoClass.h"
#import "ChooseOrganizationViewController.h"
#import "UIViewController+NavigationBar.h"
#import "ServiceViewController.h"

@interface SetPassWordViewController ()
{
    UITableView *_tableView;
}

@property (nonatomic,retain) UITextField *userNameField;
@property (nonatomic,retain) UITextField *userPwdField;

@end

#define kleftPadding 30.f
#define kpadding 15.f


@implementation SetPassWordViewController
@synthesize userNameField = _userNameField;
@synthesize userPwdField = _userPwdField;
@synthesize moblieStrPwd = _moblieStrPwd;
@synthesize typeV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.typeV == SetPasswordViewTypeRegister) {
        self.title = @"注册";;
    }else{
        self.title = @"重置密码";
    }
	
    [self backBtn];//add vincent
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    [self mainView];
    userInfoClass *info = [[userInfoClass alloc]init];
    NSLog(@"userOrgId==%@",info.userName);
}

-(void)backBtn{
    //返回按钮  add vincnet
    UIButton *backButton = [self setBackBarButton:nil];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
}

// 返回 add vincnet
- (void)backTo{
    
    [self.navigationController popViewControllerAnimated:NO];
}

/**
 *  完成事件
 */
- (void)finishTo{
    [self resigns];
    if (self.userPwdField.text.length !=0) {
        if (self.userPwdField.text.length<6) {
            [Common checkProgressHUD:@"密码长度不能为小于6位" andImage:nil showInView:self.view];
        }else{
            if (self.typeV == SetPasswordViewTypeRegister) {
                [self accessRegisterService];
            }
            else{
                [self accessUpdatePwdService];
            }
    }
    }else{
        [self.userPwdField resignFirstResponder];
        
        [Common checkProgressHUD:@"密码不能为空" andImage:nil showInView:self.view];
    }
}


/**
 *  主界面
 */
- (void)mainView{
    
    // 提示语
    UILabel *_tipsLable = [[UILabel alloc]initWithFrame:CGRectMake(kleftPadding , kpadding, KUIScreenWidth - kleftPadding *2, 40)];
    _tipsLable.text = @"号码验证正确";
    _tipsLable.textColor = [UIColor grayColor];
    _tipsLable.font = KQLSystemFont(16);
    _tipsLable.textAlignment = NSTextAlignmentCenter;
    _tipsLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tipsLable];
    
    // 手机号
    UILabel *_mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(kleftPadding , CGRectGetMaxY(_tipsLable.frame) - 5, KUIScreenWidth - kleftPadding *2, 40)];
//    _mobileLabel.text = self.moblieStrPwd;
    _mobileLabel.text = [Common phoneNumTypeTurnWith:self.moblieStrPwd];
    _mobileLabel.textColor = [UIColor grayColor];
    _mobileLabel.font = KQLSystemFont(18);
    _mobileLabel.textAlignment = NSTextAlignmentCenter;
    _mobileLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mobileLabel];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_mobileLabel.frame) + 140.f,  CGRectGetMaxY(_tipsLable.frame) + 5, 20.f, 20.f)];
    imgView.image = IMGREADFILE(@"ico_landing_correct.png");
    [self.view addSubview:imgView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(_tipsLable.frame)+kpadding * 3, KUIScreenWidth, 44.f)style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    RELEASE_SAFE(_mobileLabel);
    RELEASE_SAFE(_tipsLable);
    RELEASE_SAFE(imgView);
    
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(_tableView.frame) + 10.f, 200.f, 30.f)];
    tip.text = @"点击确定，即表示你同意";
    tip.font = KQLSystemFont(13);
    tip.textColor = [UIColor grayColor];
    tip.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tip];
    [tip release];
    
    //没有邀请码按钮
    UIButton *_errorMoblie = [UIButton buttonWithType:UIButtonTypeCustom];
    _errorMoblie.frame = CGRectMake(150,CGRectGetMaxY(_tableView.frame) + 10.f, 150.f, 30.f);
    [_errorMoblie setTitle:@" 《云圈用户服务协议》" forState:UIControlStateNormal];
    [_errorMoblie setTitleColor:COLOR_FONT forState:UIControlStateNormal];
    [_errorMoblie setBackgroundColor:[UIColor clearColor]];
    [_errorMoblie addTarget:self action:@selector(notCodeClick) forControlEvents:UIControlEventTouchUpInside];
    _errorMoblie.titleLabel.font = KQLSystemFont(13);
    [self.view addSubview:_errorMoblie];
    
    
    UIButton *confimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confimBtn setFrame:CGRectMake(15.f, CGRectGetMaxY(_tableView.frame) + 50.f, KUIScreenWidth - 30.f, 40.f)];
    [confimBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [confimBtn setBackgroundColor:[UIColor whiteColor]];
    [confimBtn setBackgroundColor:COLOR_GRAY2];
//    [confimBtn setBackgroundColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"]];
//    [confimBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
    confimBtn.tag = 123;
    [confimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confimBtn addTarget:self action:@selector(finishTo) forControlEvents:UIControlEventTouchUpInside];
    confimBtn.layer.cornerRadius = 5;
    [self.view addSubview:confimBtn];
    
}

- (void)notCodeClick {
    ServiceViewController *serviceVC = [[ServiceViewController alloc]init];
    [self.navigationController pushViewController:serviceVC animated:YES];
    RELEASE_SAFE(serviceVC);
}

/**
 *  隐藏键盘
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resigns];
}

- (void)resigns{
    [self.userNameField resignFirstResponder];
    [self.userPwdField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  提示框
 *
 *  @param value 提示的文字信息
 *  @param img   提示的ICON
 */
- (void)checkProgressHUD:(NSString *)value andImage:(UIImage *)img{
    
    MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUDTmp.center=CGPointMake(self.view.center.x, self.view.center.y+120);
    progressHUDTmp.customView= [[[UIImageView alloc] initWithImage:img] autorelease];
    progressHUDTmp.mode = MBProgressHUDModeCustomView;
    progressHUDTmp.labelText = value;
    [self.view addSubview:progressHUDTmp];
    [self.view bringSubviewToFront:progressHUDTmp];
    [progressHUDTmp show:YES];
    [progressHUDTmp hide:YES afterDelay:1];
    RELEASE_SAFE(progressHUDTmp);
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    loginCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[loginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    self.userPwdField = cell.loginField;
    self.userPwdField.placeholder = @" 设置密码";
    self.userPwdField.delegate=self;
    self.userPwdField.tag = 2;
    self.userPwdField.keyboardType = UIKeyboardTypeDefault;
    self.userPwdField.secureTextEntry = YES;
    
    cell.iconV.image = IMGREADFILE(@"share_txcircle_store.png");
   
    [cell setCellStyleIcon:NO hiddenAll:YES];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];

    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (IOS_VERSION_7) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    return cell;
}

#pragma mark - accessService
/**
 *  网络请求
 */
- (void)accessRegisterService{
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        self.moblieStrPwd,@"username",
                                       [Common sha1:self.userPwdField.text],@"password",
                                        [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:MEMBER_REGIST_COMMAND_ID accessAdress:@"member/register.do?param=" delegate:self withParam:nil];
}

// 网络请求
- (void)accessUpdatePwdService
{
    
    NSString *reqUrl = @"member/login.do?param=";
	
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.moblieStrPwd,@"username",
                                       [Common sha1:self.userPwdField.text],@"password",
                                       [NSNumber numberWithInt:1],@"type",
                                       nil];
    
    [[NetManager sharedManager] accessService:requestDic data:nil command:MEMBER_UPDATEPWD_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
    
}

/**
 *  请求回调
 *
 *  @param resultArray 请求返回的数据
 *  @param commandid   请求的commandId
 *  @param ver         版本号
 */
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        
        int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
        NSLog(@"resultInt=%d",resultInt);
        switch (commandid) {
            case MEMBER_REGIST_COMMAND_ID:
            {
                if (resultInt == 0) {
                    [self performSelectorOnMainThread:@selector(registerError) withObject:nil waitUntilDone:NO];
                    
                }else if(resultInt == 1){
                    
                    [self performSelectorOnMainThread:@selector(registerSuccess) withObject:nil waitUntilDone:NO];
                }
                else if(resultInt == 2){
                
                    [self performSelectorOnMainThread:@selector(exist) withObject:nil waitUntilDone:NO];
                }
                else if(resultInt == 3){
            
                    [self performSelectorOnMainThread:@selector(authCodeTimeOut) withObject:nil waitUntilDone:NO];
        
                }else if(resultInt == 4){
        
                    [self performSelectorOnMainThread:@selector(authCodeError) withObject:nil waitUntilDone:NO];
                }
            }break;
                
            case MEMBER_UPDATEPWD_COMMAND_ID:
            {
                if (resultInt == 0) {
                    [self performSelectorOnMainThread:@selector(updateError) withObject:nil waitUntilDone:NO];
                    
                }else if(resultInt == 1){
                    
                    [self performSelectorOnMainThread:@selector(updateSuccess) withObject:nil waitUntilDone:NO];
                }
                }break;
                
            default:
                break;
        }
        
    }else{
        
        UIImage *img = [UIImage imageCwNamed:@"icon_tip_normal.png"];
        
        if ([Common connectedToNetwork]) {
            // 网络繁忙，请重新再试
            [self checkProgressHUD:@"当前网络不可用，请检查你的网络设置" andImage:img];
        } else {
            // 当前网络不可用，请重新再试
            
            [self checkProgressHUD:KCWNetNOPrompt andImage:img];
        }
        
    }
}

- (void)registerError{
    
}


- (void)registerSuccess{
    // ****有问题
    UIImage *img = [UIImage imageCwNamed:@"txqqbo_ico_48.png"];
    
    [self checkProgressHUD:@"恭喜！注册成功" andImage:img];
    
    LoginManager * lmanager = [LoginManager new];
    lmanager.delegete = self;
    [lmanager loginWithUserName:self.moblieStrPwd andPassword:self.userPwdField.text];
}

- (void)exist{
    [self checkProgressHUD:@"用户已经存在！" andImage:nil];
}

- (void)authCodeTimeOut{
    [self checkProgressHUD:@"验证码超时，请重试！" andImage:nil];
}

- (void)authCodeError{
    [self checkProgressHUD:@"验证码错误,请重试!" andImage:nil];
}

- (void)updateError{
    [self checkProgressHUD:@"重置密码失败" andImage:nil];
}
- (void)updateSuccess{
    [self checkProgressHUD:@"重置密码成功" andImage:nil];
    
    [[LoginManager shareLoginManager] loginWithUserName:[Common abandonPhoneType:self.moblieStrPwd] andPassword:self.userPwdField.text];
    [[LoginManager shareLoginManager] setDelegete:self];// add by devin
}

#pragma mark - LoginManagerDelegate

- (void)loginSuccess:(LoginManager *)sender
{
    ChooseOrganizationViewController *orgCtl = [[ChooseOrganizationViewController alloc]init];
    if (self.typeV == SetPasswordViewTypeRegister) {
        orgCtl.LoginType = 1;
    }else{
        orgCtl.LoginType = 0;
    }
//    orgCtl.LoginType = 1;
    [self.navigationController pushViewController:orgCtl animated:YES];
    RELEASE_SAFE(orgCtl);
    RELEASE_SAFE(sender);
}
#pragma mark - UITextFieldDelegate
//add vincent
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UIButton *btn  = (UIButton *)[self.view viewWithTag:123];
    btn.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    [btn setUserInteractionEnabled:YES];
    
    return YES;
}
//add vincent
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    UIButton *btn  = (UIButton *)[self.view viewWithTag:123];
    [btn setBackgroundColor:COLOR_GRAY2];
    
    return YES;
}
@end
