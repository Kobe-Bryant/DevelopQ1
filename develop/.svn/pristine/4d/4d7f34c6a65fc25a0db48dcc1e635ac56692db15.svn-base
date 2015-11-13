//
//  AcceptInvitationLoginController.m
//  ql
//
//  Created by yunlai on 14-5-27.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "AcceptInvitationLoginController.h"
#import "UpdatepwdViewController.h"
#import "InvitationCodeViewController.h"
#import "VerifyViewController.h"
#import "WarmTipsViewController.h"
#import "IdentityViewController.h"
#import "UpdatePassWordController1.h"
#import "userInfo_setting_model.h"
#import "ChooseOrganizationViewController.h"
#import "Common.h"
#import "loginCell.h"
#import "Global.h"
#import "headParseClass.h"
#import "ChatDataClass.h"
#import "TcpRequestHelper.h"
#import "login_info_model.h"

#import "LoginManager.h"

@interface AcceptInvitationLoginController ()
{
    UITableView *_tableView;
    UITextField *userNameField;
    UITextField *pwdField;
    MBProgressHUD *mbProgressHUD;
    
    NSMutableArray *_loginArray;
    NSMutableData *_loginHeadData;
    NSMutableData *_heartBeatData;
    UIButton *_loginBtn;
}
@property (nonatomic,retain) UITextField *userNameField;
@property (nonatomic,retain) UITextField *pwdField;
@property (nonatomic,retain) MBProgressHUD *mbProgressHUD;
@end

#define kleftPadding 15.f
#define kpadding 15.f


@implementation AcceptInvitationLoginController
@synthesize userNameField,pwdField,mbProgressHUD,mobiles,userName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//	self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationItem.title = @"登录";
    
    [self mainView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(socketLogin) name:@"loginSuccess" object:nil];
    
    //登陆改为红色提示语初始化  add by devin
    _alertHud = [AlertView new];
    _alertHud.hidden = YES;
    [self.view addSubview:_alertHud];
    [_alertHud release];
    
}

/**
 *  主界面
 */
- (void)mainView{
    
    // 提示语
    UILabel *_tipsLable = [[UILabel alloc]initWithFrame:CGRectMake(kleftPadding , kpadding, KUIScreenWidth - kleftPadding *2, 40)];
    _tipsLable.text = [NSString stringWithFormat:@"%@先生,您已接受邀请,请直接登陆",self.userName];
    _tipsLable.textColor = [UIColor grayColor];
    _tipsLable.font = KQLSystemFont(15);
    _tipsLable.textAlignment = NSTextAlignmentCenter;
    _tipsLable.backgroundColor = [UIColor clearColor];
    _tipsLable.numberOfLines = 2;
    _tipsLable.lineBreakMode = UILineBreakModeWordWrap;
    [self.view addSubview:_tipsLable];
    RELEASE_SAFE(_tipsLable);//add vincent
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f,kpadding * 4, KUIScreenWidth, 100.f)style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    // 登录按钮
    _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(kleftPadding, CGRectGetMaxY(_tableView.frame) + 50 +5, KUIScreenWidth - kleftPadding *2, 40.f)];
    [_loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 3;
//    [_loginBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_FONT"] forState:UIControlStateNormal];
//    [_loginBtn setTitleColor:COLOR_FONT forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_loginBtn setBackgroundColor:[UIColor whiteColor]];
    [_loginBtn setBackgroundColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"]];
    if (_loginBtn.state == UIControlStateHighlighted) {
        [_loginBtn setBackgroundColor:[UIColor colorWithRed:50/255.0 green:96/255.0 blue:188/255.0 alpha:1]];
    }
    [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    // 忘记密码
    UIButton *_forgetPwd = [[UIButton alloc]initWithFrame:CGRectMake(110,KUIScreenHeight - 120.f, 100, 25)];
    [_forgetPwd setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPwd setBackgroundColor:[UIColor clearColor]];
    _forgetPwd.titleLabel.font = KQLSystemFont(14);
    [_forgetPwd setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
//    [_forgetPwd setTitleColor:COLOR_FONT forState:UIControlStateNormal];
    [_forgetPwd addTarget:self action:@selector(forgetPwdClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetPwd];
    
    //自定义返回按钮
    
    UIButton *barbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    barbutton.frame = CGRectMake(0.0f, 0.0f, 40.f, 30.f);
    
//    [barbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [barbutton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    [barbutton setTitle:@"取消" forState:UIControlStateNormal];
    barbutton.titleLabel.font = KQLboldSystemFont(14);
    
    if (IOS_VERSION_7) {
        barbutton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    }
    [barbutton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:barbutton];
    self.navigationItem.leftBarButtonItem = barBtnItem;
    
    RELEASE_SAFE(barBtnItem);
}

// 返回
- (void)backTo{
    
   [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  忘记密码
 */
- (void)forgetPwdClick{
    UpdatePassWordController1 *updatePwd = [[UpdatePassWordController1 alloc]init];
    [self.navigationController pushViewController:updatePwd animated:YES];
    RELEASE_SAFE(updatePwd);
    
}

/**
 *  登录
 */
- (void)loginAction
{
    [self resigns];
    [self showProgressHud];
    if ( self.pwdField.text.length == 0) {
        [self removeProgressHud];
        [self alertShow:@"密码不能为空"];
        
	}else {
        [_loginBtn setTitle:@"登录中..." forState:UIControlStateNormal];

        [[LoginManager shareLoginManager] loginWithUserName:self.userNameField.text andPassword:self.pwdField.text];
        [LoginManager shareLoginManager].delegete = self;
        
	}
    
}



// 隐藏键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resigns];
}

// 放弃第一响应者
- (void)resigns{
    [self.userNameField resignFirstResponder];
    [self.pwdField resignFirstResponder];
}

-(void) showProgressHud{
    if (mbProgressHUD == nil) {
        mbProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        mbProgressHUD.labelText = @"登录中...";
        mbProgressHUD.mode = MBProgressHUDModeCustomView;
        [self.view addSubview:mbProgressHUD];
    }
    
    [mbProgressHUD show:YES];
    
}
- (void)removeProgressHud{
    [self.mbProgressHUD hide:YES];
    [self.mbProgressHUD removeFromSuperViewOnHide];
}

//提示语
-(void)alertShow:(NSString *)text{
    _alertHud.lable.text = text;
    CGSize lableSize = [_alertHud.lable.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    _alertHud.lable.frame = CGRectMake(18, 0, lableSize.width, 20);
    _alertHud.frame = CGRectMake((320-lableSize.width-15)/2, CGRectGetMaxY(_tableView.frame) + 20, lableSize.width+18, 20);
    _alertHud.backgroundColor = [UIColor clearColor];
    _alertHud.hidden = NO;
    [self performSelector:@selector(delay) withObject:self afterDelay:1];
}
-(void)delay{
    _alertHud.hidden = YES;
}


// 提示框
- (void)checkProgressHUD:(NSString *)value andImage:(UIImage *)img{
    
    MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUDTmp.center=CGPointMake(self.view.center.x, self.view.center.y);
    progressHUDTmp.customView= [[[UIImageView alloc] initWithImage:img] autorelease];
    progressHUDTmp.mode = MBProgressHUDModeCustomView;
    progressHUDTmp.labelText = value;
    [self.view addSubview:progressHUDTmp];
    [self.view bringSubviewToFront:progressHUDTmp];
    [progressHUDTmp show:YES];
    [progressHUDTmp hide:YES afterDelay:1];
    RELEASE_SAFE(progressHUDTmp);
    
}

- (void)socketLogin{
    
//    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - UITextFieldDelegate

// 键盘return按钮监听
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resigns];
    return YES;
}

//输入框开始编辑回调
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.pwdField) {
        
    }
}

// 输入框清除按钮
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.pwdField.text = @"";
    if (textField == self.userNameField) {
        
    }else if(textField == self.pwdField){
        
    }
    [_loginBtn setUserInteractionEnabled:NO];
    return YES;
}

//限制输入框手机号码11位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField ==self.userNameField && range.location ==0) {
        
        
    } else if (textField == self.userNameField && textField.text.length!=0) {
        
        if (range.location >= 11){
            
           // [self checkProgressHUD:@"请输入11位的手机号码" andImage:nil];
            [self alertShow:@"请输入11位的手机号码"];
            return NO;
        }
    }
    return YES;
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    loginCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[loginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.contentView.backgroundColor =  [UIColor whiteColor];
        
        [cell setCellStyleIcon:NO hiddenAll:YES];
    }
    switch (indexPath.row) {
        case 0:
        {
            self.userNameField = cell.loginField;
            self.userNameField.placeholder = @" 账号";
            self.userNameField.delegate=self;
            self.userNameField.tag = 1;
            self.userNameField.keyboardType = UIKeyboardTypeNumberPad;
            self.userNameField.text = self.mobiles;
            self.userNameField.enabled = NO;
            cell.iconV.image = IMGREADFILE(@"share_txcircle_store.png");
  
        }
            break;
            
        case 1:
        {
            self.pwdField = cell.loginField;
            self.pwdField.placeholder = @" 密码";
            self.pwdField.delegate=self;
            self.pwdField.tag = 2;
            self.pwdField.secureTextEntry = YES;
            self.pwdField.keyboardType = UIKeyboardTypeDefault;
            
            cell.iconV.image = IMGREADFILE(@"share_txcircle_store.png");
            
        }
            break;
            
        default:
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (IOS_VERSION_7) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    return cell;
}

#pragma mark - accessService
// 网络请求
- (void)accessLoginService
{
    
    NSString *reqUrl = @"member/login.do?param=";
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.userNameField.text,@"username",
                                       [Common sha1:self.pwdField.text],@"password",
                                       [NSNumber numberWithInt:0],@"type",
                                       nil];
    
    [[NetManager sharedManager] accessService:requestDic data:nil command:MEMBER_LOGIN_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
    
}

//请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        
        // 判断是否有网络
        int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
        
        switch (commandid) {
            case MEMBER_LOGIN_COMMAND_ID:
            {
                if (resultInt==0) {
                    [self performSelectorOnMainThread:@selector(loginFail) withObject:nil waitUntilDone:NO];
                }else if (resultInt==1){
                    [self performSelectorOnMainThread:@selector(loginSuccess:) withObject:resultArray waitUntilDone:NO];
                }else if (resultInt==2){
                    [self performSelectorOnMainThread:@selector(loginError) withObject:nil waitUntilDone:NO];
                }else if (resultInt==3){
                    [self performSelectorOnMainThread:@selector(userInfoNoExist) withObject:nil waitUntilDone:NO];
                }
                
            }break;
                
            case MEMBER_UPDATEPIMAGE_COMMAND_ID:
            {
                
                if (resultInt==1) {
                    
                    //上传成功后开辟子线程更新本地数据库头像路径
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        [self performSelectorOnMainThread:@selector(updateImageSuccess:) withObject:resultArray waitUntilDone:NO];
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //主线程更新UI
                            
                        });
                    });
                    
                    
                }else {
                    
                    [self performSelectorOnMainThread:@selector(updateImageFail) withObject:nil waitUntilDone:NO];
                    
                }
            }break;
            default:
                break;
        }
	}else{
        [self removeProgressHud];
        
        if ([Common connectedToNetwork]) {
            // 网络繁忙，请重新再试
            //[self checkProgressHUD:@"当前网络不可用，请检查你的网络设置" andImage:nil];
            [self alertShow:@"当前网络不可用，请检查你的网络设置"];
        } else {
            // 当前网络不可用，请重新再试
            //[self checkProgressHUD:KCWNetNOPrompt andImage:nil];
            [self alertShow:KCWNetNOPrompt];
        }
        
    }
    
}

- (void)loginFail
{
    [self removeProgressHud];
//    [self checkProgressHUD:@"服务器繁忙，登录失败" andImage:nil];
    [self alertShow:@"服务器繁忙，登录失败"];
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    
}

- (void)loginError{
    [self removeProgressHud];
//    [self checkProgressHUD:@"用户名或密码错误" andImage:nil];
    [self alertShow:@"输入密码错误"];
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
}

-(void) loginWithError:(LoginManager *)sender{
    [self removeProgressHud];
//    [self checkProgressHUD:@"用户名或密码错误" andImage:nil];
    [self alertShow:@"输入密码错误"];
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
}

- (void)userInfoNoExist{
    [self removeProgressHud];
//    [self checkProgressHUD:@"用户名不存在" andImage:nil];
    [self alertShow:@"用户名不存在"];
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
}

//- (void)loginSuccess:(NSMutableArray*)resultArray
-(void)loginSuccess:(LoginManager *)sender
{
    //    [self dismissViewControllerAnimated:NO completion:nil];
    //tcp连接服务器 Snail modifiied 5.23
//    BOOL isConnected = [[ChatTcpHelper shareChatTcpHelper]connectToHost];
//    //tcp登录
//    if (isConnected) {
//        [[TcpRequestHelper shareTcpRequestHelperHelper]sendLogingPackageCommandId:TCP_LOGIN_COMMAND_ID];
//    }
//    
//    [Global sharedGlobal].isLogin = YES;
//    //下次程序启动是否自动登录状态判断
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAutoLogin"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ChooseOrganizationViewController *orgCtl = [[ChooseOrganizationViewController alloc]init];
    orgCtl.LoginType = 1;
    [self.navigationController pushViewController:orgCtl animated:YES];
    RELEASE_SAFE(orgCtl);
    
    [self userNameInsertTable];
    
    [self removeProgressHud];
//    [self getUserIdSave];
    
//    [self configSet];
}

//booky add 5.6
-(void) configSet{
    
    userInfo_setting_model* setMod = [[userInfo_setting_model alloc] init];
    
    setMod.where = [NSString stringWithFormat:@"id = %d",[[Global sharedGlobal].user_id intValue]];
    NSArray* arr = [NSArray arrayWithArray:[setMod getList]];
    
    NSDictionary* dic = [arr lastObject];
    
    if ([[dic objectForKey:@"msg_alert"] intValue] == 1) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"talkMsg"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"talkMsg"];
    }
    
    if ([[dic objectForKey:@"dynamic_alert"] intValue] == 1) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"publicMsg"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"publicMsg"];
    }
    
    if ([[dic objectForKey:@"supply_demand_alert"] intValue] == 1) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"iWantMsg"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iWantMsg"];
    }
    
    if ([[dic objectForKey:@"open_time_alert"] intValue] == 1) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"openTimeMsg"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"openTimeMsg"];
    }
    
    if ([[dic objectForKey:@"company_dynamic_alert"] intValue] == 1) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"companyMsg"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"companyMsg"];
    }
    
    if ([[dic objectForKey:@"private"] intValue] == 1) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"pwProtect"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"pwProtect"];
    }
    
    [setMod release];
}

// 用户名保存
- (void)userNameInsertTable{
    //密码加密
    [SFHFKeychainUtils storeUsername:self.userNameField.text andPassword:self.pwdField.text forServiceName:SignSecureKey updateExisting:YES error:nil];
}

- (void)getUserIdSave{
    login_info_model *userInfo = [[login_info_model alloc]init];
    NSArray *infoArr = [userInfo getList];
    
    if (infoArr.count !=0) {
        [Global sharedGlobal].user_id = [[infoArr objectAtIndex:0]objectForKey:@"id"];
    }
    RELEASE_SAFE(userInfo);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateUserInfo" object:infoArr];
    
}


- (void)updateImageSuccess:(NSMutableArray*)resultArray
{
    
    [self.mbProgressHUD hide:YES];
    [self.mbProgressHUD removeFromSuperViewOnHide];
    
    [self checkProgressHUD:@"上传成功" andImage:nil];
    
    
    
    NSLog(@"success");
}

-(void)updateImageFail{
    
    [self.mbProgressHUD hide:YES];
    [self.mbProgressHUD removeFromSuperViewOnHide];
    [self checkProgressHUD:@"上传头像失败" andImage:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loginSuccess" object:nil];
    [super dealloc];
}

@end
