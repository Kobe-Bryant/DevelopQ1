//
//  MemberMainViewController.m
//  ql
//
//  Created by yunlai on 14-4-14.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "MemberMainViewController.h"
#import "SidebarViewController.h"
#import "MemberInfoViewController.h"
#import "GuestMainPageViewController.h"
#import "LikesMainPageViewController.h"
#import "DynamicMainViewController.h"
#import "login_info_model.h"
#import "mainpage_userInfo_model.h"
#import "mainpage_supplydemand_model.h"
#import "mainpage_company_model.h"
#import "mianpage_company_dynamic_model.h"
#import "mainpage_newpublish_model.h"
#import "mainpage_openeduser_model.h"
#import "SessionViewController.h"
#import "CRNavigationController.h"
#import "MemberTopView.h"
#import "companyInfoCell.h"
#import "userInfoCell.h"
#import "personCell.h"
#import "Global.h"
#import "myCompanyCell.h"
#import "UIImageView+WebCache.h"

#import "browserViewController.h"

#import "MemberDynamicViewController.h"
#import "MemberWantHaveViewController.h"

#import "config.h"
#import "ThemeManager.h"
#import "NetManager.h"
#import "SubCollectionsCell.h"
#import "EnterMoreLiveAppView.h"
#import "companyInfoBrowserViewController.h"
#import "liveapp_companyInfo_model.h"

#import "org_member_list_model.h"

@interface MemberMainViewController ()
{
//    按钮切换部件
    UIView *segmentBg;
    UIView *slipV;
//    顶部和内容
    UIView *topViewBg;
    UIView *contentView;
//    当前按钮tag值
    int currentButtonTag;
    CGFloat fixHeight;
    int lastContentOffsetY;
    BOOL isAnimation;
//    用户信息列表视图和公司信息列表视图
    UITableView *_userInfoTableView;
    UITableView *_companyTableView;
    
    UILabel *userName;
    UIView *navigationBarV;
    
    CGFloat versionH;
    CGFloat topPadding;
//    顶部视图
    MemberTopView *topView;
    
    NSInteger is_new_vistor; //判断是否是新访客 1代表有 0 没有
    NSInteger is_new_care; //判断是否是点赞 1代表有 0 没有
    
    MBProgressHUD* mbProgressHUD;
}

@property (nonatomic ,retain) UITableView *userInfoTableView;
@property (nonatomic ,retain) UITableView *companyTableView;
@property (nonatomic ,retain) NSMutableArray *myCompanyArr;//公司信息数据
@property (nonatomic ,retain) NSMutableArray *myDynamicArr;//个人动态数据
@property (nonatomic ,retain) NSMutableArray *userArr;//用户数据
@property (nonatomic ,retain) NSMutableArray *supplyArr;//我有我要数据
@property (nonatomic ,retain) NSMutableArray *publishArr;//发布动态数据
@property (nonatomic ,retain) NSMutableArray *otherAllInfoArr;//他人主页数据
@property (nonatomic ,retain) NSMutableArray *openedUserArr;//开通了企业介绍

@end

@implementation MemberMainViewController
@synthesize pushType,lookId,accessType,navigationBarType;
@synthesize userInfoTableView = _userInfoTableView;
@synthesize companyTableView = _companyTableView;
@synthesize myCompanyArr = _myCompanyArr;
@synthesize myDynamicArr = _myDynamicArr;
@synthesize otherAllInfoArr = _otherAllInfoArr;
@synthesize openedUserArr = _openedUserArr;
@synthesize userArr,supplyArr,publishArr,destinationId,userInfoDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationBarType = NavigationBarHidden; //默认导航条是隐藏的 add by devin
    }
    return self;
}

//隐藏导航 读取最新数据 更新UI
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self readSqlData];
    if (_userInfoTableView) {
        
        [_userInfoTableView reloadData];
    }
    
    if (_companyTableView) {
        [_companyTableView reloadData];
    }
    
    if (topView) {
        [topView writeDataInfo:self.userArr];
    }
}

//显示导航
- (void)viewWillDisappear:(BOOL)animated {
    if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    
    if (self.accessType == AccessTypeSearchLook) {
        self.view.bounds = CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight);
    }else if(self.accessType == AccessTypeCircleLook){
        self.view.bounds = CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IOS_VERSION_7) {
        versionH = 64.f;
        topPadding = 20.f;
    }else{
        versionH = 44.f;
        topPadding = 0.f;
    }
    
//    有缓存数据就读本地数据，没有就请求网络
    if (self.userArr.count!=0) {
        //读取本地数据
        [topView writeDataInfo:self.userArr];
        
    }else{
        if (self.accessType == AccessTypeSelf) {
            self.lookId = 0;
        }
        
        //网络请求
        [self accessUserInfoService:self.accessType];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:237/255.0 blue:241/255.0 alpha:1.f];
//主视图布局
    [self mainLayoutView];
//    默认展示个人信息页
    [self showPersonInfo];
//    初始化导航
    [self initNavBar];
    
    if (self.accessType == AccessTypeSearchLook) {
        self.view.bounds = CGRectMake(0.f, 0, KUIScreenWidth, KUIScreenHeight);
    }
    
    //返回按钮 自己的主页和他人的主页按钮图片不一致
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    
    [backButton setBackgroundColor:[UIColor clearColor]];
    
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage* image = nil;
    if (self.accessType == AccessTypeSelf) {
        image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_header.png"];
    }else{
        image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    }
//    添加编辑资料按钮或者是个人资料按钮
    [self initUserInfoBtn];
    
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(20 , 30, 44.f, 44.f)];
    if (IOS_VERSION_7) {
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    }
    
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    RELEASE_SAFE(backItem);
}

//添加切换到个人资料页的按钮
-(void) initUserInfoBtn{
//    if (self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
//        return;
//    }
    
    UIButton* userInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.accessType == AccessTypeSelf) {
        [userInfoBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
    }else{
        [userInfoBtn setTitle:@"个人资料" forState:UIControlStateNormal];
    }
    userInfoBtn.backgroundColor = [UIColor clearColor];
    [userInfoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [userInfoBtn addTarget:self action:@selector(turnToUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    userInfoBtn.titleLabel.font = KQLboldSystemFont(15);
    if (IOS_VERSION_7) {
        userInfoBtn.frame = CGRectMake(KUIScreenWidth - 80, 25, 60, 30);
    }else{
        userInfoBtn.frame = CGRectMake(KUIScreenWidth - 80, 5, 60, 30);

    }
    [self.view addSubview:userInfoBtn];
    
}

// 读取数据 用户数据、动态数据、公司数据、供需数据
- (void)readSqlData{
    
    if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
        
        mainpage_userInfo_model *userMod = [[mainpage_userInfo_model alloc]init];
        self.userArr = [userMod getList];
        
        mainpage_company_model *companyMod = [[mainpage_company_model alloc]init];
        self.myCompanyArr = [companyMod getList];
        
        mainpage_supplydemand_model *supplyMod = [[mainpage_supplydemand_model alloc]init];
        supplyMod.orderBy = @"created";
        supplyMod.orderType = @"desc";
        self.supplyArr = [supplyMod getList];
        
        mainpage_newpublish_model *pubMod = [[mainpage_newpublish_model alloc]init];
        pubMod.orderBy = @"created";
        pubMod.orderType = @"desc";
        self.publishArr = [pubMod getList];
        
        mianpage_company_dynamic_model *dynaMod = [[mianpage_company_dynamic_model alloc]init];
        dynaMod.orderBy = @"created";
        dynaMod.orderType = @"desc";
        self.myDynamicArr = [dynaMod getList];
        
        mainpage_openeduser_model *openeduserMod = [[mainpage_openeduser_model alloc]init];
        self.openedUserArr = [openeduserMod getList];
        
        RELEASE_SAFE(userMod);
        RELEASE_SAFE(dynaMod);
        RELEASE_SAFE(companyMod);
        RELEASE_SAFE(supplyMod);
        RELEASE_SAFE(pubMod);
        RELEASE_SAFE(openeduserMod);
    }else{
        self.title = @"云主页";
    }
}

// 发信息聊天按钮
- (void)initSendInfoView{
    
    if (!self.isSessionInter) {
    
//        分割线 add vincent
        int heightl;
        if (IOS_VERSION_7) {
            heightl = 30.f;
        }else{
            heightl = 50.f;
        }
        
        UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, KUIScreenHeight - heightl - 1, KUIScreenWidth, 1)];
        spView.backgroundColor = COLOR_LINE;
        [self.view addSubview:spView];
        RELEASE_SAFE(spView);
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setFrame:CGRectMake(0.f, KUIScreenHeight - heightl, KUIScreenWidth, 50.f)];
//        add vincent
        [sendBtn setImage:[[ThemeManager shareInstance] getThemeImage:@"ico_common_chat62.png"] forState:UIControlStateNormal];
        [sendBtn setTitle:@"发个信息" forState:UIControlStateNormal];
        [sendBtn setTitleColor:COLOR_CONTROL forState:UIControlStateNormal];
        sendBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        [sendBtn setBackgroundColor:[UIColor whiteColor]];
        [sendBtn addTarget:self action:@selector(sendInfoClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sendBtn];
        
    }
}

#pragma mark - 聊天
// 聊天
- (void)sendInfoClick:(UIButton *)button{
    
   // [button setTitleColor:COLOR_CONTROL forState:UIControlStateNormal];
    
    DLog(@"%@",[[self.otherAllInfoArr lastObject] objectForKey:@"userinfo"]);
    
    self.userInfoDic = [[self.otherAllInfoArr lastObject] objectForKey:@"userinfo"];
    
    NSArray *portraitArr = [NSArray arrayWithObject:[self.userInfoDic objectForKey:@"portrait"]];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
   
    NSDictionary *msgDic = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"",@"message",
                            [NSNumber numberWithInt:0],@"messageSum",
                            [self.userInfoDic objectForKey:@"realname"],@"name",
                            portraitArr,@"portrait",
                            [self.userInfoDic objectForKey:@"id"],@"sender_id",
                            timeSp,@"time",
                            [NSNumber numberWithInt:MessageListTypePerson],@"talk_type",
                            nil];
    
    SessionViewController *selectMenberController = [[SessionViewController  alloc] init];
    selectMenberController.selectedDic = msgDic;
    selectMenberController.isCloudPagePresent = YES;
    
    CRNavigationController * sessionNav = [[CRNavigationController alloc]initWithRootViewController:selectMenberController];
    
    
    [self presentModalViewController:sessionNav animated:YES];
    RELEASE_SAFE(selectMenberController);
    RELEASE_SAFE(sessionNav);
}

// 实例导航栏按钮
- (void)initNavBar{

    navigationBarV = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, versionH)];
    navigationBarV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navigationBarV];
    
    
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIImage* image = nil;
    if (self.accessType == AccessTypeSelf) {
        image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_header.png"];
    }else{
        image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    }
    
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10.f, topPadding, 44.f, 44.f);
    
    [navigationBarV addSubview:backButton];
    
    userName = [[UILabel alloc]initWithFrame:CGRectMake(110.f, topPadding + 5.f, 100.f, 30.f)];
    
    if (userArr.count > 0) {
        userName.text = [[userArr objectAtIndex:0]objectForKey:@"realname"];
    }
    
    userName.textColor = [UIColor whiteColor];
    userName.backgroundColor = [UIColor clearColor];
    userName.font = KQLboldSystemFont(17);
    userName.textAlignment = NSTextAlignmentCenter;
     //add by devin   如果导航条隐藏则不显示字，出现再显示
    if (self.navigationBarType == NavigationBarHidden) {
        userName.hidden = YES;
    }else {
        userName.hidden = NO;
    }
    
    [navigationBarV addSubview:userName];
    
}

// 主界面布局
- (void)mainLayoutView{
    
    topView = [[MemberTopView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 260.f) userInfoArr:userArr delegate:self];

    
    topViewBg  = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 265.f)];
    contentView = [[UIView alloc] initWithFrame:CGRectMake(5.0f , 265.0f , KUIScreenWidth - 10.f, KUIScreenHeight - 260.0f)];
    
    // 分割线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(5.f, 264.0f, KUIScreenWidth - 10, 1.0f)];
    line.backgroundColor = COLOR_LINE;
    [contentView addSubview:line];
    RELEASE_SAFE(line);
    
	topView.tag = 1000;

	contentView.backgroundColor = [UIColor grayColor];
	contentView.tag = 2000;
	
	[self.view addSubview:topViewBg];
	[self.view addSubview:contentView];
    [topViewBg addSubview:topView];
    
    //添加切换按钮
   
    segmentBg = [[UIView alloc] initWithFrame:CGRectZero];
    
    segmentBg.frame = CGRectMake(0.0f, 220.0f, KUIScreenWidth, 44.0f);
    
    
    segmentBg.backgroundColor = [UIColor colorWithRed:232/255.0 green:237/255.0 blue:241/255.0 alpha:1.f];
    [topView addSubview:segmentBg];
    
	//添加按钮
	NSArray *buttonTitle = [[NSArray alloc]initWithObjects:@"个人信息",@"公司信息",nil];
	float buttonX = 5.0f;
	float buttonWidth = (topView.frame.size.width - 10) / 2;
	float buttonHeight = 40.0f;
	int bTag = 1001;
	for (NSString *bTitleInfo in buttonTitle)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setFrame:CGRectMake(buttonX, 4.0f, buttonWidth, buttonHeight)];
        [button setTitle:bTitleInfo forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
		buttonX += buttonWidth;
		button.tag = ++bTag;
		button.titleLabel.font = KQLSystemFont(14);
		button.backgroundColor = kColorRGB(160, 160, 160, 0.6);
        if (button.tag == 1002) {
            button.backgroundColor = RGBACOLOR(243, 152, 0, 1);
        }
		[segmentBg addSubview:button];
	}
    
	slipV = [[UIView alloc]initWithFrame:CGRectMake(155.f, 42.5f, 155, 1.5f)];
    slipV.backgroundColor = RGBACOLOR(243, 152, 0, 1);
	[segmentBg addSubview:slipV];
	
    if (self.accessType == AccessTypeLookOther ||self.accessType == AccessTypeSearchLook || self.accessType == AccessTypeCircleLook) {
        if (self.lookId != [[Global sharedGlobal].user_id intValue]) {
            
            //没激活的用户和没有邀请的用户，没有发消息按钮
            NSDictionary* userDic = [org_member_list_model getUserInfoWith:self.lookId];
            
            int status = [[userDic objectForKey:@"status"] intValue];
            int invite_status = [[userDic objectForKey:@"invite_status"] intValue];
            if (status && invite_status) {
                [self initSendInfoView];
            }
        }
    }
}

// 返回
- (void)backTo{
    if (self.accessType == AccessTypeSelf) {
        
        if (self.pushType == PushTypesButtom) {
            [self dismissViewControllerAnimated:YES completion:^{}];
        }else{
            if (![[SidebarViewController share]sideBarShowing]) {
                [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionLeft duration:0.15];
            }else{
                [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionNone duration:0.15];
            }
        }
    }else{
        if (self.pushType == PushTypesButtom) {
            
            [self dismissViewControllerAnimated:YES completion:^{}];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
   
}

// 分享(暂没用到)
- (void)shareTo{
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享给联系人" otherButtonTitles:nil, nil];
    [shareSheet showInView:self.view];
    
    RELEASE_SAFE(shareSheet);
}

// 切换按钮
-(void)buttonClick:(id)sender
{
   // userName.hidden = NO;

	UIImageView *currentImage = (UIImageView *)[segmentBg viewWithTag:1005];
    
	CGRect currentImageFrame = currentImage.frame;
    CGRect topViewFrame = topViewBg.frame;
    CGRect contentViewFrame = contentView.frame;
    
	UIButton *currentButton = sender;
    
	switch (currentButton.tag)
	{
		case 1002:
		{
            currentButtonTag = 1002;
      
            currentButton.backgroundColor =  RGBACOLOR(243, 152, 0, 1);
           
            UIButton *btn = (UIButton *)[segmentBg viewWithTag:1003];
            btn.backgroundColor = kColorRGB(160, 160, 160, 0.6);
            
			currentImageFrame.origin.x = 0.0f;
            topViewFrame.origin.y = -220.f + versionH;
            contentViewFrame.origin.y = 44.0f + versionH;
            contentViewFrame.size.height = self.view.frame.size.height - 40.0f;
//            启用动画
			[self animationsSet];
//            滑条切换
            slipV.frame = CGRectMake(155.f, 42.5f, 155, 1.5f);
            slipV.backgroundColor = RGBACOLOR(243, 152, 0, 1);
            
			[UIView commitAnimations];
            
            [self showPersonInfo];

			break;
		}
		case 1003:
		{
            currentButtonTag = 1003;
            currentButton.backgroundColor = COLOR_CONTROL;
            UIButton *btn = (UIButton *)[segmentBg viewWithTag:1002];
            btn.backgroundColor = kColorRGB(160, 160, 160, 0.6);
            
			currentImageFrame.origin.x = self.view.frame.size.width / 2;
            topViewFrame.origin.y = -220.0f + versionH;
            contentViewFrame.origin.y = 44.0f + versionH;
            contentViewFrame.size.height = KUIScreenHeight;
            CGRect myTableViewFrame = contentViewFrame;
            myTableViewFrame.origin.y = 0.0f;

			[self animationsSet];
			
            slipV.frame = CGRectMake(5.f, 42.5f, 155.f, 1.5f);
            slipV.backgroundColor = COLOR_CONTROL;
            
			[UIView commitAnimations];
			
			[self showCompangInfo];
 
			break;
		}

		default:
			break;
	}

}

//个人信息
-(void)showPersonInfo
{
	//移出所有子视图 重新构建内容
//	[self removeContentAllView];
	
    if (nil == _userInfoTableView) {
        _userInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth - 10,KUIScreenHeight) style:UITableViewStylePlain];
        _userInfoTableView.delegate = self;
        _userInfoTableView.dataSource = self;
        _userInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _userInfoTableView.tag = 2001;
    }
        [contentView addSubview:_userInfoTableView];
    
}

//公司信息
-(void)showCompangInfo
{
	//移出所有子视图 重新构建内容
//	[self removeContentAllView];
    
	if (nil == _companyTableView) {
        _companyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth - 10, KUIScreenHeight) style:UITableViewStylePlain];
        if (!isIPhone5) {
            _companyTableView.frame = CGRectMake(0.f, 0.f, KUIScreenWidth - 10, KUIScreenHeight-60);
        }
        _companyTableView.delegate = self;
        _companyTableView.dataSource = self;
        [_companyTableView setBackgroundColor:RGB(232, 237, 241)];
        _companyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _companyTableView.tag = 2002;
        
    }
//    下面的添加更多
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSelfViewWidth, 100)];
    footView.backgroundColor = RGB(232, 237, 241);
    
    EnterMoreLiveAppView *enterMoreView = [[EnterMoreLiveAppView alloc] initWithFrame:CGRectMake(0, 20, kSelfViewWidth, 44) delegateController:self];
    [footView addSubview:enterMoreView];
    [enterMoreView release];
    
    _companyTableView.tableFooterView = footView;
    [footView release];

    [contentView addSubview:_companyTableView];
    
}

/*
 *进入更多的liveApp add vincent
 */
-(void)enterMemberLiveBtnAction{
    //开通公司轻APP
    browserViewController* browserVC = [[browserViewController alloc] init];
    browserVC.url = @"http://lightapp.cn";
    browserVC.webTitle = @"场景应用";
    [self.navigationController pushViewController:browserVC animated:YES];
    [browserVC release];
}


//顶部内容上下动画效果
-(void)topViewAnimation:(NSString *)type
{
    CGRect topViewFrame = topViewBg.frame;
    CGRect contentViewFrame = contentView.frame;
    
    if ([type isEqualToString:@"up"])
    {
        self.navigationBarType = NavigationBarAppear;
        topViewFrame.origin.y = -220.0f + versionH;
        contentViewFrame.origin.y = 44.0f + versionH;
        contentViewFrame.size.height = KUIScreenHeight;
        
        [self animationsSet];
        
        topViewBg.frame = topViewFrame;
        contentView.frame = contentViewFrame;

        [UIView commitAnimations];

    }
    else if ([type isEqualToString:@"down"])
    {

        self.navigationBarType = NavigationBarHidden;
        topViewFrame.origin.y = 0.0f;
        contentViewFrame.origin.y = 265.0f;
        
        CGRect myTableViewFrame = contentViewFrame;
        myTableViewFrame.origin.y = 0.0f;
  
        [self animationsSet];
    
        topViewBg.frame = topViewFrame;
        contentView.frame = contentViewFrame;
        
        [UIView commitAnimations];
    }
    if (self.navigationBarType == NavigationBarAppear) {
        navigationBarV.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"];
        userName.hidden = NO;
    } else {
        navigationBarV.backgroundColor = [UIColor clearColor];
        userName.hidden = YES;
    }
  
}

- (void)animationsSet{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.23];
    [UIView setAnimationCurve:0];
}

// cell分割线
- (void)addCellSeparatorLine:(NSIndexPath *)indexPath andCell:(UITableViewCell *)cell{
    CGRect lineRect;
    lineRect = CGRectMake(5.f, cell.frame.size.height - 1, KUIScreenWidth - 10, 1.0f);
    
    // 分割线
    UILabel *line = [[UILabel alloc]initWithFrame:lineRect];
    line.backgroundColor = COLOR_LINE;
    [cell.contentView addSubview:line];
    RELEASE_SAFE(line);
}

//邀请开通公司轻APP
- (void)dredgeCompanyLightApp:(UIButton *)sender{
    
    NSLog(@"申请开通");
    
    if (sender.tag == 11) {
        //开通公司轻APP
        companyInfoBrowserViewController* browserVC = [[companyInfoBrowserViewController alloc] init];
        browserVC.url = [NSString stringWithFormat:@"%@?org_id=%@&user_id=%@",LIGHTAPPURL,[Global sharedGlobal].org_id,[Global sharedGlobal].user_id];
        browserVC.webTitle = @"开通企业介绍轻APP";
        [self.navigationController pushViewController:browserVC animated:YES];
        [browserVC release];
        
    }else if (sender.tag == 22){
        //开通公司动态
        
    }
}

//切换到编辑资料页
-(void) turnToUserInfo:(id)sender{
    MemberInfoViewController* infoCtl = [[MemberInfoViewController alloc] init];
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"编辑资料"]) {
        infoCtl.accType = 1;
    }
    infoCtl.userInfoArry = self.userArr;
    if (self.accessType == AccessTypeSelf) {
        infoCtl.accType = 1;
    }
    [self.navigationController pushViewController:infoCtl animated:YES];
    RELEASE_SAFE(infoCtl);
}

#pragma mark - MemberTopViewDelegate
//点击头像
- (void)topViewHeadClick{
    NSLog(@"topViewHeadClick");
    if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
        MemberInfoViewController *infoCtl = [[MemberInfoViewController alloc]init];
        infoCtl.accType = 1;
        infoCtl.userInfoArry = self.userArr;
        [self.navigationController pushViewController:infoCtl animated:YES];
        RELEASE_SAFE(infoCtl);
    }
}

// 访客列表
- (void)topViewVisitorClick{
    if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
        
        topView.visitorRedPoint.hidden = YES;
        
        GuestMainPageViewController *guestCtl = [[GuestMainPageViewController alloc]init];
        [self.navigationController pushViewController:guestCtl animated:YES];
        RELEASE_SAFE(guestCtl);
    }
}

// 赞列表
- (void)topViewlikesClick{
     if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
         
        topView.likesRedPoint.hidden = YES;
         
        LikesMainPageViewController *likesCtl = [[LikesMainPageViewController alloc]init];
        [self.navigationController pushViewController:likesCtl animated:YES];
        RELEASE_SAFE(likesCtl);
     }
}

//指示框
-(void) showProgressHud{
    if (mbProgressHUD == nil) {
        mbProgressHUD = [[MBProgressHUD alloc] initWithView:APPKEYWINDOW];
        mbProgressHUD.labelText = @"正在加载中...";
        mbProgressHUD.mode = MBProgressHUDModeCustomView;
        [APPKEYWINDOW addSubview:mbProgressHUD];
    }
    
    [mbProgressHUD show:YES];
}

- (void)removeProgressHud{
    [mbProgressHUD hide:YES];
    [mbProgressHUD removeFromSuperViewOnHide];
}

//进入 livieApp
-(void)cellviewTaped:(UITapGestureRecognizer *)recognizer
{
    int tag=[recognizer view].tag-8000;
    NSLog(@"cellviewTaped %d",tag);
    
    //开通公司轻APP
    browserViewController* browserVC = [[browserViewController alloc] init];
    browserVC.url = [[self.openedUserArr objectAtIndex:tag] objectForKey:@"lightapp"];
    browserVC.webTitle = [[self.openedUserArr objectAtIndex:tag] objectForKey:@"realname"];
    [self.navigationController pushViewController:browserVC animated:YES];
    [browserVC release];
}

// 时间转换 展示在个人动态行
- (NSString *)timeFormatNum:(int)time{
    
    switch (time) {
        case 01:
        {
            return @"一月";
        }
            break;
            
        case 02:
        {
            return @"二月";
        }
            break;
        case 03:
        {
            return @"三月";
        }
            break;
        case 04:
        {
            return @"四月";
        }
            break;
        case 05:
        {
            return @"五月";
        }
            break;
        case 06:
        {
            return @"六月";
        }
            break;
        case 07:
        {
            return @"七月";
        }
            break;
        case 8:
        {
            return @"八月";
        }
            break;
        case 9:
        {
            return @"九月";
        }
            break;
        case 10:
        {
            return @"十月";
        }
            break;
        case 11:
        {
            return @"十一月";
        }
            break;
        case 12:
        {
            return @"十二月";
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 2001) {
        return 5;
    }else if (tableView.tag == 2002){
        switch (section) {
            case 0:
            {
                return 1;
            }
                break;
            case 1:
            {
                if (self.myCompanyArr.count ==0) {
                    return 1;
                }else{
                    return self.myCompanyArr.count;
                }
            }
                break;
            case 2:
            {
                if (self.myDynamicArr.count == 0) {
                    return 1;
                }else{
                    return self.myDynamicArr.count;
                }
            }
                break;
            case 3:
            {
                return 1;
            }
                break;
            default:
                break;
        }
         return 0;
    }
    return 0;
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 2001) {
        return 1;
    }else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2001) {
        if (indexPath.row == 0) {
            return 70.f;
        }else{
            return 44.f;
        }
    }else if(tableView.tag == 2002){
        
        return 70.f;
        
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 2001) {
        return 0.f;
    }else{
        if (section == 0) {
            return 0.f;
        }else{
            return 20.f;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 0.f, 200.f, 20.f)];
    sectionTitle.backgroundColor = COLOR_LIGHTWEIGHT;
    sectionTitle.textColor = COLOR_GRAY2;
    sectionTitle.font = KQLSystemFont(13);
    if (section == 1) {
        sectionTitle.text = @" 我的企业";
    }
//    else if (section == 2){
//        sectionTitle.text = @" 我的动态";
//    }
    else if (section == 2){
        sectionTitle.text = @" 他们都开通了企业介绍";
    }else{
        sectionTitle.text = @"";
    }
    return [sectionTitle autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
        case 2001:
        {
            
            if(indexPath.row == 0){
                static NSString *CellIdentifier = @"Cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
                
                for (UIView* v in cell.contentView.subviews) {
                    if ([v isKindOfClass:[UILabel class]]) {
                        [v removeFromSuperview];
                    }
                }
                
                UIView *bgTime = [[UIView alloc]initWithFrame:CGRectMake(10.f, 10.f, 45.f, 45.f)];
                bgTime.backgroundColor = RGBACOLOR(243, 152, 0, 1);
                bgTime.layer.cornerRadius = 5;
                bgTime.clipsToBounds = YES;
                [cell.contentView addSubview:bgTime];
//                RELEASE_SAFE(bgTime); //add vincent
                
                //时间
                UILabel *timeDay = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 2.f, 45.f, 30.f)];
                timeDay.font = KQLSystemFont(23);
                timeDay.textAlignment = NSTextAlignmentCenter;
                timeDay.textColor = [UIColor whiteColor];
                timeDay.backgroundColor = [UIColor clearColor];
                [bgTime addSubview:timeDay];
//                RELEASE_SAFE(timeDay);//add vincent
                
                UILabel *timeMonth = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 26.f, 45.f, 15.f)];
                timeMonth.font = KQLSystemFont(10);
                timeMonth.textAlignment = NSTextAlignmentCenter;
                timeMonth.textColor = [UIColor whiteColor];
                timeMonth.backgroundColor = [UIColor clearColor];
                [bgTime addSubview:timeMonth];
//                RELEASE_SAFE(timeMonth);//add vincent
                
                UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(75.f, 5.f, 220.f, 60.f)];
                
                //看自己的主页
                if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
                    if (self.publishArr.count > 0) {
                        
                        int createdTime = [[[self.publishArr objectAtIndex:0] objectForKey:@"created"] intValue];
                        
                        NSString *dateStr = nil;
                        if (createdTime == 0) {
                            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"yyyy-MM-dd"];
                            dateStr = [formatter stringFromDate:[NSDate date]];
                            
                            RELEASE_SAFE(formatter);//add vincent
                            
                        }else{
                            dateStr = [Common makeTime:[[[self.publishArr objectAtIndex:0] objectForKey:@"created"]intValue] withFormat:@"yyyy-MM-dd"];
                        }
                        
                        NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
                        
                        timeDay.text = [arr objectAtIndex:2];
                        timeMonth.text = [self timeFormatNum:[[arr objectAtIndex:1] intValue]];
                        
                        if ([[[self.publishArr objectAtIndex:0]objectForKey:@"content"] isEqualToString:@""]) {
//                            msgLabel.text = @"还未发布动态信息";
                            int type = [[[self.publishArr objectAtIndex:0] objectForKey:@"type"] intValue];
                            int publishId = [[[self.publishArr objectAtIndex:0] objectForKey:@"id"] intValue];
                            
                            if (publishId == 0) {
                                msgLabel.text = @"还未发布动态信息";
                            }else{
                                if (type == 0) {
                                    msgLabel.text = @"图片";
                                }else if (type == 1) {
                                    msgLabel.text = @"ooxx";
                                }else if (type == 2) {
                                    msgLabel.text = @"开放时间";
                                }else if (type == 3) {
                                    msgLabel.text = @"我有";
                                }else if (type == 4) {
                                    msgLabel.text = @"我要";
                                }else{
                                    msgLabel.text = @"图片";
                                }
                            }
                            
                        }else{
                            msgLabel.text = [[self.publishArr objectAtIndex:0]objectForKey:@"content"];
                        }
                    }else{
                        
                        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd"];
                        NSString* dateStr = [formatter stringFromDate:[NSDate date]];
                        NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
                        
                        timeDay.text = [arr objectAtIndex:2];
                        timeMonth.text = [self timeFormatNum:[[arr objectAtIndex:1] intValue]];
                        
                        RELEASE_SAFE(formatter);//add vincent
                        
                        msgLabel.text = @"还未发布动态信息";
                    }
                //看他人的主页
                }else{
                   if (self.publishArr.count > 0) {
                       if ([[[self.publishArr objectAtIndex:0]objectForKey:@"content"] isEqualToString:@""]) {
//                           msgLabel.text = @"还未发布动态信息";
                           int type = [[[self.publishArr objectAtIndex:0] objectForKey:@"type"] intValue];
                           int publishId = [[[self.publishArr objectAtIndex:0] objectForKey:@"id"] intValue];
                           
                           if (publishId == 0) {
                               msgLabel.text = @"还未发布动态信息";
                           }else{
                               if (type == 0) {
                                   msgLabel.text = @"图片";
                               }else if (type == 1) {
                                   msgLabel.text = @"ooxx";
                               }else if (type == 2) {
                                   msgLabel.text = @"开放时间";
                               }else if (type == 3) {
                                   msgLabel.text = @"我有";
                               }else if (type == 4) {
                                   msgLabel.text = @"我要";
                               }else{
                                   msgLabel.text = @"图片";
                               }
                           }
                       }else{
                           msgLabel.text = [[self.publishArr objectAtIndex:0]objectForKey:@"content"];
                       }
                       
                       int createdTime = [[[self.publishArr objectAtIndex:0] objectForKey:@"created"] intValue];
                       
                       NSString *dateStr = nil;
                       if (createdTime == 0) {
                           NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                           [formatter setDateFormat:@"yyyy-MM-dd"];
                           dateStr = [formatter stringFromDate:[NSDate date]];
                           
                           RELEASE_SAFE(formatter);//add vincent
                           
                       }else{
                           dateStr = [Common makeTime:[[[self.publishArr objectAtIndex:0] objectForKey:@"created"]intValue] withFormat:@"yyyy-MM-dd"];
                       }
                        NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
                        
                        timeDay.text = [arr objectAtIndex:2];
                        timeMonth.text = [self timeFormatNum:[[arr objectAtIndex:1] intValue]];
                   }else{
                       
                       NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                       [formatter setDateFormat:@"yyyy-MM-dd"];
                       NSString *dateStr = [formatter stringFromDate:[NSDate date]];
                       NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
                       
                       timeDay.text = [arr objectAtIndex:2];
                       timeMonth.text = [self timeFormatNum:[[arr objectAtIndex:1] intValue]];
                        RELEASE_SAFE(formatter);//add vincent
                       msgLabel.text = @"还未发布动态信息";
                   }
                }
                
                msgLabel.textColor = COLOR_GRAY2;
                [cell.contentView addSubview:msgLabel];
                 RELEASE_SAFE(msgLabel);//add vincent
                
                // 分割线
                UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(5.f, 69.f, KUIScreenWidth -10, 1.0f)];
                line.backgroundColor = COLOR_LINE;
                [cell.contentView addSubview:line];
                RELEASE_SAFE(line);
                
                RELEASE_SAFE(bgTime);
                RELEASE_SAFE(timeDay);
                RELEASE_SAFE(timeMonth);
                
                return cell;
            }else{
                static NSString *CellIdentifier = @"infoCell";
                personCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[[personCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier  ] autorelease];
                    [cell setCellShowType:CellShowTypeLeft];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }

                [self addCellSeparatorLine:indexPath andCell:cell];
                
                NSDictionary *userlistDic = [[self.otherAllInfoArr lastObject] objectForKey:@"userinfo"];
                
                switch (indexPath.row) {
                    case 1:
                    {
                        cell.tipsNameL.text = @"公司";
                        if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
                            if (userArr.count > 0) {
                                NSString *companyName = [[userArr objectAtIndex:0]objectForKey:@"company_name"];
                                CGSize nameSize = [companyName sizeWithFont:KQLboldSystemFont(15) constrainedToSize:CGSizeMake(MAXFLOAT, 40) lineBreakMode:NSLineBreakByWordWrapping];
                                if (nameSize.width < 200) {
                                    companyName = [companyName stringByAppendingFormat:@"\n%@",[[userArr objectAtIndex:0] objectForKey:@"company_role"]];
                                }else{
                                    companyName = [companyName stringByAppendingFormat:@"   %@",[[userArr objectAtIndex:0] objectForKey:@"company_role"]];
                                }
                                
                                if (![companyName isEqualToString:@""]) {
                                    cell.txtLabel.text = companyName;
                                }else{
                                    cell.txtLabel.text = @"未填写公司信息";
                                    
                                }
                            }
                            
                        }else{
                            
                            NSString *companyName = [userlistDic objectForKey:@"company_name"];
                            if (![companyName isEqualToString:@""]) {
                                cell.txtLabel.text = companyName;
                            }else{
                                cell.txtLabel.text = @"未填写公司信息";
                               
                            }
                            
                        }
                        
                    }
                        break;
                    case 2:
                    {
                        cell.tipsNameL.text = @"电话";
                      if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
                             if (userArr.count > 0) {
                          
                                 NSString *mobile = [[userArr objectAtIndex:0]objectForKey:@"mobile"];
                                 if (![mobile isEqualToString:@""]) {
                                     cell.txtLabel.text = mobile;
                                 }else{
                                     cell.txtLabel.text = @"未填写电话信息";
                                     
                                 }
                        
                             }
                        }else{
                  
                            NSString *mobile = [userlistDic objectForKey:@"mobile"];
                            if (![mobile isEqualToString:@""]) {
                                cell.txtLabel.text = mobile;
                            }else{
                                cell.txtLabel.text = @"未填写电话信息";
                            }
                        }
                    }
                        break;
                    case 3:
                    {
                        cell.tipsNameL.text = @"邮箱";
                       if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
                            if (userArr.count > 0) {
                  
                                NSString *email = [[userArr objectAtIndex:0]objectForKey:@"email"];
                                if (![email isEqualToString:@""]) {
                                    cell.txtLabel.text = email;
                                }else{
                                    cell.txtLabel.text = @"未填写邮箱信息";
                                }
                                
                            }
                        }else{
                  
                            NSString *email = [userlistDic objectForKey:@"email"];
                            if (![email isEqualToString:@""]) {
                                cell.txtLabel.text = email;
                            }else{
                                cell.txtLabel.text = @"未填写邮箱信息";
                            }
                        }
                    }
                        break;
                    case 4:
                    {
                        cell.tipsNameL.text = @"兴趣";
                        if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
                            if (userArr.count > 0) {

                                NSString *interests = [[userArr objectAtIndex:0]objectForKey:@"interests"];
                                if (![interests isEqualToString:@""]) {
                                    cell.txtLabel.text = interests;
                                }else{
                                    cell.txtLabel.text = @"未填写兴趣信息";
                                }
                                
                            }
                        }else{
                    
                            NSString *interests = [userlistDic objectForKey:@"interests"];
                            if (![interests isEqualToString:@""]) {
                                cell.txtLabel.text = interests;
                            }else{
                                cell.txtLabel.text = @"未填写兴趣信息";
                            }
                        }
                    }
                        break;
                    default:
                        break;
                }
             
                return cell;
            
        }
        }
            break;
        case 2002:
        {
            if(indexPath.section == 0){
                static NSString *CellIdentifier = @"Cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
                
                for (UIView* v in cell.contentView.subviews) {
                    if ([v isKindOfClass:[UILabel class]]) {
                        [v removeFromSuperview];
                    }
                }
                
                UIImageView* supply = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
                supply.layer.cornerRadius = 5;
                supply.clipsToBounds = YES;
                supply.image = IMG(@"ico_common_have");
                
                UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.f, 5.f, 220.f, 60.f)];
                msgLabel.backgroundColor = [UIColor clearColor];
                msgLabel.textColor = COLOR_GRAY2;
                
                int type = 0;
                
                if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
                    
                    if (self.supplyArr.count != 0) {
  
                        type = [[[self.supplyArr objectAtIndex:0]objectForKey:@"type"]intValue];
                        
                        if (type == 3) {
                            supply.image = IMG(@"ico_common_have");
                        }else if (type == 4) {
                            supply.image = IMG(@"ico_common_want");
                        }
                        
                        NSString* str = [[self.supplyArr objectAtIndex:0]objectForKey:@"content"];
                        if (str.length > 0) {
                            msgLabel.text = str;
                        }else{
                            if (type == 3) {
                                msgLabel.text = @"我有";
                            }else if (type == 4){
                                msgLabel.text = @"我要";
                            }
                        }
                        
                    }else{
                     
                        msgLabel.text = @"还未发布供需信息";
                    }
                }
                else{
                     if (self.supplyArr.count != 0) {
                        type = [[[self.supplyArr objectAtIndex:0]objectForKey:@"type"]intValue];
                         if (type == 3) {
                             supply.image = IMG(@"ico_feed_have");
                         }else if (type == 4) {
                             supply.image = IMG(@"ico_feed_want");
                         }
                         
                         NSString* str = [[self.supplyArr objectAtIndex:0]objectForKey:@"content"];
                         if (str.length > 0) {
                             msgLabel.text = str;
                         }else{
                             if (type == 3) {
                                 msgLabel.text = @"我有";
                             }else if (type == 4){
                                 msgLabel.text = @"我要";
                             }
                         }

                         
                     }else{
                         
                         msgLabel.text = @"还未发布供需信息";
                     }
                }
                
                [cell.contentView addSubview:supply];
                RELEASE_SAFE(supply);//add vincent
                [cell.contentView addSubview:msgLabel];
                RELEASE_SAFE(msgLabel);//add vincent
                return cell;
            }else if(indexPath.section == 1){
                static NSString *myCompany = @"myCompanyCell";
                myCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:myCompany];
                
                if (cell == nil) {
                    cell = [[[myCompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCompany] autorelease];
                }
                
                [cell hiddenNoDredgeCompanyLightApp];
                cell.iconV.hidden = NO;
                cell.companyT.hidden = NO;
                cell.browseCount.hidden = NO;
                
                NSArray *otherCompany = [[self.otherAllInfoArr lastObject] objectForKey:@"company"];
                
                //从数据库中取数据 by devin
//                liveapp_companyInfo_model *liveappModel = [[liveapp_companyInfo_model alloc]init];
//                self.myCompanyArr = [liveappModel getList];
                
                if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
                    if (self.myCompanyArr.count >0) {
                        
                        NSDictionary * companyInfo = [self.myCompanyArr firstObject];
                        
                        NSURL *urlStr = [NSURL URLWithString:[companyInfo objectForKey:@"image_path"]];
                        
                        [cell.iconV setImageWithURL:urlStr placeholderImage:IMGREADFILE(@"bg_member_gray_stroke.png")];
                        
                        cell.companyT.text = [companyInfo objectForKey:@"name"];
                        cell.browseCount.text = [NSString stringWithFormat:@"%@次浏览",[companyInfo objectForKey:@"scan_sum"]];
                        [cell hiddenNoDredgeCompanyLightApp];
                    }else {
                        [cell noDredgeCompanyLightApp:0];
                    }
                }else{
                    if (otherCompany.count >0) {
                        NSURL *urlStr = [NSURL URLWithString:[[otherCompany objectAtIndex:indexPath.row] objectForKey:@"image_path"]];
                        
                        [cell.iconV setImageWithURL:urlStr placeholderImage:IMGREADFILE(@"bg_member_gray_stroke.png")];
                        
                        cell.companyT.text = [[otherCompany objectAtIndex:indexPath.row] objectForKey:@"name"];
                        
                        cell.browseCount.text = [NSString stringWithFormat:@"%@次浏览",[[otherCompany objectAtIndex:indexPath.row] objectForKey:@"scan_sum"]];
                        
                    }else {
                       [cell noDredgeCompanyLightApp:1];
                    }
                }
                
                [cell.dredgeBtn setTag:11];
                [cell.dredgeBtn addTarget:self action:@selector(dredgeCompanyLightApp:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
                
            }
//            else if(indexPath.section == 2){
//                static NSString *CellIdentifier = @"infoCell";
//                companyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//                
//                if (cell == nil) {
//                    cell = [[[companyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//                }
//                //看他人主页数据
//                NSArray *otherDynamic = [[self.otherAllInfoArr lastObject] objectForKey:@"company_dynamic"];
//            
//                if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
//                    if (self.myDynamicArr.count >0) {
//                        
//                        cell.companyInfo.text = [[self.myDynamicArr objectAtIndex:indexPath.row]objectForKey:@"content"];
//                        
//                        cell.timeInfo.text = [Common makeTime:[[[self.myDynamicArr objectAtIndex:indexPath.row] objectForKey:@"created"]intValue] withFormat:@"yyyy-MM-dd"];
//                    }else{
//                        cell.companyInfo.text = @"还未发布企业信息";
//                    }
//                    
//                }else{
//                    if (otherDynamic.count >0) {
//                   
//                        cell.companyInfo.text = [[otherDynamic objectAtIndex:indexPath.row]objectForKey:@"content"];
//                        
//                        cell.timeInfo.text = [Common makeTime:[[[otherDynamic objectAtIndex:indexPath.row] objectForKey:@"created"]intValue] withFormat:@"yyyy-MM-dd"];
//                    }else{
//                        cell.companyInfo.text = @"还未发布企业信息";
//                    }
//                }
//                
//                if(self.accessType == AccessTypeLookOther ||self.accessType == AccessTypeSearchLook){
//                    //未开通公司轻app
//                    
//                    [cell noDredgeCompanyLightApp:1];
//                    
//                }else{
//                    [cell noDredgeCompanyLightApp:0];
//
//                }
//                [cell.dredgeBtn setTag:22];
//                [cell.dredgeBtn addTarget:self action:@selector(dredgeCompanyLightApp:) forControlEvents:UIControlEventTouchUpInside];
//                return cell;
//                
//            }
            else if(indexPath.section == 2){
                static NSString *CellIdentifier1 = @"liviAppCell";
                SubCollectionsCell *cell =(SubCollectionsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
                if (cell == nil)
                {
                    cell = [[[SubCollectionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
                
                NSUInteger row=[indexPath row];
                for (NSInteger i = 0; i < 2; i++)
                {
                    //奇数
                    if (row*2+i>self.openedUserArr.count-1)
                    {
                        break;
                    }
                    NSDictionary* liveAppDic = [self.openedUserArr objectAtIndex:row*2 + i];
                    if (i==0)
                    {
                        [cell.cellView1.iconImageView setImageWithURL:[NSURL URLWithString:[liveAppDic objectForKey:@"portrait"]] placeholderImage:[UIImage imageNamed:@"img_common_default_male1.png"]];
                        cell.cellView1.titleNameLabel.text = [liveAppDic objectForKey:@"realname"];
                        cell.cellView1.companyLabel.text = [liveAppDic objectForKey:@"company_name"];
                        cell.cellView1.tag=8000+row*2 + i;
                        
                        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellviewTaped:)];
                        [cell.cellView1 addGestureRecognizer:tapRecognizer];
                        [tapRecognizer release];
                    }else{
                        [cell.cellView2.iconImageView setImageWithURL:[NSURL URLWithString:[liveAppDic objectForKey:@"portrait"]] placeholderImage:[UIImage imageNamed:@"img_common_default_male1.png"]];
                        cell.cellView2.titleNameLabel.text = [liveAppDic objectForKey:@"realname"];
                        cell.cellView2.companyLabel.text = [liveAppDic objectForKey:@"company_name"];
                        
                        cell.cellView2.tag=8000+ row*2 + i;
                        
                        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellviewTaped:)];
                        [cell.cellView2 addGestureRecognizer:tapRecognizer];
                        [tapRecognizer release];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (tableView.tag) {
        case 2001:
        {
            if (indexPath.row == 0) {
                //个人发布的动态
                
                if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
                    
                }else{
                    if (self.publishArr.count == 0) {
                        return;
                    }else{
                        int publishId = [[[self.publishArr objectAtIndex:0] objectForKey:@"id"] intValue];
                        if (publishId == 0) {
                            return;
                        }
                    }
                }
                
                MemberDynamicViewController* myDynamic = [[MemberDynamicViewController alloc] init];
                
                if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
                    
                }else{
                    myDynamic.lookId = self.lookId;
                }
                
                [self.navigationController pushViewController:myDynamic animated:YES];
                RELEASE_SAFE(myDynamic);
            }
        }
            break;
        case 2002:
        {
            if (indexPath.row == 0 && indexPath.section == 0) {
                //个人的我有我要
                if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
                    
                }else{
                    if (self.supplyArr.count == 0) {
                        return;
                    }
                }
                
                MemberWantHaveViewController* myDynamic = [[MemberWantHaveViewController alloc] init];
                
                if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
                   
                }else{
                    myDynamic.lookId = self.lookId;
                }
                
                [self.navigationController pushViewController:myDynamic animated:YES];
                RELEASE_SAFE(myDynamic);
                
                
            }else if (indexPath.section == 1){
                
                NSArray *otherCompany = [[self.otherAllInfoArr lastObject] objectForKey:@"company"];
                
                if (self.accessType == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
                    if (self.myCompanyArr.count >0) {
                        //开通公司轻APP
                        companyInfoBrowserViewController* browserVC = [[companyInfoBrowserViewController alloc] init];
                        
                        browserVC.url = [[self.myCompanyArr firstObject]objectForKey:@"lightapp"];
                        browserVC.webTitle = @"开通企业介绍轻APP";
                        [self.navigationController pushViewController:browserVC animated:YES];
                        [browserVC release];
                        
                    } else {
                        
                        //开通公司轻APP
                        companyInfoBrowserViewController* browserVC = [[companyInfoBrowserViewController alloc] init];
                        browserVC.url = [NSString stringWithFormat:@"%@?org_id=%@&user_id=%@",LIGHTAPPURL,[Global sharedGlobal].org_id,[Global sharedGlobal].user_id];
                        browserVC.webTitle = @"开通企业介绍轻APP";
                        [self.navigationController pushViewController:browserVC animated:YES];
                        [browserVC release];
                    
                    }
                    
                }else{
                    if (otherCompany.count >0) {
                        //开通公司轻APP
                        companyInfoBrowserViewController* browserVC = [[companyInfoBrowserViewController alloc] init];
                    
                        NSString *lightappString;
                        for (NSDictionary *tempDic in [[self.otherAllInfoArr lastObject] objectForKey:@"company"]) {
                            lightappString = [tempDic objectForKey:@"lightapp"];
                        }
                    
                        browserVC.url = lightappString;
                    
                        browserVC.webTitle = @"开通企业介绍轻APP";
                        [self.navigationController pushViewController:browserVC animated:YES];
                        [browserVC release];
                    }
                }
            }
     
            
        }
            break;
        default:
            break;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
    int currentOffsetY = scrollView.contentOffset.y;
    
    if (scrollView.dragging == YES && scrollView.decelerating == NO)
    {
        if (isAnimation)
        {
            if (currentOffsetY - lastContentOffsetY > 10)
            {
                isAnimation = NO;
                lastContentOffsetY = scrollView.contentOffset.y;
                [self topViewAnimation:@"up"];
                
            }
            else if (lastContentOffsetY - currentOffsetY > 10)
            {
                isAnimation = NO;
                lastContentOffsetY = scrollView.contentOffset.y;
                [self topViewAnimation:@"down"];
            }
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffsetY = scrollView.contentOffset.y;
    isAnimation = YES;
    
}

#pragma mark - accessService
//用户信息请求
- (void)accessUserInfoService:(AccessType)type{
    NSLog(@"self.lookId == %lld",self.lookId);

    NSNumber * orgID = nil;
    if ([[[[Global sharedGlobal]secretInfo]objectForKey:@"user_id"]longLongValue] == self.lookId) {
        orgID = [NSNumber numberWithInt:0];
    } else {
        orgID = [Global sharedGlobal].org_id;
    }
    
    if (type == AccessTypeSelf || self.lookId == [[Global sharedGlobal].user_id longLongValue]) {
        NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [Global sharedGlobal].user_id,@"user_id",
                                            [Global sharedGlobal].org_id,@"org_id",
                                            [NSNumber numberWithLongLong:self.lookId],@"look_id",
                                            nil];
        
        [[NetManager sharedManager]accessService:jsontestDic data:nil command:MIANPAGE_INFO_COMMAND_ID accessAdress:@"member/detail.do?param=" delegate:self withParam:nil];
        
    }else if (type == AccessTypeLookOther ||self.accessType == AccessTypeSearchLook ||self.accessType == AccessTypeCircleLook){
        //加载框
        [self showProgressHud];
        
        NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       [NSNumber numberWithLongLong:self.lookId],@"user_id",
                       [Global sharedGlobal].user_id,@"look_id",
                       orgID,@"org_id",
                       nil];
        
        [[NetManager sharedManager]accessService:jsontestDic data:nil command:MIANPAGE_INFO_OTHER_COMMAND_ID accessAdress:@"member/detail.do?param=" delegate:self withParam:nil];
    }
}

//邀请企业开通轻app请求
- (void)accessInvitecompanyService:(int)type{
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [Global sharedGlobal].user_id,@"user_id",
                                        [NSNumber numberWithInt:self.destinationId],@"destination_id",
                                        [NSNumber numberWithInt:type],@"type",
                                        [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:INVITE_COMPANY_COMMAND_ID accessAdress:@"company/invitecompany.do?param=" delegate:self withParam:nil];
    
}

//网络请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    
    ParseMethod safeMethod = ^(){
        int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
        
        switch (commandid) {
            case MIANPAGE_INFO_COMMAND_ID:
            {
                NSDictionary *userlistDic = [[resultArray objectAtIndex:0] objectForKey:@"userinfo"];
                DLog(@"%@",userlistDic);
                
                //获取访客，点赞表示 1代表有访客点赞 0 没有 add by devin
                for (NSDictionary *dic in resultArray) {
                    is_new_vistor = [[dic objectForKey:@"is_new_vistor"] integerValue];
                    is_new_care = [[dic objectForKey:@"is_new_care"] integerValue];
                }
                
                self.userArr = [NSMutableArray arrayWithObject:[[resultArray objectAtIndex:0] objectForKey:@"userinfo"]];
                self.myCompanyArr = [[resultArray objectAtIndex:0] objectForKey:@"company"];
                self.supplyArr = [[resultArray objectAtIndex:0] objectForKey:@"supplydemand"];
                self.publishArr = [NSMutableArray arrayWithObject:[[resultArray objectAtIndex:0] objectForKey:@"lastestPublish"]];
                self.myDynamicArr = [[resultArray objectAtIndex:0] objectForKey:@"company_dynamic"];
                self.openedUserArr = [[resultArray objectAtIndex:0] objectForKey:@"open_company_users"];
                //更新云主页头部数据
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMainPage" object:userlistDic];
                
                userName.text = [userlistDic objectForKey:@"realname"];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{

                        if (self.accessType == AccessTypeSelf) {
                            //访客红点表示  add by devin
                            if (is_new_vistor) {
                                topView.visitorRedPoint.hidden = NO;
                            }else {
                                topView.visitorRedPoint.hidden = YES;
                            }
                            
                            //点赞红点表示
                            if (is_new_care) {
                                topView.likesRedPoint.hidden = NO;
                            }else {
                                topView.likesRedPoint.hidden = YES;
                            }
                        }
                        [_userInfoTableView reloadData];
                        [_companyTableView reloadData];
                        
                        //更新用户数据
                        [topView writeDataInfo:self.userArr];
                        
                    });
                });
                
            }break;
            case MIANPAGE_INFO_OTHER_COMMAND_ID:
            {
                self.otherAllInfoArr = resultArray;
                
                NSDictionary *userlistDic = [[resultArray objectAtIndex:0] objectForKey:@"userinfo"];
                DLog(@"%@",userlistDic);
                
                self.userArr = [NSMutableArray arrayWithObject:[[resultArray objectAtIndex:0] objectForKey:@"userinfo"]];
                self.myCompanyArr = [[resultArray objectAtIndex:0] objectForKey:@"company"];
                self.supplyArr = [[resultArray objectAtIndex:0] objectForKey:@"supplydemand"];
                self.publishArr = [NSMutableArray arrayWithObject:[[resultArray objectAtIndex:0] objectForKey:@"lastestPublish"]];
                self.myDynamicArr = [[resultArray objectAtIndex:0] objectForKey:@"company_dynamic"];
                self.openedUserArr = [[resultArray objectAtIndex:0] objectForKey:@"open_company_users"];
                //更新他人云主页头部数据
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMainPage" object:userlistDic];
                
                userName.text = [userlistDic objectForKey:@"realname"];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_userInfoTableView reloadData];
                        [_companyTableView reloadData];
                        
                        //更新用户数据
                        [topView writeDataInfo:self.userArr];
                    });
                });
                
                //去掉加载框
                [self removeProgressHud];//add vincent
                
            }break;
                
            case INVITE_COMPANY_COMMAND_ID:
            {
                if (resultInt == 0) {
                    [self performSelectorOnMainThread:@selector(inviteError) withObject:nil waitUntilDone:NO];
                    
                }else if(resultInt == 1){
                    
                    [self performSelectorOnMainThread:@selector(inviteSuccess) withObject:nil waitUntilDone:NO];
                }else if(resultInt == 2){
                    
                    [self performSelectorOnMainThread:@selector(inviteAgain) withObject:nil waitUntilDone:NO];
                }
                
            }break;
            default:
                break;
        }

    };
    [Common securelyparseHttpResultArr:resultArray andMethod:safeMethod];
}

//邀请失败处理
- (void)inviteError{
//    [Common checkProgressHUD:@"邀请失败" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"邀请失败" andImage:KAccessFailedIMG];
}
//邀请成功处理
- (void)inviteSuccess{
//    [Common checkProgressHUD:@"邀请成功" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"邀请成功" andImage:KAccessSuccessIMG];
}
//已邀请
- (void)inviteAgain{
//    [Common checkProgressHUD:@"您已经邀请过了" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"您已经邀请过了" andImage:KAccessFailedIMG];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    RELEASE_SAFE(segmentBg);
    RELEASE_SAFE(slipV);
    RELEASE_SAFE(_userInfoTableView);
    RELEASE_SAFE(_companyTableView);
    RELEASE_SAFE(userName);
    RELEASE_SAFE(navigationBarV);
    RELEASE_SAFE(topView);
    [super dealloc];
}

@end
