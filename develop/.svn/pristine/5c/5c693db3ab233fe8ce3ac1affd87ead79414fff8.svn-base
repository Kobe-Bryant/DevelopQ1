//
//  LoginManager.m
//  ql
//
//  Created by LazySnail on 14-6-18.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "LoginManager.h"
#import "SFHFKeychainUtils.h"
#import "whole_users_model.h"
#import "chooseOrg_model.h"
#import "DBOperate.h"
#import "SBJson.h"
#import "ChatTcpHelper.h"
#import "TcpRequestHelper.h"
#import "SidebarViewController.h"
#import "TextData.h"
#import "DataChecker.h"
#import "circle_list_model.h"
#import "login_info_model.h"
#import "userInfo_setting_model.h"
#import "circle_contacts_model.h"
#import "circle_member_list_model.h"
#import "org_member_list_model.h"
#import "org_list_model.h"
#import "toolupdatetime_sider_model.h"
#import "AlertView.h"

#import "AppDelegate.h"

@interface LoginManager () <DataCheckerDelegate>
{
    
}

@end

@implementation LoginManager
{
    BOOL _isAutoLogin;
    AlertView *_alertHud;
}

static id _loginManager;

+ (LoginManager *)shareLoginManager
{
    if (_loginManager == nil) {
        _loginManager = [LoginManager new];
        [[NSNotificationCenter defaultCenter] addObserver:_loginManager selector:@selector(receiveCompelQuitNotify:) name:kNotiCompelQuitMessage object:nil];
    }
    return _loginManager;
}

- (void)loginWithUserName:(NSString *)userName andPassword:(NSString *)passWord
{
    _isAutoLogin = NO;
    // 是否为自动登录判断 用户稍候的是否拉取联系人方法是否调用判断
    [self accessServerForLoginWithName:userName andPassWord:passWord];
}

- (void)autoLogin
{
    // 是否为自动登录判断 用户稍候的是否拉取联系人方法是否调用判断
    _isAutoLogin = YES;
    NSString * userName = [[NSUserDefaults standardUserDefaults]objectForKey:kPreviousUserName];
    NSString * passWrod = [SFHFKeychainUtils getPasswordForUsername:userName andServiceName:SignSecureKey error:nil];
    if (userName != nil && passWrod != nil) {
        [self accessServerForLoginWithName:userName andPassWord:passWrod];
    } else {
        [self loginOut];
        if ([self.delegete respondsToSelector:@selector(loginFailed:)] && self.delegete != nil) {
            [self.delegete loginFailed:self];
        }
    }
    
}

- (void)receiveCompelQuitNotify:(NSNotification *)notify
{
    MessageData * compelQuitMessage = [notify object];
    OriginData * data = compelQuitMessage.msgData;
    NSString * warnStr = nil;
    switch (data.objtype) {
        case dataTypeText:
        {
            TextData * textData = (TextData *)data;
            warnStr = textData.txt;
        }
            break;
            
        default:
            break;
    }
    
    [self loginOut];
    
    //    [Common checkProgressHUD:warnStr andImage:nil showInView:APPKEYWINDOW];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的帐号在其它设备登录，您被迫下线，请重新登录。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    RELEASE_SAFE(alertView);
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [self loginOut];
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

- (void)loginOut
{
    //退出登陆 通知java
    [self accessLogOut];
    
    //不复用主动登陆流程 为了方便
    [[SidebarViewController share] backToFirstLoginState];
    
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

#pragma mark - AccsessSevers

- (void)accessServerForLoginWithName:(NSString *)userName andPassWord:(NSString *)passWord
{
    //获取token号
    NSString* token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_KEY];
    NSString *reqUrl = @"member/login.do?param=";
    //booky 8.11 登陆时将token号传给服务器 用于apns推送
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       userName,@"username",
                                       [Common sha1:passWord],@"password",
                                       [NSNumber numberWithInt:0],@"type",
                                       token,@"token",
                                       nil];
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionaryWithDictionary:requestDic];
    [paramDic setObject:passWord forKey:@"originPassWord"];
    
    [[NetManager sharedManager] accessService:requestDic data:nil command:MEMBER_LOGIN_COMMAND_ID accessAdress:reqUrl delegate:self withParam:paramDic];
}

//用户联系人列表
- (void)accessContactlistService:(int)orgId {
    NSString* reqUrl = @"contactlist.do?param=";
    
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [Global sharedGlobal].user_id,@"user_id",
                                       [NSNumber numberWithInt:0],@"ver",
                                       [NSNumber numberWithInt:0],@"last_req_time",
                                       [NSNumber numberWithLong:0],@"id",
                                       [NSNumber numberWithInt:orgId],@"org_id",
                                       [NSNumber numberWithInt:0],@"circle_ver",
                                       [NSNumber numberWithInt:0],@"org_ver",
                                       [NSNumber numberWithInt:0],@"welcome_ver",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:GROUP_CONTACTLIST_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

//内容跟新通知
- (void)accessContentModifyNotice {
    NSString* reqUrl = @"notify/refresh.do?param=";
    
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [Global sharedGlobal].org_id, @"org_id",
                                       [Global sharedGlobal].user_id,@"user_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:CONTENT_MODIFY_NOTICE_ID accessAdress:reqUrl delegate:self withParam:nil];
}

#pragma mark- HttpDelegate

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver
{
    //add by devin 只是用于登陆时断网情况下提示
    if (resultArray == nil) {
        //add by devin 登陆时，用特定的提示语（不用MB）
        if ([self.delegete respondsToSelector:@selector(LoginConnectFail)]) {
            [self.delegete LoginConnectFail];
        }
        return;
    }
    ParseMethod method = ^{
        switch (commandid) {
            case CONTENT_MODIFY_NOTICE_ID:
            {
                NSDictionary * paramDic = [resultArray lastObject];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"contentModifyNotice" object:paramDic];
            }
            break;
            case MEMBER_LOGIN_COMMAND_ID:
            {
                NSDictionary * param = [resultArray lastObject];
                NSString * userName = [param objectForKey:@"username"];
                NSString * password = [param objectForKey:@"originPassWord"];
                
                // 设置默认用户名
                [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kPreviousUserName];
                NSDictionary * resultDic = [resultArray firstObject];
                [SFHFKeychainUtils storeUsername:userName andPassword:password forServiceName:SignSecureKey updateExisting:YES error:nil];
                
                int ret = [[resultDic objectForKey:@"ret"]intValue];
                
                // 判断结果类型 0 失败 1 成功 2 错误 3 用户已经存在
                if (ret == 0) {
                    if ([self.delegete respondsToSelector:@selector(loginFailed:)] && self.delegete != nil) {
                        [self.delegete loginFailed:self];
                    }
                } else if (ret == 1){
                    //登陆成功时，将应用程序角标数字置0
                    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                    
                    //存储用户ID信息
                    [Global sharedGlobal].user_id = [resultDic objectForKey:@"user_id"];
                    
                    //消息跟新通知
                    [self accessContentModifyNotice];
                    
                    if (!_isAutoLogin)
                    {
                        chooseOrg_model *orgMod = [[chooseOrg_model alloc]init];
                        orgMod.where = nil;
                        // **** 为何删除
                        [orgMod deleteDBdata];
                        
                        NSMutableArray * allOrgIds = [NSMutableArray arrayWithCapacity:5];
                        
                        NSArray *orgArr = [resultDic objectForKey:@"organzations"];
                        for (int i =0; i<orgArr.count; i++) {
                            
                            NSDictionary *orgDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    [[orgArr objectAtIndex:i] objectForKey:@"id"],@"id",
                                                    [[orgArr objectAtIndex:i] objectForKey:@"org_name"],@"org_name",
                                                    [[orgArr objectAtIndex:i] objectForKey:@"cat_pic"],@"cat_pic",
                                                    [[orgArr objectAtIndex:i] objectForKey:@"url"],@"url",
                                                    [[[orgArr objectAtIndex:i] objectForKey:@"welcome"] objectForKey:@"pic"],@"wel_pic",
                                                    [[[orgArr objectAtIndex:i] objectForKey:@"welcome"] objectForKey:@"content"],@"wel_content",
                                                    [[[orgArr objectAtIndex:i] objectForKey:@"welcome"] objectForKey:@"luokuan"],@"wel_luokuan",
                                                    [[[orgArr objectAtIndex:i] objectForKey:@"welcome"] objectForKey:@"btn"],@"wel_btn",
                                                    nil];
                            
                            [allOrgIds addObject:[[orgArr objectAtIndex:i] objectForKey:@"id"]];
                            orgMod.where = [NSString stringWithFormat:@"id = %d",[[[orgArr objectAtIndex:i] objectForKey:@"id"] intValue]];
                            
                            NSMutableArray *dbArray = [orgMod getList];
                            if ([dbArray count] > 0)
                            {
                                [orgMod updateDB:orgDic];
                            }
                            else{
                                [orgMod insertDB:orgDic];
                            }
                            
                        }
                        
                        NSString * userAccountName = [[NSUserDefaults standardUserDefaults]objectForKey:kPreviousUserName];
                        NSString * userOrgJsonStr = [allOrgIds JSONRepresentation];
                        
                        //跟新应用系统数据库 用户快速切换用户
                        NSDictionary * insertWholeUserOrgDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                userAccountName,@"user_account_name",
                                                                userOrgJsonStr,@"all_org_numbers",
                                                                nil];
                        [whole_users_model insertOrUpdataUserInfoWithDic:insertWholeUserOrgDic];
                    } else {
                        
                        //获取上一次登录选择的组织ID 并拉取联系人
                        //主动输入账号密码登陆的流程中获取联系人 在选择组织中处理 后面会同意到这个文件里面来
                        [Global sharedGlobal].org_id = [whole_users_model getPreviousOrgId];
                        [self accessContactlistService:[[whole_users_model getPreviousOrgId] intValue]];
                    }
                    
                    if ([self.delegete respondsToSelector:@selector(loginSuccess:)] && self.delegete != nil) {
                        [self.delegete loginSuccess:self];
                    }
                } else if (ret == 2) {
                    if ([self.delegete respondsToSelector:@selector(loginWithError:)] && self.delegete != nil) {
                        [self.delegete loginWithError:self];
                    }
                } else if (ret == 3) {
                    if ([self.delegete respondsToSelector:@selector(loginFailed:)] && self.delegete != nil) {
                        [self.delegete loginFailed:self];
                    }
                } else if (ret == 4){
                    if ([self.delegete respondsToSelector:@selector(userUnExist:)] && self.delegete != nil) {
                        [self.delegete userUnExist:self];
                    }
                }
                
            }
                break;
            case GROUP_CONTACTLIST_COMMAND_ID:
            {
                /**
                 * 占时不做版本号控制，先将列表删除然后再全部插入
                 */
                if (_isAutoLogin == NO) {
//                    [circle_contacts_model deleteAllListData];
//                    [circle_list_model  deleteAllListData];
//                    [circle_member_list_model deleteAllListData];
                }
                
                [org_list_model deleteAllListData];
                [org_member_list_model deleteAllListData];
                
                NSDictionary * resultDic = [resultArray firstObject];
                if ([resultDic objectForKey:@"userinfo"] != nil) {
                    //更新数据
                    NSDictionary *listDic = [resultDic objectForKey:@"userinfo"];
                    //保存数据
                    NSDictionary *memdic = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [listDic objectForKey:@"id"],@"id",
                                            [listDic objectForKey:@"realname"],@"realname",
                                            [listDic objectForKey:@"portrait"],@"portrait",
                                            [listDic objectForKey:@"role"],@"role",
                                            [listDic objectForKey:@"company_name"],@"company_name",
                                            [listDic objectForKey:@"front_character"],@"front_character",
                                            nil];
                    [login_info_model insertOrUpdataLoginInfoWithDic:memdic];
                    
                    [Global sharedGlobal].userInfo = memdic;
                    [Global sharedGlobal].user_id = [listDic objectForKey:@"id"];
                    
                    //会员提醒设置
                    NSDictionary *userDic = [listDic objectForKey:@"setting"];
                    NSDictionary *settingDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [listDic objectForKey:@"id"],@"id",
                                                [userDic objectForKey:@"msg_alert"],@"msg_alert",
                                                [userDic objectForKey:@"supply_demand_alert"],@"supply_demand_alert",
                                                [userDic objectForKey:@"company_dynamic_alert"],@"company_dynamic_alert",
                                                [userDic objectForKey:@"dynamic_alert"],@"dynamic_alert",
                                                [userDic objectForKey:@"open_time_alert"],@"open_time_alert",
                                                [userDic objectForKey:@"private_password"],@"private_password",
                                                nil];
                    
                    [userInfo_setting_model insertOrUpdateInfoWithDic:settingDic];
                    
                    //圈子列表信息
                    NSArray *userCircleArray = [resultDic objectForKey:@"circles"];
                    for (int i =0; i<userCircleArray.count; i++) {
                        
                        NSDictionary *circledic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [[userCircleArray objectAtIndex:i] objectForKey:@"image_path"],@"image_path",
                                                   [[userCircleArray objectAtIndex:i] objectForKey:@"content"],@"content",
                                                   [[userCircleArray objectAtIndex:i] objectForKey:@"portrait"],@"portrait",
                                                   [[userCircleArray objectAtIndex:i] objectForKey:@"id"],@"circle_id",
                                                   [[userCircleArray objectAtIndex:i] objectForKey:@"front_character"],@"front_character",
                                                   [[userCircleArray objectAtIndex:i] objectForKey:@"user_sum"],@"user_sum",
                                                   [[userCircleArray objectAtIndex:i] objectForKey:@"creater_name"],@"creater_name",
                                                   [[userCircleArray objectAtIndex:i] objectForKey:@"name"],@"name",
                                                   nil];
                        
                        [circle_list_model insertOrUpdateDictionaryIntoCirlceList:circledic];
                    }
                    
                    //联系人列表
                    NSArray *allArr = [resultDic objectForKey:@"contacts"];
                    for (int i =0; i<allArr.count; i++) {
                        NSDictionary *contactDic = [allArr objectAtIndex:i];
                        
                        NSString * portraitStr = [contactDic objectForKey:@"portrait"];
                        
                        if (portraitStr == nil || [portraitStr isEqualToString:@""]) {
                            portraitStr = DEFAULT_MALE_PORTRAIT_NAME;
                        }
                        
                        //组织列表信息
                        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [contactDic objectForKey:@"user_id"],@"user_id",
                                              [contactDic objectForKey:@"realname"],@"realname",
                                              portraitStr,@"portrait",
                                              [contactDic objectForKey:@"company_name"],@"company_name",
                                              [contactDic objectForKey:@"front_character"],@"front_character",
                                              [contactDic objectForKey:@"role"],@"role",
                                              [contactDic objectForKey:@"level"],@"level",
                                              [contactDic objectForKey:@"nickname"],@"nickname",
                                              [contactDic objectForKey:@"sex"],@"sex",
                                              [contactDic objectForKey:@"sub_org_id"],@"sub_org_id",
                                              [contactDic objectForKey:@"status"],@"status",//激活状态
                                              nil];
                        
                        [circle_contacts_model insertOrUpdateContactList:dict];
                        
                        
                        if ([[contactDic objectForKey:@"level"] intValue] == 1) {
                            [Global sharedGlobal].secretInfo = dict;
                        }else  if ([[contactDic objectForKey:@"level"] intValue] == 2) {
                            [Global sharedGlobal].organizationInfo = dict;
                        }
                    }
                    
                    //登陆成功后会员组织信息
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSArray *orgArray = [resultDic objectForKey:@"organizations"];
                        for (int i = 0; i<orgArray.count; i++) {
                            
                            NSDictionary *memOrgdic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       [[orgArray objectAtIndex:i] objectForKey:@"id"],@"id",
                                                       [[orgArray objectAtIndex:i] objectForKey:@"front_character"],@"front_character",
                                                       [[orgArray objectAtIndex:i] objectForKey:@"name"],@"name",
                                                       [[orgArray objectAtIndex:i] objectForKey:@"parent_id"],@"parent_id",
                                                       [[orgArray objectAtIndex:i] objectForKey:@"position"],@"position",
                                                       [[orgArray objectAtIndex:i] objectForKey:@"cat_pic"],@"cat_pic",
                                                       [[orgArray objectAtIndex:i] objectForKey:@"member_count"],@"member_count",
                                                       nil];
                            
                            [org_list_model insertOrUpdateOrgListWithDic:memOrgdic];
                            //跟新组织成员信息
                            DataChecker * cheker = [DataChecker new];
                            cheker.delegate = self;
                            [cheker updateOrgInfoWithOrgID:[[memOrgdic objectForKey:@"id"] longLongValue]];
                        }
                    });
                    
                    [Global sharedGlobal].isLogin = YES;
                    [Global sharedGlobal].user_id = [NSNumber numberWithInt:[[[resultDic objectForKey:@"userinfo"] objectForKey:@"id"] intValue]];
                    
                    NSMutableArray *infoArr = [[NSMutableArray alloc]initWithCapacity:0];
                    [infoArr addObject:[resultDic objectForKey:@"userinfo"]];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateUserInfo" object:infoArr];
                    
                    RELEASE_SAFE(infoArr);
                    //tcp连接服务器 Snail modifiied 5.23
                    BOOL isConnected = [[ChatTcpHelper shareChatTcpHelper]connectToHost];
                    //tcp登录
                    if (isConnected) {
                        [[TcpRequestHelper shareTcpRequestHelperHelper]sendLogingPackageCommandId:TCP_LOGIN_COMMAND_ID];
                    }
                    
                    if (!_isAutoLogin) {
                        //跟新圈子信息。如果自动登陆则不用跟新
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            NSMutableArray * circleArr = [circle_list_model getInstanceList];
                            for (NSDictionary * circleDic in circleArr) {
                                long long circleID = [[circleDic objectForKey:@"circle_id"]longLongValue];
                                DataChecker * checker = [DataChecker new];
                                checker.delegate = self;
                                checker.ifModifyChatList = NO;
                                [checker updateCircleInfoWithID:circleID];
                                
                            }
                        });
                    }
                    
                    [self.delegete accessContactFinished:self];
                }
            }
                break;
            default:
                break;
        }
    };
    [Common securelyparseHttpResultArr:resultArray andMethod:method];
}

- (void)dataCheckerUpdateCircleInfoSuccessWithSender:(DataChecker *)sender andCircleContects:(NSMutableArray *)contacts
{
    RELEASE_SAFE(sender);
}

- (void)dataCheckerUpdateOrganizationInfoSuccessWithSender:(DataChecker *)sender
{
    RELEASE_SAFE(sender);
}

- (void)dealloc
{
    LOG_RELESE_SELF;
    [super dealloc];
}

@end
