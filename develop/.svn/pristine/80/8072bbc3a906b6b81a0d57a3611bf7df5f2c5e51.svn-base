//
//  SettingMainViewController.m
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "SettingMainViewController.h"

#import "aboutUsViewController.h"
#import "msgSetViewController.h"
#import "pwViewController.h"

#import "Common.h"
#import "TcpRequestHelper.h"

#import "GuidePageViewController.h"
#import "CRNavigationController.h"
#import "SidebarViewController.h"

#import "WarmTipsViewController.h"
#import "userInfo_setting_model.h"

#import "mainpage_userInfo_model.h"
#import "mainpage_supplydemand_model.h"
#import "mainpage_newpublish_model.h"
#import "mainpage_company_model.h"
#import "mianpage_company_dynamic_model.h"
#import "invite_join_circlemsg_model.h"
#import "user_circles_model.h"
#import "browserViewController.h"
#import "circle_list_model.h"
#import "upgrade_model.h"
#import "ServiceViewController.h"
#import "SessionViewController.h"

@interface SettingMainViewController ()<pwDelegate>{
//    静态cell组（弃用）
    NSMutableArray* setCells;
    NSArray* footerStrArr;
//    cell文本组
    NSArray* tableCellStrArr;
//    版本信息
    NSDictionary* verDic;
//    服务器版本号
    int upgradeVer;
}

@property(nonatomic,retain) UITableView* tableview;
@property(nonatomic,retain) UIButton* logOutBtn;
@property(nonatomic,retain) UISwitch* pws;

@end

@implementation SettingMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        setCells = [[NSMutableArray alloc] init];
        
        footerStrArr = [[NSArray alloc] initWithObjects:
//                        @"设置独立密码可以防止他人查看APP内容",
                        @"设置想要接收的消息",
                        nil];
        
        upgrade_model* upgradeMod = [[upgrade_model alloc] init];
        NSArray* arr = [upgradeMod getList];
        [upgradeMod release];
        
        upgradeVer = [[[arr firstObject] objectForKey:@"ver"] intValue];
        
        verDic = [[arr firstObject] copy];
        
        NSString* scoreUrl = [verDic objectForKey:@"scoreUrl"];
        
        //评分地址为空时，不展示出鼓励我们选项
        if (scoreUrl && scoreUrl.length > 0) {
            tableCellStrArr = [[NSArray alloc] initWithObjects:
                               @"提意见",
                               @"鼓励我们",
                               @"检查新版本",
                               @"关于我们",
                               @"服务协议",nil];
        }else{
            tableCellStrArr = [[NSArray alloc] initWithObjects:
                               @"提意见",
                               @"检查新版本",
                               @"关于我们",
                               @"服务协议", nil];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.title = @"设置";
    
    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
//    初始化返回
    [self backBar];
//    初始化静态cell
    [self initCells];
//    初始化列表
    [self initTable];
    
}

/**
 *  返回按钮
 */
- (void)backBar{
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    RELEASE_SAFE(backItem);
}
//返回
- (void)backTo
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) initTable{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [_tableview setBackgroundColor:[UIColor clearColor]];
    _tableview.showsVerticalScrollIndicator = NO;
    if (IOS_VERSION_7) {
        _tableview.separatorInset = UIEdgeInsetsZero;
    }
    [self.view addSubview:_tableview];
    
    UIView* footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
    footerV.backgroundColor = [UIColor colorWithRed:232/255.0 green:237/255.0 blue:240/255.0 alpha:1];
    
    _logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _logOutBtn.frame = CGRectMake(20, 20, 280, 40);
    [_logOutBtn setTitle:@"退出账号" forState:UIControlStateNormal];
    [_logOutBtn setTitleColor:[UIColor colorWithRed:0.96 green:0.30 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
    [_logOutBtn addTarget:self action:@selector(logOutClick) forControlEvents:UIControlEventTouchUpInside];
    [_logOutBtn setBackgroundImage:IMG(@"btn_set_exit") forState:UIControlStateNormal];
    _logOutBtn.layer.cornerRadius = 5.0;
    [_logOutBtn.layer setMasksToBounds:YES];
    [footerV addSubview:_logOutBtn];
    
    _tableview.tableFooterView = footerV;
    
    RELEASE_SAFE(footerV);
}

#pragma mark - 退出登陆
-(void) logOutClick{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"退出云圈将无法接收到朋友们的消息哦，您确定要退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1000;
    [alert show];
    RELEASE_SAFE(alert);//add vincent
    
}

-(void) initCells{
    //初始化静态cells
//    UITableViewCell* pwCell = [[[UITableViewCell alloc] init] autorelease];
//    pwCell.textLabel.text = @"独立密码保护";
//    pwCell.tag = 100;
//    pwCell.accessoryView = [self createSwitch:100];
//    [setCells addObject:pwCell];
    
//    UITableViewCell* publicCell = [[[UITableViewCell alloc] init] autorelease];
//    publicCell.textLabel.text = @"动态更新提醒";
//    publicCell.tag = 101;
//    publicCell.accessoryView = [self createSwitch:101];
//    [setCells addObject:publicCell];
//    
//    UITableViewCell* iWantCell = [[[UITableViewCell alloc] init] autorelease];
//    iWantCell.textLabel.text = @"我有我要提醒";
//    iWantCell.tag = 102;
//    iWantCell.accessoryView = [self createSwitch:102];
//    [setCells addObject:iWantCell];
//    
//    UITableViewCell* openTimeCell = [[[UITableViewCell alloc] init] autorelease];
//    openTimeCell.textLabel.text = @"开放时间提醒";
//    openTimeCell.tag = 103;
//    openTimeCell.accessoryView = [self createSwitch:103];
//    [setCells addObject:openTimeCell];
//    
//    UITableViewCell* companyCell = [[[UITableViewCell alloc] init] autorelease];
//    companyCell.textLabel.text = @"企业动态更新提醒";
//    companyCell.tag = 104;
//    companyCell.accessoryView = [self createSwitch:104];
//    [setCells addObject:companyCell];
}

-(UISwitch*) createSwitch:(int) tag{
    _pws = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    if ([_pws respondsToSelector:@selector(setOnTintColor:)]) {
        [_pws setOnTintColor:[UIColor colorWithRed:0.12 green:0.55 blue:0.89 alpha:1.0]];
    }
    [_pws addTarget:self action:@selector(switchTouch:) forControlEvents:UIControlEventTouchUpInside];
    _pws.tag = tag;
    
    switch (tag) {
        case 100:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"pwProtect"]) {
                [_pws setOn:YES];
            }else{
                [_pws setOn:NO];
            }
            break;
        default:
            break;
    }
    
    return _pws;
}

-(void) savePw:(NSString *)str{
    NSLog(@"==pwS:%@==",str);
    [self accessMSgSet:str status:1];
}

-(void) switchTouch:(UISwitch*) s{
    NSLog(@"++%d++",s.on);
    if (s.on) {
        [[NSUserDefaults standardUserDefaults] setBool:s.on forKey:@"pwProtect"];
        pwViewController* pwVC = [[pwViewController alloc] init];
        pwVC.delegate = self;
        [self.navigationController pushViewController:pwVC animated:YES];
    }else{
        [self accessMSgSet:nil status:0];
    }
}

#pragma mark - tableview

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return setCells.count + 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < (setCells.count + 2 - 1)) {
        return 1;
    }
    return tableCellStrArr.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    if (indexPath.section == 0) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.text = @"消息提醒";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }else{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.text = [tableCellStrArr objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        if (indexPath.row == tableCellStrArr.count - 3) {
            UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(KUIScreenWidth - 80, (cell.bounds.size.height - 20)/2, 30, 18)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont boldSystemFontOfSize:11.0];
            if (upgradeVer <= CURRENT_APP_VERSION) {
                lab.text = @"已是最新版本";
                lab.font = [UIFont systemFontOfSize:14];
                lab.frame = CGRectMake(KUIScreenWidth - 120, (cell.bounds.size.height - 20)/2, 100, 20);
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                lab.backgroundColor = [UIColor clearColor];
                lab.textColor = [UIColor blackColor];
            }else{
                lab.text = @"NEW";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                lab.backgroundColor = [UIColor redColor];;
                lab.textColor = [UIColor whiteColor];
                
                lab.layer.cornerRadius = 2;
                [lab.layer setMasksToBounds:YES];
            }
            
            [cell.contentView addSubview:lab];
            RELEASE_SAFE(lab);
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -- uiatbleviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20.0f;
    }
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *__view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40.0f)];
    [__view setBackgroundColor:[UIColor colorWithRed:232/255.0 green:237/255.0 blue:240/255.0 alpha:1]];
    return __view;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        msgSetViewController* msgSetVC = [[msgSetViewController alloc] init];
        [self.navigationController pushViewController:msgSetVC animated:YES];
        RELEASE_SAFE(msgSetVC);//add vincent
    }else if (indexPath.section == (setCells.count + 2 - 1)) {
        NSString* scoreUrl = [verDic objectForKey:@"scoreUrl"];
        if (scoreUrl == nil || scoreUrl.length == 0) {
            switch (indexPath.row) {
                case 0:
                    //提意见
                {
                    WarmTipsViewController* tipsVC = [[WarmTipsViewController alloc] init];
                    tipsVC.tipsString = @"你好！欢迎留下您的宝贵意见。";
                    tipsVC.ttype = FeedbackTips;
                    [self.navigationController pushViewController:tipsVC animated:YES];
                    RELEASE_SAFE(tipsVC);
                    
                }
                    break;
                case 1:
                    //检查新版本
                {
                    if (upgradeVer > CURRENT_APP_VERSION) {
                        [self checkNewVerson];
                    }else{
                        
                    }
                }
                    break;
                case 2:
                    //关于我们
                {
                    aboutUsViewController* aboutUsVC = [[aboutUsViewController alloc] init];
                    [self.navigationController pushViewController:aboutUsVC animated:YES];
                    RELEASE_SAFE(aboutUsVC);//add vincent
                }
                    break;
                case 3:
                    //服务协议
                {
                    ServiceViewController *serviceVC = [[ServiceViewController alloc]init];
                    [self.navigationController pushViewController:serviceVC animated:YES];
                    RELEASE_SAFE(serviceVC);
                }
                    break;
                default:
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 0:
                    //提意见
                {
                    WarmTipsViewController* tipsVC = [[WarmTipsViewController alloc] init];
                    tipsVC.tipsString = @"你好！欢迎留下您的宝贵意见。";
                    tipsVC.ttype = FeedbackTips;
                    [self.navigationController pushViewController:tipsVC animated:YES];
                    RELEASE_SAFE(tipsVC);
                    
                }
                    break;
                case 1:
                    //鼓励我们
                {
                    [self gradeUs];
                }
                    break;
                case 2:
                    //检查新版本
                {
                    if (upgradeVer > CURRENT_APP_VERSION) {
                        [self checkNewVerson];
                    }else{
                        
                    }
                }
                    break;
                case 3:
                    //关于我们
                {
                    aboutUsViewController* aboutUsVC = [[aboutUsViewController alloc] init];
                    [self.navigationController pushViewController:aboutUsVC animated:YES];
                    RELEASE_SAFE(aboutUsVC);//add vincent
                }
                    break;
                case 4:
                    //服务协议
                {
                    ServiceViewController *serviceVC = [[ServiceViewController alloc]init];
                    [self.navigationController pushViewController:serviceVC animated:YES];
                    RELEASE_SAFE(serviceVC);
 
                }
                    break;
                default:
                    break;
            }
        }
    }
}

//评分响应  跳转
-(void) gradeUs{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[verDic objectForKey:@"scoreUrl"]]];
}

//指示器响应
-(void) showText:(NSString*) text{
    if (progress == nil) {
        progress = [[MBProgressHUD alloc] initWithView:self.view];
        progress.labelText = text;
        progress.mode = MBProgressHUDModeCustomView;
        
    }
    [progress show:YES];
    [self.view addSubview:progress];
}

-(void) dissmiss{
    [progress hide:YES];
    [progress removeFromSuperview];
}

//退出登陆，通知java端
-(void) accessLogOut{
    NSString* reqUrl = @"member/logout.do?param=";
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         [Global sharedGlobal].user_id,@"user_id",
                         [NSNumber numberWithInt:1],@"type",
                         nil];
    [[NetManager sharedManager] accessService:dic data:nil command:MEMBER_LOGOUT_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

//检查新版本
-(void) checkNewVerson{
    [self showText:@"正在检测新版本"];
    [self accessCheckNewVer];
}

//检查新版本请求
-(void) accessCheckNewVer{
    NSString* reqUrl = @"checkversion.do?param=";
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       [NSNumber numberWithInt:1],@"upgrade_ver",
                                       [NSNumber numberWithInt:0],@"platform",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:SET_CHECKNEWVER_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

//设置独立密码请求
-(void) accessMSgSet:(NSString*) pwStr status:(int) status{
    NSString* reqUrl = @"member/setting.do?param=";
    
    NSLog(@"pw:%@",pwStr);
    
    NSMutableDictionary* requestDic = nil;
    
    if (!pwStr) {
        requestDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
         [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
         [NSNumber numberWithInt:6],@"type",
         [NSNumber numberWithInt:status],@"status",
         
         nil];
    }else{
        requestDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                      [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                      [NSNumber numberWithInt:6],@"type",
                      [NSNumber numberWithInt:status],@"status",
                      pwStr,@"password",
                      nil];
    }
    
    [[NetManager sharedManager] accessService:requestDic data:nil command:SET_MSGSET_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
    RELEASE_SAFE(requestDic);//add vincent
}

//网络请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    NSLog(@"==resultArray:%@==",resultArray);
    if (resultArray && ![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        switch (commandid) {
            case MEMBER_LOGOUT_COMMAND_ID:
            {
                //退出
                int ret = [[[resultArray lastObject] objectForKey:@"ret"] intValue];
                if (ret == 1) {
                    [self logoutSend];
                }else{
                    [Common checkProgressHUDShowInAppKeyWindow:@"退出登陆失败" andImage:KAccessFailedIMG];
                }
            }
                break;
            case SET_MSGSET_COMMAND_ID:
            {
                //do something
            }
                break;
            case SET_CHECKNEWVER_COMMAND_ID:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    upgrade_model* upgradeMod = [[upgrade_model alloc] init];
                    NSArray* arr = [upgradeMod getList];
                    [upgradeMod release];
                    
                    NSDictionary* dic = [[resultArray lastObject] objectForKey:@"upgrade"];
                    verDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [dic objectForKey:@"remark"],@"remark",
                              [dic objectForKey:@"url"],@"url",
                              [dic objectForKey:@"ver"],@"ver",
                              [[arr lastObject] objectForKey:@"scoreUrl"],@"scoreUrl",
                              nil];
                    if ([[verDic objectForKey:@"ver"] intValue]) {
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"发现新版本，是否升级？" message:[verDic objectForKey:@"remark"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alert show];
                        [alert release];
                    }else{
                        [Common checkProgressHUD:@"当前已是最新版本" andImage:nil showInView:self.view];
                    }
                    
                });
            }
                break;
            default:
                break;
        }
    }else{
        [Common checkProgressHUD:@"数据异常" andImage:nil showInView:self.view];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dissmiss];
    });
}

#pragma mark - AlterViewDelegate

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self showText:@"正在退出"];
//            [self logoutSend];
            [self accessLogOut];
        }
    }else{
        if (buttonIndex == alertView.cancelButtonIndex) {
            
        }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[verDic objectForKey:@"url"]]];
        }
    }
}

//向IM端发送退出登陆请求 同时直接做退出响应
-(void) logoutSend{
    
    ChatTcpHelper * currentTcpManager = [ChatTcpHelper shareChatTcpHelper];
    
    if ([currentTcpManager.serverSocket isConnected]) {
        [[TcpRequestHelper shareTcpRequestHelperHelper] sendLogoutPackageCommandId:TCP_LOGOUT_COMMAND_ID];
        [self logoutSuccess];
    } else {
        [self logoutSuccess];
    }
}

//退出成功 清除登陆用户数据 设置为不自动登陆
-(void) logoutSuccess{
    [self dissmiss];
    NSLog(@"--logout success--");
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[SidebarViewController share] backToFirstLoginState];
    
    //5.8 chenfeng add
    [Global sharedGlobal].isLogin = NO;
    [Global sharedGlobal].userInfo = nil;
    [Global sharedGlobal].user_id = nil;
    //下次程序启动是否自动登录状态判断
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isAutoLogin"];
    
    //设置默认的账号信息为空
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kPreviousOrgID];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kPreviousUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //删除闪屏根
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                                          NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[[NSUserDefaults standardUserDefaults] stringForKey:@"ScreenImageUrl"]];
    if ([filePath isEqualToString:documentsDirectory]) {
        return;
    }
    [fileManager removeItemAtPath:filePath error:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [progress release];
    [verDic release];
    [_pws release];
    [setCells release];
    [footerStrArr release];
    [tableCellStrArr release];
    [_tableview release];
    [super dealloc];
}

@end
