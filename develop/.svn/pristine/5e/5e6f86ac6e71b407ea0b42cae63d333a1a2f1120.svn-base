//
//  LoginViewController.m
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "LoginViewController.h"
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
#import "chooseOrg_model.h"
#import "CRNavigationController.h"
#import "DBOperate.h"
#import "whole_users_model.h"
#import "ThemeManager.h"
#import "LoginWarningTipsView.h"
#import "config.h"
#import "NetManager.h"
#import "UIViewController+NavigationBar.h"

@interface LoginViewController ()
{
    UITableView *_tableView;
    UITextField *userNameField;
    UITextField *pwdField;
    MBProgressHUD *mbProgressHUD;
    
    NSMutableArray *_loginArray;
    NSMutableData *_loginHeadData;
    NSMutableData *_heartBeatData;
    UIButton *_loginBtn;
    
    BOOL isLogining;
    
//    LoginWarningTipsView *_warningTipsView;
}
@property (nonatomic,retain) UITextField *userNameField;
@property (nonatomic,retain) UITextField *pwdField;
@property (nonatomic,retain) MBProgressHUD *mbProgressHUD;

@property (nonatomic, retain) NSString *userNameStr;

@end

#define kleftPadding 15.f
#define kpadding 15.f

@implementation LoginViewController
@synthesize userNameField,pwdField,mbProgressHUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isLogining = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationItem.title = @"登录";
    
    [self mainView];
}

/**
 *  主界面
 */
- (void)mainView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f,kpadding * 2, KUIScreenWidth, 100.f)style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    // 登录按钮
    _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(kleftPadding, CGRectGetMaxY(_tableView.frame) + 60, KUIScreenWidth - kleftPadding *2, 40.f)];
    [_loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 3;
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setBackgroundColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"]];
    if (_loginBtn.state == UIControlStateHighlighted) {
        [_loginBtn setBackgroundColor:[UIColor colorWithRed:50/255.0 green:96/255.0 blue:188/255.0 alpha:1]];
    }
    [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    // 忘记密码
    UIButton *_forgetPwd = [[UIButton alloc]initWithFrame:CGRectMake(200, KUIScreenHeight - 120.f, 60, 25)];
    [_forgetPwd setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPwd setBackgroundColor:[UIColor clearColor]];
    _forgetPwd.titleLabel.font = KQLSystemFont(14);
    [_forgetPwd setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
//    [_forgetPwd setTitleColor:COLOR_FONT forState:UIControlStateNormal];
    [_forgetPwd addTarget:self action:@selector(forgetPwdClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetPwd];
    [_forgetPwd release];//add booky
    
    // 没有账号
    UIButton *_noCountBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, KUIScreenHeight - 120.f, 100, 25)];
    [_noCountBtn setTitle:@"没有账号" forState:UIControlStateNormal];
    [_noCountBtn setBackgroundColor:[UIColor clearColor]];
    _noCountBtn.titleLabel.font = KQLSystemFont(14);
//    [_noCountBtn setTitleColor:[UIColor colorWithRed:205/255.0 green:51/255.0 blue:51/255.0 alpha:1.f] forState:UIControlStateNormal];
    [_noCountBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
    [_noCountBtn addTarget:self action:@selector(noAccountClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_noCountBtn];
    [_noCountBtn release];//add booky
    
    //自定义返回按钮  add vincnet
    UIButton *backButton = [self setBackBarButton:@"取消"];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //登陆改为红色提示语初始化  add by devin
    _alertHud = [AlertView new];
    _alertHud.hidden = YES;
    [self.view addSubview:_alertHud];
}

// 返回
- (void)backTo{
    if (!isLogining) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  忘记密码
 */
- (void)forgetPwdClick{
    if (!isLogining) {
        UpdatePassWordController1 *updatePwd = [[UpdatePassWordController1 alloc] init];
        [self.navigationController pushViewController:updatePwd animated:YES];
//        RELEASE_SAFE(updatePwd);
    }
}

/**
 *  没有账号
 */
- (void)noAccountClick{
    if (isLogining) {
        return;
    }
    WarmTipsViewController *warm = [[WarmTipsViewController alloc]init];
    warm.tipsString = @"你好！欢迎使用长江商学院广东校友会。此APP仅限内部成员交流，如果您是会员，还没有邀请码，请联系工作人员获取。你可以拨打号码 400-3568-456 咨询";
    warm.ttype = NoAcoutTips;
    
    CRNavigationController* crnv = [[CRNavigationController alloc] initWithRootViewController:warm];
    
    [self presentViewController:crnv animated:YES completion:nil];
    RELEASE_SAFE(warm);
    RELEASE_SAFE(crnv);
}

/**
 *  登录
 */
- (void)loginAction
{
    if (isLogining) {
        return;
    }

    [self showProgressHud];
    
    [self resigns];
    if (self.userNameField.text.length == 0 || self.pwdField.text.length == 0) {
//        [_loginBtn setUserInteractionEnabled:NO]; //add vincent  2014.7.5
        //[self removeProgressHud];
        //[self checkProgressHUD:QLLoginErrorWarning andImage:nil];
        [self removeProgressHud];
        
        [self alertShow:QLLoginErrorWarning]; // add by devin 换成这个提示语
        [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];//booky
	}else {
        // add vincent
        isLogining = YES;
        
        [_loginBtn setTitle:@"登录中..." forState:UIControlStateNormal];
		[[LoginManager shareLoginManager] loginWithUserName:[Common abandonPhoneType:self.userNameField.text] andPassword:self.pwdField.text];
        [[LoginManager shareLoginManager] setDelegete:self];
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

//延迟两秒后提示语消失
-(void)delay{
    _alertHud.hidden = YES;
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
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

-(void) showProgressHud{
    if (mbProgressHUD == nil) {
        mbProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        mbProgressHUD.labelText = @"登录中...";
        mbProgressHUD.mode = MBProgressHUDModeCustomView;
        [self.view addSubview:mbProgressHUD];
    }
    
    [mbProgressHUD show:YES];
    
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

#pragma mark - UITextFieldDelegate

// 键盘return按钮监听
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self resigns];
    return YES;
}

//输入框开始编辑回调
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (isLogining) {
        return;
    }
    
    if (textField == self.userNameField) {
        loginCell *cell = (loginCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.tipLabel.hidden = YES;
    }else if (textField == self.pwdField) {
       
    }
}

//add vincent 2014.7.5 当textField输入完成
- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField == self.userNameField) {
//        if ([self.userNameField.text length]!=0) {
//            loginCell *cell = (loginCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            cell.tipLabel.hidden = YES;
//            
//            //[self accessVerifyService];
//            
//            self.userNameField.text = [Common phoneNumTypeTurnWith:self.userNameField.text];
//        }
//    }
}

// 输入框清除按钮
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.pwdField.text = @"";
    if (textField == self.userNameField) {
        
    }else if(textField == self.pwdField){
        
    }
//    [_loginBtn setUserInteractionEnabled:NO]; add vincent
    return YES;
}

//add by vincent
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
       self.userNameStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
      if (textField == self.userNameField && textField.text.length!=0) {
          if (range.location < 10) {
              loginCell *cell = (loginCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
              cell.tipLabel.hidden = YES;
          } else if(range.location == 10){
              [self accessVerifyService];
          } else if(range.location >= 11){
              return NO;
          } else {
              return YES;
          }
      }
      return YES;
}


#pragma mark - UITableViewDataSource

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
            cell.iconV.image = IMGREADFILE(@"share_txcircle_store.png");
            [self.userNameField becomeFirstResponder];
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
    
    // 为了debug方便加入设备名称判断 Snail 的手机或者模拟器会自动填充账号密码
    NSString * deviceName = [[UIDevice currentDevice]name];
    if ([deviceName isEqualToString:@"LazySnail's iPhone"]) {
        self.userNameField.text = @"18617165016";
        self.pwdField.text = @"123456";
    } else if ([deviceName isEqualToString:@"iPhone Simulator"]){
        self.userNameField.text = @"18617165016";
        self.pwdField.text = @"123456";
    }
    return cell;
}

#pragma mark - accessService
//验证手机号码
- (void)accessVerifyService{
    
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [Common abandonPhoneType:self.userNameStr],@"mobile",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:VALIDATE_MOBILE_COMMAND_ID accessAdress:@"member/validatemobile.do?param=" delegate:self withParam:nil];
}

//请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    
    if (resultArray == nil) {
        [self alertShow:@"当前网络不可用，请检查你的网络设置"];
        return;
    }
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        
        // 判断是否有网络
        NSDictionary * resultDic = [resultArray firstObject];
        int resultInt = [[resultDic objectForKey:@"ret"]intValue];
       
        switch (commandid) {
//            case MEMBER_LOGIN_COMMAND_ID:
//            {
//                if (resultInt==0) {
//                    [self performSelectorOnMainThread:@selector(loginFail) withObject:nil waitUntilDone:NO];
//                }else if (resultInt==1){
//                    
//                    [Global sharedGlobal].user_id = [resultDic objectForKey:@"user_id"];
//                    
//                    if ([Global sharedGlobal].user_id != nil) {
//                        if (![[NSFileManager defaultManager]fileExistsAtPath:[FileManager getUserDBPath]]) {
//                            [DBOperate createUserDB];
//                        };
//                    }
//                    
//                    chooseOrg_model *orgMod = [[chooseOrg_model alloc]init];
//                    orgMod.where = nil;
//                    // **** 为何删除
//                    [orgMod deleteDBdata];
//                    
//                    NSMutableArray * allOrgIds = [NSMutableArray arrayWithCapacity:5];
//                    
//                    NSArray *orgArr = [resultDic objectForKey:@"organzations"];
//                    for (int i =0; i<orgArr.count; i++) {
//                        NSDictionary *orgDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                [[orgArr objectAtIndex:i] objectForKey:@"id"],@"id",
//                                                [[orgArr objectAtIndex:i] objectForKey:@"org_name"],@"org_name",
//                                                [[orgArr objectAtIndex:i] objectForKey:@"cat_pic"],@"cat_pic",
//                                                [[orgArr objectAtIndex:i] objectForKey:@"url"],@"url",
//                                                [[[orgArr objectAtIndex:i] objectForKey:@"welcome"] objectForKey:@"pic"],@"wel_pic",
//                                                [[[orgArr objectAtIndex:i] objectForKey:@"welcome"] objectForKey:@"content"],@"wel_content",
//                                                [[[orgArr objectAtIndex:i] objectForKey:@"welcome"] objectForKey:@"luokuan"],@"wel_luokuan",
//                                                [[[orgArr objectAtIndex:i] objectForKey:@"welcome"] objectForKey:@"btn"],@"wel_btn",
//                                                nil];
//                        [allOrgIds addObject:[[orgArr objectAtIndex:i] objectForKey:@"id"]];
//                        orgMod.where = [NSString stringWithFormat:@"id = %d",[[[orgArr objectAtIndex:i] objectForKey:@"id"] intValue]];
//                        
//                        NSMutableArray *dbArray = [orgMod getList];
//                        if ([dbArray count] > 0)
//                        {
//                            [orgMod updateDB:orgDic];
//                        }
//                        else{
//                            [orgMod insertDB:orgDic];
//                        }
//                        
//                    }
//                    
//                    NSString * userAccountName = [[NSUserDefaults standardUserDefaults]objectForKey:kPreviousUserName];
//                    NSString * userOrgJsonStr = [allOrgIds JSONRepresentation];
//                    
//                    //跟新应用系统数据库 用户快速切换用户
//                    NSDictionary * insertWholeUserOrgDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                            userAccountName,@"user_account_name",
//                                                            userOrgJsonStr,@"all_org_numbers",
//                                                            nil];
//                    [whole_users_model insertOrUpdataUserInfoWithDic:insertWholeUserOrgDic];
//                    
//                    
//                    [self performSelectorOnMainThread:@selector(loginSuccess:) withObject:resultArray waitUntilDone:NO];
//                }else if (resultInt==2){
//                    [self performSelectorOnMainThread:@selector(loginError) withObject:nil waitUntilDone:NO];
//                }else if (resultInt==3){
//                    [self performSelectorOnMainThread:@selector(userInfoNoExist) withObject:nil waitUntilDone:NO];
//                }
//                
//            }break;
            case VALIDATE_MOBILE_COMMAND_ID:
            {
                if (resultInt == 0) {
                    DLog(@"失败%@",resultArray);
                    loginCell *cell = (loginCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    cell.tipLabel.hidden = NO;
                }else if(resultInt == 1){
                    loginCell *cell = (loginCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    cell.tipLabel.hidden = YES;
                   DLog(@"%@",resultArray);
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
//            // 网络繁忙，请重新再试
//            [self checkProgressHUD:@"当前网络不可用，请检查你的网络设置" andImage:nil];
            
            [self alertShow:@"当前网络不可用，请检查你的网络设置"];// add by devin 换成这个提示语
        } else {
            // 当前网络不可用，请重新再试
           // [self checkProgressHUD:KCWNetNOPrompt andImage:nil];
            
            [self alertShow:KCWNetNOPrompt];// add by devin 换成这个提示语
        }
        
    }
    
}

- (void)removeProgressHud{
    [self.mbProgressHUD hide:YES];
    [self.mbProgressHUD removeFromSuperViewOnHide];
}

- (void)loginFailed:(LoginManager *)sender
{
    [self alertShow:@"服务器繁忙，登录失败"]; // add by devin 换成这个提示语
    isLogining = NO;
    [self removeProgressHud];
    
    //        add vincent
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    
}

//无网络
-(void) loginNoWeb:(LoginManager *)sender{
    [self alertShow:@"连接失败，请重试"];
    
    isLogining = NO;
    [self removeProgressHud];
    
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];

}

- (void)loginWithError:(LoginManager *)sender
{
    isLogining = NO;
    [self removeProgressHud];
    
    [self alertShow:@"用户名或密码错误,请重试"]; // add by devin 换成这个提示语
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
}

- (void)userUnExist:(LoginManager *)sender
{
    isLogining = NO;
    [self removeProgressHud];
    
    [self alertShow:@"用户名不存在"];// add by devin 换成这个提示语
    
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
}

- (void)LoginConnectFail{
    isLogining = NO;
    [self removeProgressHud];
    
   [self alertShow:@"网络连接失败，请重试"];// add by devin 换成这个提示语
    
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
}

//登录成功下载闪屏图
- (void)loginSuccess:(NSMutableArray*)resultArray {
    ChooseOrganizationViewController *orgCtl = [[ChooseOrganizationViewController alloc]init];
    [self.navigationController pushViewController:orgCtl animated:YES];
    RELEASE_SAFE(orgCtl);
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [self removeProgressHud];
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

#pragma mark- LoginManagerDelegate 

- (void)loginSuccess
{
    ChooseOrganizationViewController *orgCtl = [[ChooseOrganizationViewController alloc]init];
    [self.navigationController pushViewController:orgCtl animated:YES];
    RELEASE_SAFE(orgCtl);
}

- (void)dealloc
{
    [_loginBtn release]; _loginBtn = nil;
    [_tableView release]; _tableView = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loginSuccess" object:nil];
    [_alertHud release]; _alertHud = nil;
    [super dealloc];
}

@end
