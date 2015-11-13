//
//  CircleDetailViewController.m
//  ql
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "CircleDetailCell.h"
#import "GroupViewController.h"
#import "YLNameCardViewController.h"
#import "CircleQrCodeViewController.h"
#import "ModifyCircleNameViewController.h"
#import "AddMemberViewController.h"
#import "ModifyIntroduceViewController.h"
#import "login_info_model.h"
#import "UIImageView+WebCache.h"
#import "TcpInviteJionPackage.h"
#import "TcpRequestHelper.h"
#import "PXAlertView.h"
#import "PopShareView.h"
#import "HttpRequest.h"
#import "UIImageScale.h"
#import "TextData.h"
#import "chatmsg_list_model.h"
#import "SessionViewController.h"
#import "circle_member_list_model.h"
#import "SBJson.h"
#import "NSString+MessageDataExtension.h"
#import "CircleMainViewController.h"
#import "CRNavigationController.h"

#import "MemberMainViewController.h"

#import "circle_list_model.h"
#import "temporary_circle_list_model.h"
#import "chatmsg_list_model.h"

#define QuitCircleAlert         100
#define DissolveCircleAlert     200

@interface CircleDetailViewController ()
{
    UITableView *_detailTable;
    UIButton *_enterSession;
    UIButton *_addMember;
    
    UILabel *_nameFeild;
    UILabel *_introFeild;
}
@property (nonatomic, retain) UILabel *nameFeild;
@property (nonatomic, retain) UILabel *introFeild;
@end

@implementation CircleDetailViewController
@synthesize detailType = _detailType;
@synthesize detailDictionary = _detailDictionary;
@synthesize nameFeild = _nameFeild;
@synthesize introFeild = _introFeild;
@synthesize memberArray = _memberArray;
@synthesize markType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInfo:) name:@"updateCircleName" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateIntro:) name:@"updateCircleIntro" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inviteJoinSuccess:) name:@"inviteJoinSuccess" object:nil];
    
    //退出圈子成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitCircleNotify:) name:KNotiQuitCircle object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitTempCircleNotify:) name:KNotiQuitTempCircle object:nil];
    
	self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    // add the dailogue logic 0504 snail
    if (self.detailType == CircleDetailTypeTempDialogue) {
        self.title = @"会话详情";
    } else {
        self.title = @"圈子详情";
    }
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    //是否是新创建圈子的详情
    CGRect rectF;
    if (self.markType == 1) {
        rectF = CGRectMake(0.f, 30.f, KUIScreenWidth, KUIScreenHeight - 50);
    }else{
        rectF = CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight - 50);
    }
    
    // 主视图
    _detailTable = [[UITableView alloc]initWithFrame:rectF style:UITableViewStylePlain];
    _detailTable.delegate = self;
    _detailTable.dataSource = self;
    _detailTable.backgroundColor = [UIColor clearColor];
    _detailTable.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_detailTable setSeparatorInset:UIEdgeInsetsZero];
    }
    _detailTable.showsVerticalScrollIndicator = NO;
    
    _detailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_detailTable];
    
    // 创建完成后的详情
    if(self.detailType == CircleDetailTypeOtherAccess || self.detailType == CircleDetailTypeSelfAccess || self.detailType == CircleDetailTypeTempDialogue)
    {
        [self sessionBtn];
        
        //        [self shareBarButton];
        
        _detailTable.scrollEnabled = YES;
        
    }else{
        // 创建圈子详情
//        _detailTable.scrollEnabled = NO;
//        [self addMemberBtn];

        _detailTable.scrollEnabled = YES;
        
        if (markType == 1) {
            [self createSuccessReminder];
        }
        
    }
    
    NSLog(@"detailDictionary==%@==%@",self.detailDictionary,[self.detailDictionary objectForKey:@"circle_id"]);
    
    //从写NavigationBar 如果是创建成功跳转过来的则改变其pop方式直接pop到圈子列表而不是上级页面
    [self loadNavigationBarButton];
    
    //加载所需下Bar
    if (self.isTurnToListView == YES) {
        //增加完成的下bar条
        [self initButtomBarWithTitle:@"完    成" ];
    }
    
    if ([[self.detailDictionary objectForKey:kChatBoth]isEqualToString:kChatBoth]) {
        //添加 保存为圈子按钮
//        [self initButtomBarWithTitle:@"保存为圈子" ];
    }
    
}

//创建时无返回，通过下bar返回到list页
-(void) initButtomBarWithTitle:(NSString *)title{
    UIButton* btmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    btmBtn.backgroundColor = [UIColor whiteColor];
    btmBtn.frame = CGRectMake(0, self.view.bounds.size.height - 60 - 64, self.view.bounds.size.width, 60);
    [btmBtn setTitle:title forState:UIControlStateNormal];
    [btmBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
    [btmBtn addTarget:self action:@selector(turnToCircleListView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btmBtn];
}

//当该detail View 是由创建圈子进入的时候则改变返回按钮的返回效果直接返回圈子列表
- (void)loadNavigationBarButton
{
    if (self.isTurnToListView)
    {
        UIImage * returnImg = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
        UIButton * leftBackButton = [UIButton new];
        [leftBackButton setImage:returnImg forState:UIControlStateNormal];
        [leftBackButton sizeToFit];
        [leftBackButton addTarget:self action:@selector(turnToCircleListView) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithCustomView:leftBackButton];
        self.navigationItem.leftBarButtonItem = barItem;
        
        //创建的时候没有返回
        leftBackButton.hidden = YES;
        
    }
}

- (void)turnToCircleListView
{
    if ([[self.detailDictionary objectForKey:kChatBoth]isEqualToString:kChatBoth]) {
        [Common checkProgressHUD:@"敬请期待" andImage:nil showInView:APPKEYWINDOW];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

// 会话按钮
- (void)sessionBtn{
    _enterSession = [UIButton buttonWithType:UIButtonTypeCustom];
    _enterSession.frame = CGRectMake(0.f, KUIScreenHeight - 104.f, KUIScreenWidth, 60.f);
    
    _enterSession.backgroundColor = [UIColor whiteColor];
    
    if (self.detailType == CircleDetailTypeOtherAccess) {
        [_enterSession setTitle:@"申请加入" forState:UIControlStateNormal];
        _enterSession.hidden = YES;
    }else if (self.detailType == CircleDetailTypeTempDialogue){
        //第一期不做
        //        [_enterSession setTitle:@"保存为圈子" forState:UIControlStateNormal];
        _enterSession.hidden = YES;
    } else {
        [_enterSession setTitle:@"开始聊天" forState:UIControlStateNormal];
    }
    
    [_enterSession setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
    [_enterSession addTarget:self action:@selector(sessionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_enterSession];
    
    //如果为临时会话跳转到的detail 页面将不存在这个按钮 通过传入的字典中是否存在临时圈子key来判断
    if ([[self.detailDictionary objectForKey:kChatBoth] isEqualToString:kChatBoth]) {
        _enterSession.hidden = YES;
    }
}

// 更新圈子名称
- (void)updateInfo:(NSNotification *)note{
    self.nameFeild.text = note.object;
    NSMutableDictionary* circleInfoDic = [NSMutableDictionary dictionaryWithDictionary:self.detailDictionary];
    [circleInfoDic removeObjectForKey:@"name"];
    [circleInfoDic setObject:self.nameFeild.text forKey:@"name"];
    NSDictionary* changeDic = [NSDictionary dictionaryWithDictionary:circleInfoDic];
    self.detailDictionary = changeDic;
    
}

//更新圈子介绍 并且将数据字典修改用于改变二级页面效果
- (void)updateIntro:(NSNotification *)note{
    self.introFeild.text = note.object;
    NSMutableDictionary * circleInfoDic = [NSMutableDictionary dictionaryWithDictionary:self.detailDictionary];
    [circleInfoDic removeObjectForKey:@"content"];
    [circleInfoDic setObject:self.introFeild.text forKey:@"content"];
    NSDictionary * changeDic = [NSDictionary dictionaryWithDictionary:circleInfoDic];
    self.detailDictionary = changeDic;
}

//邀请成员加入圈子发送成功
- (void)inviteJoinSuccess:(NSNotification *)note{
//    [self.navigationController popViewControllerAnimated:YES];
    
    [Common checkProgressHUD:@"已发出邀请加入信息" andImage:nil showInView:APPD.keyWindow];
}

// 添加成员
- (void)addMemberBtn{
    CGFloat addBtnHeight;
    if (self.markType == 1) {
        addBtnHeight = 320.f;
    }else{
        addBtnHeight = 350.f;
    }
    
    _addMember = [UIButton buttonWithType:UIButtonTypeCustom];
    _addMember.frame = CGRectMake(10.f, KUIScreenHeight - addBtnHeight, KUIScreenWidth - 20.f, 40.f);
    //    _addMember.backgroundColor = COLOR_CONTROL;
    _addMember.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    _addMember.layer.cornerRadius = 6;
    [_addMember setTitle:@"添加成员" forState:UIControlStateNormal];
    [_addMember addTarget:self action:@selector(addMemberClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addMember];
    
    UIButton *dissolve = [UIButton buttonWithType:UIButtonTypeCustom];
    [dissolve setFrame:CGRectMake(10.f, CGRectGetMaxY(_addMember.frame) + 20.f, KUIScreenWidth - 20.f, 40.f)];
    
    [dissolve setTitle:@"解散圈子" forState:UIControlStateNormal];
    dissolve.titleLabel.font = KQLSystemFont(15);
    dissolve.layer.borderColor = [UIColor redColor].CGColor;
    dissolve.layer.borderWidth = 1;
    dissolve.layer.cornerRadius = 5;
    [dissolve addTarget:self action:@selector(dismissCircle) forControlEvents:UIControlEventTouchUpInside];
    [dissolve setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self.view  addSubview:dissolve];
    
    //刚创建的圈子或成员少于2的圈子，不允许解散
    if (_detailType == CircleDetailTypeDefault) {
        dissolve.hidden = YES;
    }
}

// 分享
- (void)shareBarButton{
    UIButton *rightButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"分享" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0 , 0, 50.f, 30.f);
    [rightButton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    UIBarButtonItem  *rightItem = [[UIBarButtonItem  alloc]  initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    RELEASE_SAFE(rightItem);
    
}
// 分享事件
- (void)shareClick{
    PopShareView *shareView = [PopShareView defaultExample];
    [shareView showPopupView:self.navigationController delegate:self shareType:ShareTypeThree];
}

// 申请加入或进入会话
- (void)sessionClick{
    
    if (self.detailType == CircleDetailTypeOtherAccess) {
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(0.f, 10.f, 300.f, 40.f)];
        field.delegate = self;
        field.backgroundColor = [UIColor whiteColor];
        
        [PXAlertView showAlertWithTitle:@"发送验证" message:@"" cancelTitle:@"取消" otherTitle:@"发送" contentView:field alertDelegate:nil completion:^(BOOL cancelled) {}];
        
    }else{
        // 取出圈子成员中前三个人的头像
        int circle_id = [[self.detailDictionary objectForKey:@"circle_id"]intValue];
        circle_member_list_model * cmListGeter = [circle_member_list_model new];
        cmListGeter.where = [NSString stringWithFormat:@"circle_id = %d order by created asc",circle_id];
        NSArray * cmlist = [cmListGeter getList];
        NSMutableArray * porMuArr = [NSMutableArray new];
        
        if (cmlist.count > 0) {
            for (int i = 0; i < cmlist.count; i ++) {
                if (i > 2) {
                    break;
                }
                NSDictionary * dic = [cmlist objectAtIndex:i];
                [porMuArr addObject:[dic objectForKey:@"portrait"]];
            }
        }
        
        NSString *porArrJson = [porMuArr JSONRepresentation];
        RELEASE_SAFE(porMuArr);
        RELEASE_SAFE(cmListGeter);
        
        // 插入会话列表
        chatmsg_list_model *cListGeter = [[chatmsg_list_model alloc]init];
        NSString *whereStr = [NSString stringWithFormat:@"id = %d and talk_type = %d",circle_id,MessageListTypeCircle];
        cListGeter.where =whereStr;
        NSTimeInterval creatTime = [[NSDate date]timeIntervalSince1970];
        NSArray * clist = [cListGeter getList];
        
        TextData *tData = [[TextData alloc]init];
        NSString *dataJson = [NSString getStrWithMessageDatas:tData,nil];
        RELEASE_SAFE(tData);//add vincent
        
        
        if (clist.count == 0) {
            
            NSDictionary * insertDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:circle_id],@"id",
                                        [NSNumber numberWithInt:MessageListTypeCircle],@"talk_type",
                                        porArrJson,@"icon_path",
                                        [self.detailDictionary objectForKey:@"name"],@"title",
                                        [NSNumber numberWithInt:creatTime],@"send_time",
                                        dataJson,@"content",
                                        nil];
            [cListGeter insertDB:insertDic];
        }
        RELEASE_SAFE(cListGeter);
        
        NSString * portraitStr = @"ico_group_circle.png";
        NSArray * portraitArr = [NSArray arrayWithObjects:portraitStr,nil];
        NSNumber * user_id = [NSNumber numberWithInt:[[[Global sharedGlobal]user_id]intValue]
                              ];
        NSDictionary * getDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:circle_id],@"sender_id",
                                 [NSNumber numberWithInt:0],@"messageSum",
                                 [self.detailDictionary objectForKey:@"name"],@"name",
                                 [NSNumber numberWithInt:creatTime],@"time",
                                 @"",@"message",
                                 portraitArr,@"portrait",
                                 [NSNumber numberWithInt:MessageListTypeCircle],@"talk_type",
                                 user_id,@"speaker_id",nil];
        
        SessionViewController * cirSession = [[SessionViewController alloc]init];
        cirSession.selectedDic = getDic;
        cirSession.circleContactsList = self.memberArray;
        
        [self.navigationController pushViewController:cirSession animated:YES];
        RELEASE_SAFE(cirSession);
    }
}

// 添加成员
- (void)addMemberClick{
    
    choicelinkmanViewController* addMemberCtl = [[choicelinkmanViewController alloc] init];
    addMemberCtl.delegate = self;
    addMemberCtl.accessType = AccessPageTypeAddMemberList;
    
    CRNavigationController* crna = [[CRNavigationController alloc] initWithRootViewController:addMemberCtl];
    [self presentViewController:crna animated:YES completion:nil];
    
    //    [self.navigationController pushViewController:addMemberCtl animated:YES];
    RELEASE_SAFE(addMemberCtl);
    RELEASE_SAFE(crna);
}

// 新消息是否通知
- (void)switchAction:(UISwitch *)swh{
    
    if (swh.isOn) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MSGinform"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MSGinform"];
    }
    
}

//退出圈子
-(void) quitCircle{
    NSLog(@"退出圈子");
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出这个圈子么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = QuitCircleAlert;
    [alert show];
    
//    int talk_type = [[self.detailDictionary objectForKey:@"talk_type"]intValue];
//    NSDictionary* headDic = nil;
//    if (talk_type == MessageListTypeCircle) {
//        headDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                            [self.detailDictionary objectForKey:@"circle_id"],@"circle_id",
//                            [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
//                            nil];
//        
//        [[TcpRequestHelper shareTcpRequestHelperHelper] sendQuitCircleMessage:headDic];
//        
//    }else if (talk_type == MessageListTypeTempCircle) {
//        headDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                   [self.detailDictionary objectForKey:@"temp_circle_id"],@"temp_circle_id",
//                   [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
//                   nil];
//        
//        [[TcpRequestHelper shareTcpRequestHelperHelper] sendQuitTempCircleMessage:headDic];
//    }
}

-(void) quitCircleNotify:(NSNotification*) notify{
    int rcode = [notify.object intValue];
    if (rcode == 0) {
        //在圈子列表中删除该圈子
        circle_list_model* circleMod = [[circle_list_model alloc] init];
        circleMod.where = [NSString stringWithFormat:@"circle_id = %d",[[self.detailDictionary objectForKey:@"circle_id"] intValue]];
        [circleMod deleteDBdata];
        [circleMod release];
        
        chatmsg_list_model* chatMod = [[chatmsg_list_model alloc] init];
        chatMod.where = [NSString stringWithFormat:@"id = %d",[[self.detailDictionary objectForKey:@"circle_id"] intValue]];
        [chatMod deleteDBdata];
        [chatMod release];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [Common checkProgressHUD:@"退出圈子失败" andImage:nil showInView:self.view];
    }
}

-(void) quitTempCircleNotify:(NSNotification*) notify{
    NSDictionary * resuiltDic = [notify object];
    if ([[resuiltDic objectForKey:@"recode"]intValue] == 0) {
        //在圈子列表中删除该圈子
//        temporary_circle_list_model* tempCircleMod = [[temporary_circle_list_model alloc] init];
//        tempCircleMod.where = [NSString stringWithFormat:@"temp_circle_id = %d",[[self.detailDictionary objectForKey:@"temp_circle_id"] intValue]];
//        [tempCircleMod deleteDBdata];
//        [tempCircleMod release];
//        
//        chatmsg_list_model* chatMod = [[chatmsg_list_model alloc] init];
//        chatMod.where = [NSString stringWithFormat:@"id = %d",[[self.detailDictionary objectForKey:@"id"] intValue]];
//        [chatMod deleteDBdata];
//        [chatMod release];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [Common checkProgressHUD:@"退出圈子失败" andImage:nil showInView:self.view];
    }
}

// 解散圈子
- (void)dismissCircle{
    NSLog(@"解散");
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要解散这个圈子么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = DissolveCircleAlert;
    [alert show];
    
//    int talk_type = [[self.detailDictionary objectForKey:@"talk_type"]intValue];
//    long long userID = [[[Global sharedGlobal]user_id]longLongValue];
//    long long circleID = [[self.detailDictionary objectForKey:@"circle_id"]longLongValue];
//    
//    if (talk_type == MessageListTypeTempCircle) {
//        TemporaryCircleManager * tempCirclemanager = [TemporaryCircleManager new];
//        tempCirclemanager.fatherDelegate = self;
//        [tempCirclemanager dismissTempCircleWithUserID:userID andTempCircleID:circleID];
//    
//    } else {
//        CircleManager * manager = [CircleManager new];
//        manager.fatherDelegate = self;
//        [manager dismissCircleWithUserID:userID andCircleID:circleID];
//    }
}

#pragma mark - AlertViewDelegate

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        switch (alertView.tag) {
            case QuitCircleAlert:
            {
                int talk_type = [[self.detailDictionary objectForKey:@"talk_type"]intValue];
                NSDictionary* headDic = nil;
                if (talk_type == MessageListTypeCircle) {
                    headDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               [self.detailDictionary objectForKey:@"circle_id"],@"circle_id",
                               [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                               nil];
                    
                    [[TcpRequestHelper shareTcpRequestHelperHelper] sendQuitCircleMessage:headDic];
                }else if (talk_type == MessageListTypeTempCircle) {
                    headDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               [self.detailDictionary objectForKey:@"temp_circle_id"],@"temp_circle_id",
                               [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                               nil];
                    
                    [[TcpRequestHelper shareTcpRequestHelperHelper] sendQuitTempCircleMessage:headDic];
                }
            
            }
                break;
            case DissolveCircleAlert:
            {
                int talk_type = [[self.detailDictionary objectForKey:@"talk_type"]intValue];
                long long userID = [[[Global sharedGlobal]user_id]longLongValue];
                long long circleID = [[self.detailDictionary objectForKey:@"circle_id"]longLongValue];
                
                if (talk_type == MessageListTypeTempCircle) {
                    TemporaryCircleManager * tempCirclemanager = [TemporaryCircleManager new];
                    tempCirclemanager.fatherDelegate = self;
                    [tempCirclemanager dismissTempCircleWithUserID:userID andTempCircleID:circleID];
                    
                } else {
                    CircleManager * manager = [CircleManager new];
                    manager.fatherDelegate = self;
                    [manager dismissCircleWithUserID:userID andCircleID:circleID];
                }
            }
                break;
            default:
                break;
        }
    }
}

// 退出会话
- (void)exitDailogueClick
{
    NSLog(@"退出");
    [self quitCircle];
}


//创建成功
- (void)createSuccessReminder{
    UIView *bgReminder = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 55.f)];
    
    UIImageView *iconV = [[UIImageView alloc]initWithFrame:CGRectMake(110.f, 15.f, 20.f, 20.f)];
    iconV.image = [[ThemeManager shareInstance] getThemeImage:@"ico_landing_correct.png"];
    
    [bgReminder addSubview:iconV];
    
    UILabel *remiderT = [[UILabel alloc]init];
    remiderT.frame = CGRectMake(135.f, 10.f, 120.f, 30.f);
    remiderT.text = @"创建成功";
    remiderT.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    
    [bgReminder addSubview:remiderT];
    
    [self.view addSubview:bgReminder];
    
    RELEASE_SAFE(remiderT);
    RELEASE_SAFE(iconV);
    RELEASE_SAFE(bgReminder);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotiQuitCircle object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotiQuitTempCircle object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateCircleName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateCircleIntro" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"inviteJoinSuccess" object:nil];
    [super dealloc];
}

#pragma mark -
- (void)createCircleSuccess{
    
}

#pragma mark - choiceLMDelegate
// 邀请成员加入圈子
- (void)sureAddMember:(NSArray *)selectMember{
    NSLog(@"selectMember==%@",selectMember);
    
    int talk_type = [[self.detailDictionary objectForKey:@"talk_type"]intValue];
    if (talk_type == MessageListTypeTempCircle) {
        TemporaryCircleManager * tcManager = [TemporaryCircleManager new];
        tcManager.tempdelegate = self;
        NSMutableArray * memberArr = [NSMutableArray arrayWithArray:selectMember];
        tcManager.memberArr = memberArr;
        tcManager.tempCircleID = [[self.detailDictionary objectForKey:@"circle_id"]longLongValue];
        [tcManager addMemberFromMemberArr];
    } else {
        [CircleManager inviteOtherJoinCircleWithCircleDic:self.detailDictionary andOthers:selectMember];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // 创建圈子未添加成员详情
    if (self.detailType == CircleDetailTypeDefault) {
        if (self.isTurnToListView) {
            return 2;
        }else{
            return 3;
        }
        // 进入不是自己创建的圈子详情
    }else if(self.detailType == CircleDetailTypeOtherAccess )
    {
        return 2;
        // 进入自己创建的有成员圈子详情
    }else if(self.detailType == CircleDetailTypeSelfAccess || self.detailType == CircleDetailTypeTempDialogue){
        return 4;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20.f;
    }else if (section == 1){
        return 50.f;
    }else{
        return 20.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 70.f;
        }else{
            return 45.f;
        }
        
    }else{
        return 44.f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if (self.detailType == CircleDetailTypeTempDialogue) {
                return 2;
            } else{
                return 3;
            }
        }
            break;
        case 1:
        {
            if (self.detailType == CircleDetailTypeOtherAccess) {
                return 1;
            }
            return 2;
        }
            break;
        case 2:
        {
            return 1;
        }
            break;
        case 3:
        {
            return 3;
        }
            break;
        default:
            break;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    if (section == 1) {
        label.frame = CGRectMake(10.f, 10.f, 200.f, 30.f);
        label.text = [NSString stringWithFormat: @"  圈子人数：(%d/50)",self.memberArray.count];
        //        label.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        label.textColor = COLOR_GRAY2;
        label.font = KQLSystemFont(15);
        
    }else{
        label.frame = CGRectMake(0.f, 0.f, KUIScreenWidth, 20.f);
    }
    return [label autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *DetailCell = @"topCell";
            CircleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCell];
            if (nil == cell) {
                cell = [[[CircleDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCell]autorelease];
                cell.backgroundView.backgroundColor = [UIColor whiteColor];
                
                if (self.detailType == CircleDetailTypeOtherAccess) {
                    if (indexPath.row ==0 || indexPath.row ==1) {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }else{
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                    
                }else if (self.detailType == CircleDetailTypeTempDialogue){
                    
                    if (indexPath.row == 1){
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }else{
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                    
                    
                }else{
                    if (indexPath.row == 2){
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }else{
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                }
                
            }
            
            //add temprary dailogue logic 0504 Snail
            if (self.detailType == CircleDetailTypeTempDialogue) {
                if (indexPath.row == 0) {
                  
                    cell.qTextLabel.text = @"会话名称";
                    cell.qValueLabel.text = [self.detailDictionary objectForKey:@"name"];
                    
                    self.nameFeild = cell.qValueLabel;
                    
                    [cell setCellType:CellTypeLabel];
                }
                if (indexPath.row == 1) {
                    cell.qTextLabel.text = @"创建人";
                    cell.qValueLabel.text = [self.detailDictionary objectForKey:@"creater_name"];
                    [cell setCellType:CellTypeLabel];
                    self.introFeild = cell.qValueLabel;
                }
            } else{
                
                if (indexPath.row == 0) {
                    cell.qTextLabel.text = @"圈子名称";
                    cell.qValueLabel.text = [self.detailDictionary objectForKey:@"name"];
                    self.nameFeild = cell.qValueLabel;
                    
                    [cell setCellType:CellTypeLabel];
                    
                }else if (indexPath.row == 1){
                    
                    cell.qTextLabel.text = @"介绍";
                    cell.qValueLabel.text =  [self.detailDictionary objectForKey:@"content"];
                    [cell setCellType:CellTypeLabel];
                    self.introFeild = cell.qValueLabel;
                    
                }
                else if (indexPath.row == 2){
                    
//                    login_info_model *userInfo = [[login_info_model alloc]init];
//                    NSArray *userArry = [[userInfo getList]mutableCopy];
//                    RELEASE_SAFE(userInfo);
                    
                    cell.qTextLabel.text = @"创建人";
                    
                    cell.qValueLabel.text = [self.detailDictionary objectForKey:@"creater_name"];
                    
                    //动态计算字符串宽度
                    CGSize titleSize = [cell.qValueLabel.text sizeWithFont:KQLSystemFont(15) constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
                    
                    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(KUIScreenWidth - titleSize.width - 70, 5.f, 30.f, 30.f)];
                    headImage.backgroundColor = [UIColor clearColor];
                    headImage.layer.cornerRadius = 15;
                    headImage.clipsToBounds = YES;
//                    if (userArry.count !=0) {
//                        NSURL *imgUrl = [NSURL URLWithString:[[userArry objectAtIndex:0] objectForKey:@"portrait"]];
//                        [headImage setImageWithURL:imgUrl placeholderImage:IMGREADFILE(@"ico_group_portrait_88.png")];
//                    }
                    [headImage setImageWithURL:[NSURL URLWithString:[self.detailDictionary objectForKey:@"portrait"]] placeholderImage:IMGREADFILE(@"ico_group_portrait_88.png")];
                    
                    [cell.contentView addSubview:headImage];
                    RELEASE_SAFE(headImage);//add vincent
                    
                    [cell setCellType:CellTypeLabel];
                    
                }
                //                else{
                //
                //                    cell.qTextLabel.text = @"二维码";
                //                    cell.qIconImage.image = IMGREADFILE(@"icon_code_default.png");
                //                    [cell setCellType:CellTypeImageView];
                //                }
            }
            
            return cell;
        }
            break;
            
        case 1:
        {
            static NSString *midCell = @"midCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:midCell];
            if (nil == cell) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:midCell]autorelease];
                if(IOS_VERSION_7){
                    [_detailTable setSeparatorInset:UIEdgeInsetsZero];
                }
                UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 1.f)];
                line.backgroundColor = RGBACOLOR(242, 244, 246, 1);
                [cell addSubview:line];
                RELEASE_SAFE(line);
            }
            switch (indexPath.row) {
                case 0:
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    for (int i = 0 ; i < self.memberArray.count; i++) {
                        
                        if (i >= 4) {
                            break;
                        }
                        NSLog(@"memberArray==%@==%d",self.memberArray,self.memberArray.count);
                        
                        UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(10.f + 60 * i, 10.f, 50.f, 50.f)];
                        NSURL *urlImg = [NSURL URLWithString:[[self.memberArray objectAtIndex:i]objectForKey:@"portrait"]];
                        [headView setImageWithURL:urlImg placeholderImage:IMGREADFILE(@"ico_group_portrait_88.png")];
                        
                        headView.layer.cornerRadius = 25;
                        headView.clipsToBounds = YES;
                        [cell.contentView addSubview:headView];
                        RELEASE_SAFE(headView); //add vincent
                        
                    }
                }
                    break;
                case 1:
                {
                    cell.textLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.font = KQLSystemFont(15);
                    
                    if (self.memberArray.count < 49) {
                        cell.textLabel.text = @"添加成员";
                        
                    }else{
                        cell.textLabel.text = @"圈子人数已满，人气很旺嘛";
                        // modified by snail 6.3
                        cell.userInteractionEnabled = NO;
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
            
            return cell;
        }
            break;
        case 2:
        {
            if (self.detailType == CircleDetailTypeDefault) {
                static NSString* disCell = @"dissolveCell";
                UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:disCell];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:disCell] autorelease];
                }
                UIButton *dissolve = [UIButton buttonWithType:UIButtonTypeCustom];
                [dissolve setFrame:CGRectMake(10.f, 0.f, KUIScreenWidth - 20.f, 40.f)];
                [dissolve setTitle:@"解散圈子" forState:UIControlStateNormal];
                dissolve.titleLabel.font = KQLSystemFont(15);
                dissolve.layer.borderColor = [UIColor redColor].CGColor;
                dissolve.layer.borderWidth = 1;
                dissolve.layer.cornerRadius = 5;
                [dissolve addTarget:self action:@selector(dismissCircle) forControlEvents:UIControlEventTouchUpInside];
                [dissolve setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                cell.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:dissolve];
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                return cell;
            }else{
                static NSString *bottomCell = @"buttomCell";
                CircleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:bottomCell];
                if (nil == cell) {
                    cell = [[[CircleDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bottomCell]autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.qTextLabel.text = @"新消息通知";
                [cell.qSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                [cell setCellType:CellTypeSwitch];
                
                return cell;
            }
        }
            break;
        case 3:
        {
            static NSString *dissolveCell = @"dissolveCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dissolveCell];
            if (nil == cell) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dissolveCell]autorelease];
                cell.backgroundColor = [UIColor clearColor];
            }
            if (indexPath.row == 0 && self.detailType == CircleDetailTypeSelfAccess) {
                UIButton *dissolve = [UIButton buttonWithType:UIButtonTypeCustom];
                [dissolve setFrame:CGRectMake(10.f, 0.f, KUIScreenWidth - 20.f, 44.f)];
                [dissolve setTitle:@"解散圈子" forState:UIControlStateNormal];
                dissolve.titleLabel.font = KQLSystemFont(15);
                dissolve.layer.borderColor = [UIColor redColor].CGColor;
                dissolve.layer.borderWidth = 1;
                dissolve.layer.cornerRadius = 5;
//                [dissolve addTarget:self action:@selector(dismissCircle) forControlEvents:UIControlEventTouchUpInside];
                [dissolve setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [cell.contentView addSubview:dissolve];
                
                if ([[_detailDictionary objectForKey:@"creater_id"] intValue] != [[Global sharedGlobal].user_id intValue]) {
                    [dissolve setTitle:@"退出圈子" forState:UIControlStateNormal];
                    dissolve.tag = QuitCircleAlert;
                    [dissolve addTarget:self action:@selector(quitCircle) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    dissolve.tag = DissolveCircleAlert;
                    [dissolve addTarget:self action:@selector(dismissCircle) forControlEvents:UIControlEventTouchUpInside];
                }
                
            }
            
            if (indexPath.row == 0 && self.detailType == CircleDetailTypeTempDialogue) {
                UIButton *exiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [exiteButton setFrame:CGRectMake(10.0f, 0.0f, KUIScreenWidth - 20.0f, 44.0f)];
                [exiteButton setTitle:@"退出圈子" forState:UIControlStateNormal];
                exiteButton.titleLabel.font = KQLSystemFont(15);
                exiteButton.layer.borderColor = [UIColor redColor].CGColor;
                exiteButton.layer.borderWidth = 1;
                exiteButton.layer.cornerRadius = 5;
//                [exiteButton addTarget:self action:@selector(exitDailogueClick) forControlEvents:UIControlEventTouchUpInside];
                [exiteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [cell.contentView addSubview:exiteButton];
                
                if ([[_detailDictionary objectForKey:@"creater_id"] intValue] == [[Global sharedGlobal].user_id intValue]) {
                    [exiteButton setTitle:@"解散圈子" forState:UIControlStateNormal];
                    exiteButton.tag = DissolveCircleAlert;
                    [exiteButton addTarget:self action:@selector(dismissCircle) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    exiteButton.tag = QuitCircleAlert;
                    [exiteButton addTarget:self action:@selector(quitCircle) forControlEvents:UIControlEventTouchUpInside];
                }
                
            }
            
            return cell;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:// 圈子名称
                {
                    if ([[self.detailDictionary objectForKey:@"creater_id"] intValue] != [[Global sharedGlobal].user_id intValue]) {
                        return;
                    }
                    if (self.detailType != CircleDetailTypeOtherAccess) {
                        ModifyCircleNameViewController *modifyCtl = [[ModifyCircleNameViewController alloc]init];
                        
                        modifyCtl.detailDictionary = self.detailDictionary;
                        [self.navigationController pushViewController:modifyCtl animated:YES];
                        RELEASE_SAFE(modifyCtl);
                    }
                    
                }
                    break;
                    
                case 1://介绍
                {
                    if ([[self.detailDictionary objectForKey:@"creater_id"] intValue] != [[Global sharedGlobal].user_id intValue]) {
                        return;
                    }
                    if (self.detailType == CircleDetailTypeTempDialogue) {
                        return;
                    }
                    if (self.detailType != CircleDetailTypeOtherAccess) {
                        
                        ModifyIntroduceViewController *introCtl = [[ModifyIntroduceViewController alloc]init];
                        introCtl.detailDictionary = self.detailDictionary;
                        [self.navigationController pushViewController:introCtl animated:YES];
                        RELEASE_SAFE(introCtl);
                    }
                }
                    break;
                case 2://创建人
                {
                    if ([[self.detailDictionary objectForKey:@"creater_id"] intValue] != [[Global sharedGlobal].user_id intValue]) {
                        MemberMainViewController *memberMainView = [[MemberMainViewController  alloc] init];
//                        memberMainView.pushType = PushTypesLeft;
                        memberMainView.pushType = PushTypesButtom;
                        memberMainView.accessType = AccessTypeLookOther;
                        memberMainView.lookId = [[self.detailDictionary objectForKey:@"creater_id"] intValue];
//                        [self.navigationController pushViewController:memberMainView animated:YES];
//                        [self presentViewController:memberMainView animated:YES completion:nil];
                        CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberMainView];
                        [self.navigationController presentModalViewController:nav animated:YES];
                        RELEASE_SAFE(nav);
                        RELEASE_SAFE(memberMainView);
                    }
                }
                    break;
                case 3://二维码
                {
                    CircleQrCodeViewController *qrCode = [[CircleQrCodeViewController alloc]init];
                    qrCode.qrCodeType = 1;
                    
                    [self.navigationController pushViewController:qrCode animated:YES];
                    
                    RELEASE_SAFE(qrCode);
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        case 1:
        {
            if (indexPath.row == 0) {
                //  圈子成员
                
                
                GroupViewController *groupCtl = [[GroupViewController alloc]init];
                groupCtl.listType = MemberlistTypeCircle;
                groupCtl.circleId = [[self.detailDictionary objectForKey:@"circle_id"] intValue];
                groupCtl.circleDic = self.detailDictionary;
                
                groupCtl.enterFromDetail = YES;
                
                if ([self.detailDictionary objectForKey:@"circleContactsList"]!= nil) {
                    groupCtl.circleArr = [self.detailDictionary objectForKey:@"circleContactsList"];
                }else{
                    circle_member_list_model* circleMemMod = [[circle_member_list_model alloc] init];
                    circleMemMod.where = [NSString stringWithFormat:@"circle_id = %d",[[self.detailDictionary objectForKey:@"circle_id"] intValue]];
                    groupCtl.circleArr = [circleMemMod getList];
                    [circleMemMod release];
                }
                [self.navigationController pushViewController:groupCtl animated:YES];
                RELEASE_SAFE(groupCtl);
                
            }else if (indexPath.row == 1){
                // 添加圈子成员
                [self addMemberClick];
                
            }
        }
            break;
        case 2://新消息通知
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - CircleManagerDelegate

- (void)dismissCircleSuccess:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    RELEASE_SAFE(sender);
}

- (void)removeMemberSucess:(id)sender
{
    
}

#pragma mark - TempCircleManagerDelegate

- (void)addMemberSuccessWithSender:(id)sender CircleID:(long long)circleID
{
    RELEASE_SAFE(sender);
}

#pragma mark - accessService

- (void)accessService{
    
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:MEMBER_INVITED_COMMAND_ID accessAdress:@"" delegate:self withParam:nil];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    
	NSLog(@"information finish");
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        
        int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
        NSLog(@"resultInt=%d",resultInt);
        switch (commandid) {
            case MEMBER_INVITED_COMMAND_ID:
            {
                if (resultInt == 0) {
                    
                    [self performSelectorOnMainThread:@selector(getCodeError) withObject:nil waitUntilDone:NO];
                    
                }else if(resultInt == 1){
                    
                    [self performSelectorOnMainThread:@selector(getCodeSuccess) withObject:nil waitUntilDone:NO];
                }
            }break;
                
            default:
                break;
        }
        
    }else{
        
        UIImage *img = [UIImage imageCwNamed:@"icon_tip_normal.png"];
        
        if ([Common connectedToNetwork]) {
            // 网络繁忙，请重新再试
            [Common checkProgressHUD:@"当前网络不可用，请检查你的网络设置" andImage:img showInView:self.view];
        } else {
            // 当前网络不可用，请重新再试
            
            [Common checkProgressHUD:KCWNetNOPrompt andImage:img showInView:self.view];
        }
        
    }
}

- (void)getCodeError{
    
}


- (void)getCodeSuccess{
    
}

@end
