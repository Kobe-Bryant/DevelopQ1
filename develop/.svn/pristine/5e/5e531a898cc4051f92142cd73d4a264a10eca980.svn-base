//
//  ChooseOrganizationViewController.m
//  ql
//
//  Created by yunlai on 14-5-22.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "ChooseOrganizationViewController.h"
#import "chooseOrg_model.h"
#import "UIImageView+WebCache.h"
#import "userInfo_setting_model.h"
#import "login_info_model.h"
#import "ChatDataClass.h"
#import "TcpRequestHelper.h"
#import "ThemeManager.h"
#import "whole_users_model.h"
#import "LoginManager.h"
#import "welcomeViewController.h"
#import "YLDataObj.h"
#import "DBOperate.h"

@interface ChooseOrganizationViewController () <LoginManagerDelegate>
{
    UITableView *_orgTableView;
    
    int selectIndex;

}

@property (nonatomic,retain) NSMutableArray *orgArr;
@end

@implementation ChooseOrganizationViewController
@synthesize orgArr = _orgArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _orgArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavBar];
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];

    self.title = @"选择组织";
    
    //获取组织数据并按首字母排序
    [self sortTheOrgWithName];
    
    if (self.orgArr.count == 1) {
        self.view.backgroundColor = [UIColor colorWithRed:45/255.0 green:55/255.0 blue:60/255.0 alpha:1.0];
    }else{
        [self loadMainView];
        
    }
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (self.orgArr.count == 1) {
            //只有一个组织时不显示出来
            _orgTableView.hidden = YES;
            
            [self progressHUD];
            
            selectIndex = 0;
            
            [Global sharedGlobal].org_id = [[self.orgArr objectAtIndex:0] objectForKey:@"id"];
            
            //插入当前选择的组织用户名 用于下次自动登录
            NSString * userAccountName = [[NSUserDefaults standardUserDefaults]objectForKey:kPreviousUserName];
            NSNumber * orgIdNumber = [NSNumber numberWithLongLong:[[[Global sharedGlobal]org_id]longLongValue]];
            NSDictionary * wholeUpdateDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                             userAccountName,@"user_account_name",
                                             orgIdNumber,@"previous_choose_org",
                                             nil];
            [whole_users_model insertOrUpdataUserInfoWithDic:wholeUpdateDic];
            [[NSUserDefaults standardUserDefaults] setObject:[Global sharedGlobal].org_id forKey:kPreviousOrgID];
            
            //创建用户数据库
            if (![[NSFileManager defaultManager]fileExistsAtPath:[FileManager getUserDBPath]]) {
                [DBOperate createUserDB];
            };
            
            NSString* themeName = nil;
            
            themeName = [[self.orgArr objectAtIndex:0] objectForKey:@"org_name"];
            //        themeName = @"默认";
            
            //            NSString* zipUrl = [[self.orgArr objectAtIndex:0] objectForKey:@"url"];
            NSString* zipUrl = @"";
            int org_id = [[[self.orgArr objectAtIndex:0] objectForKey:@"id"] intValue];
            
            //如果主题下载链接没有就读取默认主题
            if ([zipUrl isEqualToString:@""]) {
                themeName = @"默认";
                [self accessContactInfo];
                
            }else{
                //主题包下载
                dispatch_queue_t queue = dispatch_get_global_queue(
                                                                   DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    NSURL *url = [NSURL URLWithString:zipUrl];
                    NSError *error = nil;
                    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
                    
                    if(!error)
                    {
                        //下载路径
//                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//                        booky 8.8
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *path = [paths objectAtIndex:0];
                        NSString *zipPath = [path stringByAppendingPathComponent:@"resources.zip"];
                        
                        [data writeToFile:zipPath options:0 error:&error];
                        
                        if(!error)
                        {
                            ZipArchive *za = [[ZipArchive alloc] init];
                            za.delegate = self;
                            
                            //在内存中解压缩文件
                            if ([za UnzipOpenFile: zipPath]) {
                                //将解压缩的内容写到缓存目录中
                                BOOL ret = [za UnzipFileTo: [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d",themeName,org_id]] overWrite: YES];
                                
                                if (NO == ret){} [za UnzipCloseFile];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    // 更新UI
                                    [[UINavigationBar appearance] setBarTintColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"]];
                                });
                            }
                        }
                        else
                        {
                            NSLog(@"Error saving file %@",error);
                        }
                    }
                    else
                    {
                        NSLog(@"Error downloading zip file: %@", error);
                        
                    }
                    
                });
                
            }
            
            [ThemeManager shareInstance].themesConfig = [self getThemeConfigDic];
            
            if (IOS_VERSION_7) {
                [[UINavigationBar appearance] setBarTintColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"]];
            }
            
            //发送通知
            //    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:themeName];
            
            //保存主题到本地
            [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:kThemeName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    });
    
}

-(void) sortTheOrgWithName{
    chooseOrg_model *orgMod = [[chooseOrg_model alloc]init];
    if (_LoginType) {
        orgMod.where = [NSString stringWithFormat:@"id = %d",[[Global sharedGlobal].org_id intValue]];
    }else{
        orgMod.where = nil;
    }
    NSArray* arr = [orgMod getList];
    RELEASE_SAFE(orgMod);
    
    NSMutableDictionary* dic = [YLDataObj accordingFirstLetterFromOrgs:arr];
    NSArray* keyArr = [dic allKeys];
    
    NSArray* sortKeyArr = [keyArr sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSString* key in sortKeyArr) {
        [self.orgArr addObjectsFromArray:[dic objectForKey:key]];
    }
}

-(void) initNavBar{
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    //    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    backButton.hidden = YES;
    RELEASE_SAFE(backItem);
}

- (void)loadMainView{
    _orgTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight+20) style:UITableViewStylePlain];
    _orgTableView.delegate = self;
    _orgTableView.dataSource = self;
    _orgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _orgTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        _orgTableView.separatorInset = UIEdgeInsetsZero;
    }
    [self.view addSubview:_orgTableView];
    
}

- (void)progressHUD{
    HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
	[[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    HUD.labelText = @"小秘书正在为您准备资料";
	HUD.detailsLabelText = @"请稍等...";
    
    proView = [[UIProgressView alloc] initWithFrame:CGRectMake(100, 100, 140, 50)];
    
    [proView setProgressViewStyle:UIProgressViewStyleDefault]; //设置进度条类型
    
	HUD.customView = proView;
	
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
	
    [HUD show:YES];

    
    proValue=0;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
}

-(void)changeProgress
{
    
    proValue += 0.4;
    
    if(proValue > 3)
    {
        //停用计时器
        [timer invalidate];
        timer = nil;
    }
    else
    {
        [proView setProgress:(proValue / 3)];//重置进度条
    }
}


#pragma mark - ZipArchiveDelegate
//下载主题包完成回调
- (void)zipArchiveSuccess
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:nil];
    if (IOS_VERSION_7) {
        [[UINavigationBar appearance] setBarTintColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"]];
    }
    [self accessContactInfo];
}

#pragma mark- AccessContactInfo
- (void)accessContactInfo
{
//    add vincent
    LoginManager *lmanager = [LoginManager new];
    lmanager.delegete = self;
    [lmanager accessContactlistService:[Global sharedGlobal].org_id.intValue];
 
//    重置密码内存崩溃 泄露 add vincent
//    [[LoginManager shareLoginManager] setDelegete:self];
//    [[LoginManager shareLoginManager] accessContactlistService:[Global sharedGlobal].org_id.intValue];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.orgArr.count!=0) {
        return self.orgArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //下载提示框
    [self progressHUD];
    
    selectIndex = indexPath.row;
    
    [Global sharedGlobal].org_id = [[self.orgArr objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    //插入当前选择的组织id 用于下次自动登录
    NSString * userAccountName = [[NSUserDefaults standardUserDefaults] objectForKey:kPreviousUserName];
    [[NSUserDefaults standardUserDefaults] setObject:[Global sharedGlobal].org_id forKey:kPreviousOrgID];
    
    NSNumber * orgIdNumber = [NSNumber numberWithLongLong:[[[Global sharedGlobal]org_id]longLongValue]];
    NSDictionary * wholeUpdateDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     userAccountName,@"user_account_name",
                                     orgIdNumber,@"previous_choose_org",
                                     nil];
    
    // 存储当前用户选择组织信息并创建相应的数据库
    [whole_users_model insertOrUpdataUserInfoWithDic:wholeUpdateDic];
    
    //创建用户数据库
    if (![[NSFileManager defaultManager]fileExistsAtPath:[FileManager getUserDBPath]]) {
        [DBOperate createUserDB];
    };
    
    NSString *themeName;
    
    int org_id = [[[self.orgArr objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    
    NSString *zipUrl = [[self.orgArr objectAtIndex:indexPath.row] objectForKey:@"url"];
    //如果主题下载链接没有就读取默认主题
    if ([zipUrl isEqualToString:@""]) {
        themeName = @"默认";
        
        [self accessContactInfo];
    }else{
        themeName = [[self.orgArr objectAtIndex:indexPath.row] objectForKey:@"org_name"];
        
        //主题包下载
        dispatch_queue_t queue = dispatch_get_global_queue(
                                                           DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSURL *url = [NSURL URLWithString:zipUrl];
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
            if(!error)
            {
                //下载路径
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *path = [paths objectAtIndex:0];
                NSString *zipPath = [path stringByAppendingPathComponent:@"resources.zip"];
                
                [data writeToFile:zipPath options:0 error:&error];
                
                if(!error)
                {
                    ZipArchive *za = [[ZipArchive alloc] init];
                    za.delegate = self;
                    
                    //在内存中解压缩文件
                    if ([za UnzipOpenFile: zipPath]) {
                        //将解压缩的内容写到缓存目录中
                        BOOL ret = [za UnzipFileTo: [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d",themeName,org_id]] overWrite: YES];
                        
                        if (NO == ret){} [za UnzipCloseFile];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 更新UI
                            if (IOS_VERSION_7) {
                                [[UINavigationBar appearance] setBarTintColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"]];
                            }else{
                                [[UINavigationBar appearance] setTintColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"]];

                            }
                        });
                    }
                }
                else
                {
                    NSLog(@"Error saving file %@",error);
                }
            }
            else
            {
                NSLog(@"Error downloading zip file: %@", error);
                
            }
            
        });
    }
    
//    [ThemeManager shareInstance].themeName = themeName;
    
    [ThemeManager shareInstance].themesConfig = [self getThemeConfigDic];
    
    if (IOS_VERSION_7) {
        [[UINavigationBar appearance] setBarTintColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"]];
    }
    
    //发送通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:themeName];
    
    //保存主题到本地
    [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:kThemeName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSMutableDictionary*) getThemeConfigDic{
    NSMutableDictionary* themeDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    chooseOrg_model* themeMod = [[chooseOrg_model alloc] init];
    
    NSArray* themeArr = [themeMod getList];
    
    for (NSDictionary* dic in themeArr) {
        [themeDic setObject:[NSString stringWithFormat:@"%@%@",[dic objectForKey:@"org_name"],[dic objectForKey:@"id"]] forKey:[dic objectForKey:@"org_name"]];
    }
    [themeMod release];
    
    return themeDic;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"orgCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UIImageView* lineImgV = [[UIImageView alloc] init];
        lineImgV.frame = CGRectMake(0, 134, self.view.bounds.size.width, 1);
        lineImgV.image = IMGREADFILE(@"img_feed_line_gray.png");
        [cell.contentView addSubview:lineImgV];
        RELEASE_SAFE(lineImgV);
    }
//    cell.contentView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *orgImge =  [[UIImageView alloc]init];
    orgImge.frame = CGRectMake(20.f, 15.f, 280.f, 105);
    orgImge.backgroundColor = [UIColor clearColor];
    NSURL *urlImg = [NSURL URLWithString:[[self.orgArr objectAtIndex:indexPath.row] objectForKey:@"cat_pic"]];
    [orgImge setImageWithURL:urlImg placeholderImage:IMGREADFILE(@"img_landing_default220.png")];
    [cell.contentView addSubview:orgImge];
    
    /////--------飞入动画--------//////
    CGFloat rotationAngleDegrees = 0;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    
    CGPoint offsetPositioning;
    if (indexPath.row %2 == 0) {
        offsetPositioning = CGPointMake(-400, -20);
    }else{
        offsetPositioning = CGPointMake(400, -20);
    }
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    
    
    UIView *card = [cell contentView];
    card.layer.transform = transform;
    card.layer.opacity = 0.8;
    
    
    [UIView animateWithDuration:1.f animations:^{
        card.layer.transform = CATransform3DIdentity;
        card.layer.opacity = 1;
    }];
    /////--------飞入动画--------//////
    
    return cell;
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

- (void)getUserIdSave{
    login_info_model *userInfo = [[login_info_model alloc]init];
    NSArray *infoArr = [userInfo getList];
    
    if (infoArr.count !=0) {
        [Global sharedGlobal].user_id = [[infoArr objectAtIndex:0]objectForKey:@"id"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateUserInfo" object:infoArr];
    }
    RELEASE_SAFE(userInfo);
}

#pragma mark - LoginManagerDelegate

- (void)accessContactFinished:(LoginManager *)sender
{
    [HUD hide:YES afterDelay:1.0];
    
    //下次程序启动是否自动登录状态判断
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAutoLogin"];
//    booky
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstIntoApp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self getUserIdSave];
    
    [self configSet];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"defaultSelect" object:nil];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        welcomeViewController* welcomVc = [[welcomeViewController alloc] init];
        welcomVc.orgDataDic = [self.orgArr objectAtIndex:selectIndex];
        [self.navigationController pushViewController:welcomVc animated:NO];
        RELEASE_SAFE(welcomVc);
    });
}

-(void) dealloc{
    RELEASE_SAFE(proView);
    RELEASE_SAFE(HUD);
    RELEASE_SAFE(timer);
    RELEASE_SAFE(_orgArr);
    
    [super dealloc];
}

@end
