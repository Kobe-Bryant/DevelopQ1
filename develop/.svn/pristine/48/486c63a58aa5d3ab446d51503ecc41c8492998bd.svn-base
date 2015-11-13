//
//  LeftSideMainViewController.m
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "LeftSideMainViewController.h"
#import "LeftSideMainViewController.h"
#import "SidebarSelectedDelegate.h"
#import "MemberDetailViewController.h"
#import "MemberInfoViewController.h"
#import "DynamicMainViewController.h"
#import "CircleMainViewController.h"
#import "MeetingMainViewController.h"
#import "TalkingMainViewController.h"
#import "ToolsMainViewController.h"
#import "SettingMainViewController.h"
#import "SessionViewController.h"
#import "CRNavigationController.h"
#import "MessageListViewController.h"
#import "AddressListViewController.h"
#import "MemberMainViewController.h"
#import "UIImageView+WebCache.h"
#import "login_info_model.h"
#import "config.h"
#import <QuartzCore/QuartzCore.h>
#import "chatmsg_list_model.h"
#import "TGLStackedLayout.h"

#import "circle_list_model.h"

#import "SidebarViewController.h"
#import "ThemeManager.h"
#import "Global.h"
#import "AppDelegate.h"
#import "upgrade_model.h"
#import "CircleMajorViewController.h"

#define SetWarnLabTag 9999

@interface LeftSideMainViewController () 
{
    UITableView *_myTableView;
    UIImageView *_moveLineView;
    UIImageView *_headView;
    UILabel *_nameLabel;
    CGFloat topMargin;
    int _selectIdnex;

}
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *imgsArray;

@property (nonatomic, retain) NSString *tool_update_time;//商务助手sider时间更新

@end

@implementation LeftSideMainViewController
@synthesize delegate;
@synthesize myTableView = _myTableView;
@synthesize listArray = __listArray;
@synthesize imgsArray = __imgsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadMarks) name:kNotiUpdateLeftbarMark object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatesHeadView:) name:@"updateHeadImage" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(contentModifyNotice:) name:@"contentModifyNotice" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolsRedPointDisappear) name:@"toolsMainRedPoint" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolsRedPointAppear) name:@"toolsMainRedPointAppear" object:nil];
        
           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redPointDisappear) name:@"toolsMainRedPoint" object:nil];


    }
    return self;
}

- (void) redPointDisappear {
    NSIndexPath * index = [NSIndexPath indexPathForRow:4 inSection:0];
    UITableViewCell * cell = [_myTableView cellForRowAtIndexPath:index];
    UILabel *redPointLab = (UILabel *)[cell viewWithTag:400];
    redPointLab.hidden = YES;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"tool_update_time"];
    [userDefault setObject:self.tool_update_time forKey:@"tool_update_time"];
    [userDefault synchronize];
}

- (void)toolsRedPointAppear{
    //显示红点
    NSIndexPath * index = [NSIndexPath indexPathForRow:4 inSection:0];
    UITableViewCell * cell = [_myTableView cellForRowAtIndexPath:index];
    UILabel *redPointLab = (UILabel *)[cell viewWithTag:400];
    redPointLab.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 44);
    


    __listArray = ARRAYS_TAB_BAR;
    __imgsArray = ARRAYS_TAB_PIC_NAME;
    
    self.view.backgroundColor = COLOR_MENE_BACKVIEW;
    
    [self createMainView];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoLogin"]) {
        if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
            [delegate leftSideBarSelectWithController:[self subConWithIndex:0]];
            _selectIdnex = 0;
            //默认选中表格第一行
            [_myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
        }
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatesUserInfo:) name:@"UpdateUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDynamicNotice:) name:@"dynamicLeftSiderNotice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDynamicMark) name:@"refreshDynamicNotice" object:nil];
    
    //默认选中动态模块通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultSelect:) name:@"defaultSelect" object:nil];
    //改变滑条色
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(circleChangeNotify:) name:@"circleChangeLeftSiderNotice" object:nil];

}

-(void) circleChangeNotify:(NSNotification*) notify{
    NSIndexPath * index = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell * cell = [_myTableView cellForRowAtIndexPath:index];
    UILabel *mark = (UILabel *)[cell viewWithTag:markTag];
   // UILabel *selectMark = (UILabel *)[cell viewWithTag:kselectMarkTag];
    UIImageView *redPointImg = (UIImageView *)[cell viewWithTag:kselectMarkTag];
    
    circle_list_model* circleMod = [[circle_list_model alloc] init];
    circleMod.where = [NSString stringWithFormat:@"unread = 1 and user_sum > 0"];
    if ([circleMod getList].count) {
        mark.hidden = NO;
       // selectMark.hidden = NO;
        redPointImg.hidden = NO;
    }else{
        mark.hidden = YES;
       // selectMark.hidden = YES;
        redPointImg.hidden = YES;
    }
}

-(void) themeNotification:(NSNotification*) notify{
    _moveLineView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
}

-(void) defaultSelect:(NSNotification*) notify{
    int index = 0;
//    booky
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstIntoApp"]) {
        index = 2;
        
        if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
            [delegate leftSideBarSelectWithController:[self subConWithIndex:index]];
            _selectIdnex = index;
            //默认选中表格第一行
            [_myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:0];
        }
        [[SidebarViewController share] moveAnimationWithDirection:SideBarShowDirectionLeft duration:0.15];
    }else{
        index = 0;
        
        if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
            [delegate leftSideBarSelectWithController:[self subConWithIndex:index]];
            _selectIdnex = index;
            //默认选中表格第一行
            [_myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:0];
        }
    }
    
}

/**
 *  主菜单布局UI
 */
- (void)createMainView{
    CGFloat viewHeight = __imgsArray.count * 50.f + 50.f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMyInfo)];

    //头像
    _headView = [[UIImageView alloc]init];
    _headView.frame = CGRectMake(15, 40+[Global judgementIOS7:0], 50, 50);
    _headView.userInteractionEnabled = YES;
    _headView.layer.cornerRadius = 25;
    _headView.layer.borderWidth = 1.5;
    _headView.clipsToBounds = YES;
    _headView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headView.image = IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME);
    
    [_headView addGestureRecognizer:tap];
    [self.view addSubview:_headView];
    [tap release];
    
    //名称
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headView.frame) + 10, 45+[Global judgementIOS7:0], 180, 30)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_nameLabel];
    
    topMargin =  CGRectGetMaxY(_nameLabel.frame) + 30.f;
    
    UILabel * separatorline = [[UILabel alloc]init];
    separatorline.frame = CGRectMake(0, topMargin - 1, KUIScreenWidth, 1);
    separatorline.backgroundColor = [[UIColor alloc]initWithRed:28.0/255.0 green:28.0/255.0 blue:28.0/255.0 alpha:0.6];
    [self.view addSubview:separatorline];
    //菜单
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topMargin, 320, viewHeight) style:UITableViewStylePlain];
    _myTableView.scrollEnabled = NO;
    self.myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1];
    if (IOS_VERSION_7) {
        [_myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_myTableView];
    //移动滑条
    _moveLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topMargin, 3, 60)];
    _moveLineView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    [self.view addSubview:_moveLineView];
    
    //设置
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *warnLab = [[UILabel alloc]init];
    if (IOS_VERSION_7) {
        setBtn.frame = CGRectMake(20, KUIScreenHeight - 30 + 9, 30, 30);
        warnLab.frame = CGRectMake(40, KUIScreenHeight - 42 + 9, 26, 14);
    }else{
        setBtn.frame = CGRectMake(20, KUIScreenHeight - 40, 30, 30);
        warnLab.frame = CGRectMake(40, KUIScreenHeight - 52, 26, 14);
    }
    //从数据库中区出版本号和目前的对比, 提示红点new
    upgrade_model* upgradeMod = [[upgrade_model alloc] init];
    NSArray* arr = [upgradeMod getList];
    [upgradeMod release];
    int upgradeVer = [[[arr firstObject] objectForKey:@"ver"] intValue];
    if (upgradeVer <= CURRENT_APP_VERSION) {
        warnLab.hidden = YES;
    }else{
        warnLab.hidden = NO;
    }
    warnLab.text = @"NEW";
    warnLab.textAlignment = NSTextAlignmentCenter;
    warnLab.font = [UIFont boldSystemFontOfSize:10.0];
    warnLab.textColor = [UIColor whiteColor];
    warnLab.backgroundColor = [UIColor colorWithRed:223/255.0 green:53/255.0 blue:47/255.0 alpha:1];
    warnLab.layer.cornerRadius = 2.0;
    warnLab.tag = SetWarnLabTag;
    warnLab.layer.masksToBounds = YES;
    [self.view addSubview:warnLab];
    [warnLab release];//booky 8.26
    
    [setBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setImage:IMGREADFILE(@"ico_home_set.png") forState:UIControlStateNormal];
    [self.view addSubview:setBtn];
    
    RELEASE_SAFE(separatorline);
}

// 更换头像
- (void)updatesHeadView:(NSNotification *)note{
    
    _headView.image = note.object;
}

// 菜单动态提醒
- (void)newDynamicNotice:(NSNotification*) notify{
  
    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell * cell = [_myTableView cellForRowAtIndexPath:index];
    UILabel *mark = (UILabel *)[cell viewWithTag:markTag];
   // UILabel *selectMark = (UILabel *)[cell viewWithTag:kselectMarkTag];
    UIImageView *redPointImg = (UIImageView *)[cell viewWithTag:kselectMarkTag];
    
    mark.hidden = NO;
   // selectMark.hidden = NO;
    redPointImg.hidden = NO;
}

- (void)refreshDynamicMark{
    
    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell * cell = [_myTableView cellForRowAtIndexPath:index];
    UILabel *mark = (UILabel *)[cell viewWithTag:markTag];
   // UILabel *selectMark = (UILabel *)[cell viewWithTag:kselectMarkTag];
    UIImageView *redPointImg = (UIImageView *)[cell viewWithTag:kselectMarkTag];
    
    if ([Global sharedGlobal].dyMe_unread_num == 0 && [Global sharedGlobal].newDynamicNum == 0) {
        mark.hidden = YES;
       // selectMark.hidden = YES;
        redPointImg.hidden = YES;
    }
}

// 更新信息
- (void)updatesUserInfo:(NSNotification *)note {
    if (note.object) {
        NSDictionary *userDic = [note.object objectAtIndex:0];
        
        if (userDic) {
      
            NSURL *imgUrl = [NSURL URLWithString:[userDic objectForKey:@"portrait"]];
            if ([[userDic objectForKey:@"sex"] intValue] == 1) {
                [_headView setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME)];

            }else{
                [_headView setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];

            }
            _nameLabel.text = [userDic objectForKey:@"realname"];
            
        }
    }
    
}

- (void)contentModifyNotice:(NSNotification *)note{
    if (note.object) {
        NSDictionary *userDic = note.object;
        
        if (userDic) {
            if ([[userDic objectForKey:@"rcode"] intValue]== 1) {
                NSInteger user_detail_is_new = [[userDic objectForKey:@"user_detail_is_new"] integerValue];//云主页 0表示没有更新 1表示有更新
                self.tool_update_time = [[userDic objectForKey:@"tool_update_time"] stringValue];//商务助手更新时间
                
                //云主页红点提示
                [self cloudPageRedPoint:user_detail_is_new];
                
                //商务助手红点提示
                [self toolsRedPoint:self.tool_update_time];
              }
            }
    }
}

- (void)cloudPageRedPoint:(NSInteger)value{
    NSIndexPath * index = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell * cell = [_myTableView cellForRowAtIndexPath:index];
    UIImageView *redPointImg = (UIImageView *)[cell viewWithTag:kselectMarkTag];
    if (value == 1) {
        redPointImg.frame = CGRectMake(25 + 95.f, 25, 12, 12);
        redPointImg.hidden = NO;
    }else {
        redPointImg.hidden = YES;
    }
}

- (void)toolsRedPoint:(NSString *)value {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSIndexPath * index = [NSIndexPath indexPathForRow:4 inSection:0];
    UITableViewCell * cell = [_myTableView cellForRowAtIndexPath:index];
    UILabel *redPointLab = (UILabel *)[cell viewWithTag:400];
    
    //判断与上次时间是否一致，一致则没更新，不显示红点
    if ([value isEqualToString:[userDefault objectForKey:@"tool_update_time"]]) {
        //没有红点
        redPointLab.hidden = YES;
    }else {
        //显示红点
        redPointLab.hidden = NO;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.listArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60.f;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

        cell.backgroundColor = [UIColor clearColor];

        UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectZero];
        picView.backgroundColor = [UIColor clearColor];
        picView.tag = 100;
        [cell.contentView addSubview:picView];
        [picView release];
        
        UILabel *appTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        appTitle.backgroundColor = [UIColor clearColor];
        appTitle.tag = 101;
        appTitle.font = [UIFont systemFontOfSize:16];
        appTitle.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:appTitle];

        [appTitle release];
    }
    
    UIImageView *picView = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:101];
    
    picView.frame = CGRectMake(20, 15, 30, 30);
    title.frame = CGRectMake(CGRectGetMaxX(picView.frame) + 15, 20, 150, 20);

    title.text = [self.listArray objectAtIndex:indexPath.row];
    picView.image = [UIImage imageNamed:[self.imgsArray objectAtIndex:indexPath.row]];
    
    // add by devin 红点提示（用图片代替Lable 解决ios6会出现红点不出现的问题）
    UIImageView *redPointImg = [[UIImageView alloc]init];
    redPointImg.frame = CGRectMake(10 + 95.f, 23, 15, 15);
    redPointImg.image = [UIImage imageNamed:@"ico_common_remind.png"];
    redPointImg.hidden = YES;
    redPointImg.tag = kselectMarkTag;
    [cell addSubview:redPointImg];
    
    UILabel * _markLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    _markLabel.backgroundColor = [UIColor colorWithRed:223/255.0 green:53/255.0 blue:47/255.0 alpha:1];
    _markLabel.layer.cornerRadius = 7.5;
    _markLabel.clipsToBounds = YES;
    _markLabel.textAlignment = NSTextAlignmentCenter;
    _markLabel.textColor = [UIColor whiteColor];
    _markLabel.font = KQLboldSystemFont(10);
    _markLabel.hidden = YES;
    _markLabel.tag = markTag;
    [redPointImg addSubview:_markLabel];
    
    UILabel *toolsWarnLab = [[UILabel alloc]init];
    toolsWarnLab.frame = CGRectMake(40 + 95.f, 23, 26, 14);
    toolsWarnLab.text = @"NEW";
    toolsWarnLab.textAlignment = NSTextAlignmentCenter;
    toolsWarnLab.font = [UIFont boldSystemFontOfSize:10.0];
    toolsWarnLab.textColor = [UIColor whiteColor];
    toolsWarnLab.backgroundColor = [UIColor colorWithRed:223/255.0 green:53/255.0 blue:47/255.0 alpha:1];
    toolsWarnLab.tag = 400;
    toolsWarnLab.hidden = YES;
    toolsWarnLab.layer.cornerRadius = 2.0;
    toolsWarnLab.layer.masksToBounds = YES;
    [cell addSubview:toolsWarnLab];
    
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = COLOR_MENE_SELECTED;
    
    //动态
    if (indexPath.row == 0) {
        if ([Global sharedGlobal].dyMe_unread_num == 0 && [Global sharedGlobal].newDynamicNum == 0) {
            _markLabel.hidden = YES;
            redPointImg.hidden = YES;
            
        }else{
            _markLabel.hidden = NO;
            redPointImg.hidden = NO;
        }
    }
    //圈子
//    if (indexPath.row == 2) {
//        _markLabel.hidden = YES;
//        redPointImg.hidden = YES;
//    }

    RELEASE_SAFE(_markLabel);
    RELEASE_SAFE(redPointImg);
    RELEASE_SAFE(toolsWarnLab);
    
    if (IOS_VERSION_7) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self changeTypeView:indexPath.row];
    
    [self loadMarks];
    
    if (indexPath.row == 3) {
        [self cloudRedPointDisappear]; //云主页红点提示消失
    }
    if (indexPath.row == 4) {
       // [self toolsRedPointDisappear]; //点击cell时，保存更新时间字段，以便和下一次最新时间对比
    }
    
}

-(void) changeToFirst{
    
//    [delegate leftSideBarSelectWithController:[self subConWithIndex:0]]; //退出以后还需要进入动态页面进行加载一下为啥 。。。。add vincent
    
    _selectIdnex = 0;
    //默认选中表格第一行
    [_myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
}

#pragma mark --- methods
-(void)changeTypeView:(int)_index{
    int nowIndex = _index;
    
    if (nowIndex == _selectIdnex) {
        [delegate leftSideBarSelectWithController:nil];
    }else
    {
        [delegate leftSideBarSelectWithController:[self subConWithIndex:nowIndex]];
        _selectIdnex = nowIndex;
    }
}

- (UINavigationController *)subConWithIndex:(int)index
{
    _moveLineView.frame = CGRectMake(0, topMargin + 60*index, 3, 60);

    CRNavigationController *nav = nil;
    
    if (index == 0 ) {
        DynamicMainViewController* dynamicMainVC = [[DynamicMainViewController alloc] init];
        nav= [[CRNavigationController alloc] initWithRootViewController:dynamicMainVC];
        RELEASE_SAFE(dynamicMainVC);
    }else if(index == 1) {
        
        MessageListViewController *sessionMainView = [[MessageListViewController  alloc] init];
        nav= [[CRNavigationController alloc] initWithRootViewController:sessionMainView];
        [sessionMainView release];
        
    }else if(index == 2) {
        //        CircleMainViewController *addresslistMainView = [[CircleMainViewController  alloc] init];
        //        addresslistMainView.backStyle = kBackStyleNormal;
        //        nav= [[CRNavigationController alloc] initWithRootViewController:addresslistMainView];
        //        [addresslistMainView release];
        CircleMajorViewController *addresslistMainView = [[CircleMajorViewController  alloc] init];
        addresslistMainView.backStyle = kBackStyleNormal;
        nav= [[CRNavigationController alloc] initWithRootViewController:addresslistMainView];
        [addresslistMainView release];
        
    }else if(index == 3) {
        MemberMainViewController *memberMainView = [[MemberMainViewController  alloc] init];
        memberMainView.pushType = PushTypesLeft;
        memberMainView.accessType = AccessTypeSelf;
        nav= [[CRNavigationController alloc] initWithRootViewController:memberMainView];
        [memberMainView release];
        
    }else if(index == 4) {
        ToolsMainViewController *toolsMainView = [[ToolsMainViewController  alloc] init];
        nav= [[CRNavigationController alloc] initWithRootViewController:toolsMainView];
        [toolsMainView release];
        
    }
    nav.navigationBar.opaque = NO;
    nav.navigationBar.hidden = NO;
    
    return [nav autorelease];
}

/**
 *  设置
 */
- (void)setClick{

    UILabel* lab = (UILabel*)[self.view viewWithTag:SetWarnLabTag];
    lab.hidden = YES;
    
    SettingMainViewController *settingMainView = [[SettingMainViewController  alloc] init];
    UINavigationController *navSet = [[UINavigationController alloc] initWithRootViewController:settingMainView];
    navSet.modalPresentationStyle = UIModalPresentationCurrentContext;
    navSet.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [navSet.navigationBar setBarStyle:UIBarStyleBlack];
    
    [self.navigationController presentViewController:navSet animated:YES completion:nil];
    
    [settingMainView release];
    RELEASE_SAFE(navSet);
}
/**
 *  个人主页
 */
- (void)showMyInfo{
    MemberMainViewController  *userInforMainView = [[MemberMainViewController  alloc] init];
    userInforMainView.accessType = AccessTypeSelf;
    CRNavigationController *nav = [[CRNavigationController alloc] initWithRootViewController:userInforMainView];
    
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [nav.navigationBar setBarStyle:UIBarStyleBlack];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    RELEASE_SAFE(userInforMainView);
    RELEASE_SAFE(nav);
}

#pragma mark - MessageReceiveNotification

- (void)loadMarks{
    chatmsg_list_model * clistGeter = [[chatmsg_list_model alloc]init];
    NSArray *list = [clistGeter getList];
    NSIndexPath * index = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell * cell = [_myTableView cellForRowAtIndexPath:index];
    UILabel *mark = (UILabel *)[cell viewWithTag:markTag];
    UIImageView *redPointImg = (UIImageView *)[cell viewWithTag:kselectMarkTag];
    
    int unreadSum = 0;
    for (NSDictionary *dic in list) {
        unreadSum += [[dic objectForKey:@"unreaded"]intValue];
    }
    RELEASE_SAFE(clistGeter);
    
    //目前为止 只做到了消息的Cell 可以有提醒功能
    if (unreadSum > 0) {
        mark.hidden = NO;
        redPointImg.hidden = NO;
    } else {
        mark.hidden = YES;
        redPointImg.hidden = YES;
    }
    NSString * markStr = [NSString stringWithFormat:@"%d",unreadSum>99?99:unreadSum];
    mark.text = markStr;
    NSLog(@" mark text = %@",mark.text);
}

- (void)cloudRedPointDisappear {
    NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell *cell = [_myTableView cellForRowAtIndexPath:index];
    UIImageView *redPointImg = (UIImageView *)[cell viewWithTag:kselectMarkTag];
    redPointImg.hidden = YES;
}

- (void)toolsRedPointDisappear{
    NSIndexPath * index = [NSIndexPath indexPathForRow:4 inSection:0];
    UITableViewCell * cell = [_myTableView cellForRowAtIndexPath:index];
    UILabel *redPointLab = (UILabel *)[cell viewWithTag:400];
    redPointLab.hidden = YES;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"tool_update_time"];
    [userDefault setObject:self.tool_update_time forKey:@"tool_update_time"];
    [userDefault synchronize];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_myTableView release];
    [__listArray release];
    [__imgsArray release];
    [_moveLineView release];
    [_headView release];
    [_nameLabel release];
    [super dealloc];
}

@end