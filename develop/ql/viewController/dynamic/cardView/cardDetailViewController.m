//
//  cardDetailViewController.m
//  ql
//
//  Created by yunlai on 14-4-16.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "cardDetailViewController.h"
#import "MemberDetailViewController.h"
#import "MemberMainViewController.h"

#import "Common.h"

#import "imageBrowser.h"
#import "commentView.h"
#import "responsePopView.h"

#import "MemberMainViewController.h"

#import "MessageData.h"
#import "MessageDataManager.h"
#import "TcpRequestHelper.h"
#import "ChatTcpHelper.h"
#import "TextData.h"

#import "browserViewController.h"
#import "CRNavigationController.h"
#import "dynamic_card_model.h"

#import "aboutMeMsgListViewController.h"

#import "wantHaveData.h"
#import "wantHaveInfoCell.h"

#import "TogetherData.h"

#import "mainpage_newpublish_model.h"
#import "mainpage_supplydemand_model.h"
#import "mianpage_company_dynamic_model.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "TemporaryCircleManager.h"
#import "circle_contacts_model.h"
#import "temporary_circle_member_list_model.h"

@interface cardDetailViewController ()<commentDelegate,responsePopDelegate,TcpRequestHelperDelegate,TemporaryCircleManagerDelegate>{
    NSMutableArray* _images;
    
    DynamicCardView* cardV;
    
    MessageDataManager* dataManager;
    
    //回应的内容
    NSString* messageTxt;
    
    UIButton* joinBtn;
}

@property(nonatomic,retain) UILabel* redCircleView;

@end

@implementation cardDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _images = [[NSMutableArray alloc] init];
        
        _enterFromDYList = YES;
    }
    return self;
}

//更新回应数字
-(void) updateResponseNum:(NSNotification*) notify{
    [cardV changeResponseNum:[notify.object intValue]];
}

-(void) viewWillAppear:(BOOL)animated{
    if (_detailType == DynamicDetailTypeAll) {
        [self cdDynamicAboutMeNotice:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cdDynamicAboutMeNotice:) name:@"dynamicAboutMeNotice" object:nil];
    }
    
    //注册回应成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedMessageSendWithDic:) name:@"messageSendSuccess" object:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dynamicAboutMeNotice" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"messageSendSuccess" object:nil];
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateResponseNum" object:nil];
    
    //注册更新回应数字通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateResponseNum:) name:@"updateResponseNum" object:nil];
    
    [super viewDidLoad];
    
    if (IOS_VERSION_7) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    //设置title
    [self setTheTitleWithType];
    //初始化导航
    [self initNavBarItem];
    //初始化卡片
    [self initCardView];
	// Do any additional setup after loading the view.
}

//设置title
-(void) setTheTitleWithType{
    NSString* title = nil;
    
    switch (_type) {
        case CardImage:
            title = @"图文";
            break;
        case CardLabel:
            title = @"图文";
            break;
        case CardNews:
            title = @"组织";
            break;
        case CardOOXX:
            title = @"OOXX";
            break;
        case CardTogether:
            title = @"聚聚";
            break;
        case CardWantOrHave:
            title = @"供需";
            break;
        default:
            break;
    }
    self.navigationItem.title = title;
}

//初始化导航条
-(void) initNavBarItem{
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
    
    if (_detailType == DynamicDetailTypeAll) {
        
        UIView* rightBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 60, 44)];
        
        UIButton *rightButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        rightButton.backgroundColor = [UIColor clearColor];
        [rightButton addTarget:self action:@selector(aboutMeList) forControlEvents:UIControlEventTouchUpInside];
        
        rightButton.frame = CGRectMake(15, 7, 40.f, 30.f);
        [rightBarView addSubview:rightButton];
        [rightButton setTitle:@"@我" forState:UIControlStateNormal];
        [rightButton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
        
        _redCircleView = [[UILabel alloc] init];
        _redCircleView.frame = CGRectMake(46, 0, 20, 15);
        _redCircleView.layer.cornerRadius = _redCircleView.bounds.size.height/2;
        [_redCircleView.layer setMasksToBounds:YES];
        _redCircleView.font = KQLSystemFont(10);
        _redCircleView.textAlignment = NSTextAlignmentCenter;
        _redCircleView.backgroundColor = [UIColor redColor];
        _redCircleView.text = [NSString stringWithFormat:@"%d",[Global sharedGlobal].dyMe_unread_num];
        [rightBarView addSubview:_redCircleView];
        
        if ([_redCircleView.text intValue] > 0) {
            _redCircleView.hidden = NO;
        }else{
            _redCircleView.hidden = YES;
        }
        
        //不是从动态列表进入，则不需要@我
        if (!_enterFromDYList) {
            rightBarView.hidden = YES;
        }
        
        UIBarButtonItem  *rightItem = [[UIBarButtonItem  alloc]  initWithCustomView:rightBarView];
        self.navigationItem.rightBarButtonItem = rightItem;
        RELEASE_SAFE(rightItem);
        
        RELEASE_SAFE(rightBarView);
        
    }else if (_detailType == DynamicDetailTypeMine || _detailType == DynamicDetailTypeWantHave) {
        
        UIButton* editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        editButton.backgroundColor = [UIColor clearColor];
        editButton.frame = CGRectMake(0, 30, 30, 30);
        editButton.titleLabel.font = KQLboldSystemFont(14);
        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [editButton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editMyDynamic) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* editItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
        self.navigationItem.rightBarButtonItem = editItem;
        
        RELEASE_SAFE(editItem);
    }
    
}

//@我通知
-(void) cdDynamicAboutMeNotice:(NSNotification*) notify{
    if ([Global sharedGlobal].dyMe_unread_num > 99) {
        _redCircleView.text = @"99+";
    }else{
        _redCircleView.text = [NSString stringWithFormat:@"%d",[Global sharedGlobal].dyMe_unread_num];
    }
    
    if ([Global sharedGlobal].dyMe_unread_num == 0) {
        _redCircleView.hidden = YES;
    }else{
        _redCircleView.hidden = NO;
    }
    
}

//@我
-(void) aboutMeList{
    [Global sharedGlobal].dyMe_unread_num = 0;
    _redCircleView.hidden = YES;
    
    aboutMeMsgListViewController* aboutMeVC = [[aboutMeMsgListViewController alloc] init];
    [self.navigationController pushViewController:aboutMeVC animated:YES];
    [aboutMeVC release];
}

//编辑
-(void) editMyDynamic{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
    [sheet release];
}

#pragma mark - actionsheet
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self accessDeleteDynamic];
    }
}

-(void) backTo{
    [self.navigationController popViewControllerAnimated:NO];
}

//初始化卡片视图
-(void) initCardView{
    NSLog(@"==_type:%d\n_dataDic:%@==",_type,_dataDic);
    //data数据来自dataDic，DynamicMain传过来
    CGRect cardVRect;
    if (IOS_VERSION_7) {
        cardVRect = CGRectMake(0, 0, 320, self.view.bounds.size.height - 64);
    }else{
        cardVRect = CGRectMake(0, 0, 320, self.view.bounds.size.height - 44);
    }
    cardV = [[DynamicCardView alloc] initWithCardType:_type data:_dataDic frame:cardVRect showType:CardShowTypeAll];
    cardV.delegate = self;
    [self.view addSubview:cardV];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray* pics = [[_dataDic objectForKey:@"pics"] componentsSeparatedByString:@","];
        if ([[pics lastObject] isKindOfClass:[NSString class]]) {
            for (NSString* url in pics) {
                [_images addObject:url];
            }
        }else if ([[pics lastObject] isKindOfClass:[UIImage class]]) {
            for (UIImage* image in pics) {
                if (image) {
                    [_images addObject:image];
                }
            }
        }
        
    });
}

//头像
-(void) userImageTouch{
    NSLog(@"====userImage touch====");
    MemberMainViewController* memberVC = [[MemberMainViewController alloc] init];
    memberVC.lookId = [[_dataDic objectForKey:@"user_id"] intValue];
//    memberVC.accessType = AccessTypeLookOther;
    //        add vincent
    if (memberVC.lookId == [[Global sharedGlobal].user_id longLongValue] ) {
        memberVC.accessType = AccessTypeSelf;
    }else{
        memberVC.accessType = AccessTypeLookOther;
    }
    memberVC.pushType = PushTypeButtom;
//    [self presentViewController:memberVC animated:YES completion:nil];
    CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberVC];
    [self.navigationController presentModalViewController:nav animated:YES];
    RELEASE_SAFE(nav);
    RELEASE_SAFE(memberVC);
}

//大图
-(void) middleImageTouch:(UIImageView*) imageView{
//    imageBrowser* browser = [[imageBrowser alloc] initWithPhotoList:_images];
//    browser.currentIndex = cardV.pageCtl.currentPage;
//    [browser showWithAnimation:YES];
//    [browser release];
    
    NSArray* pics = [[_dataDic objectForKey:@"pics"] componentsSeparatedByString:@","];;
    
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[pics count] ];
    for (int i = 0; i < [pics count]; i++) {
        // 替换为中等尺寸图片
        
        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [pics objectAtIndex:i]];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString: getImageStrUrl ]; // 图片路径
        
        photo.srcImageView = imageView;
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = cardV.pageCtl.currentPage; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    [browser release];
}

-(void) responseLabTouch{
    commentView* _comV = [[commentView alloc] init];
    _comV.fromType = CommentFromTypeCom;
    if ([[_dataDic objectForKey:@"type"] intValue] ==1) {
        _comV.comType = CommentTypeOOXX;
    }
    _comV.comeBtnType = 1;
    [_comV initWithData:_dataDic publishId:[[_dataDic objectForKey:@"id"] intValue]];
    _comV.delegate = self;
    [_comV showCommentView];
    [_comV release];
}

//评论
-(void) commentButtonClick{
    commentView* _comV = [[commentView alloc] init];
    _comV.fromType = CommentFromTypeCom;
    if ([[_dataDic objectForKey:@"type"] intValue] ==1) {
        _comV.comType = CommentTypeOOXX;
    }
    [_comV initWithData:_dataDic publishId:[[_dataDic objectForKey:@"id"] intValue]];
    _comV.delegate = self;
    [_comV showCommentView];
    [_comV release];
}

//新闻链接跳转
-(void) fullTextToWeb:(NSString *)url{
    //web
    browserViewController* browserVC = [[browserViewController alloc] init];
    browserVC.url = url;
    [self.navigationController pushViewController:browserVC animated:YES];
    
    RELEASE_SAFE(browserVC);
}

#pragma mark - commentDelegate

#define WANTPROMPT @"你好，我很有兴趣"
#define HAVEPROMPT @"你好，我对你的需求很有兴趣"
#define FREEPROMPT @"我要参加这个聚聚"
#define YOURSELFSEND @"这是您发的供需.."

//want按钮点击
-(void) wantButtonClick{
    NSLog(@"==I want==");
    if ([[_dataDic objectForKey:@"user_id"] intValue] != [[Global sharedGlobal].user_id intValue]) {
        responsePopView* resPopV = [[responsePopView alloc] init];
        resPopV.delegate = self;
        resPopV.resLab.text = [NSString stringWithFormat:@"回应%@",[_dataDic objectForKey:@"realname"]];
        resPopV.textview.text = WANTPROMPT;
        [resPopV showResPop];
        [resPopV release];
    }else{
        [Common checkProgressHUD:YOURSELFSEND andImage:nil showInView:self.view];
    }

}

//have按钮点击
-(void) haveButtonClick{
    NSLog(@"==I have==");
    if ([[_dataDic objectForKey:@"user_id"] intValue] != [[Global sharedGlobal].user_id intValue]) {
        responsePopView* resPopV = [[responsePopView alloc] init];
        resPopV.delegate = self;
        resPopV.resLab.text = [NSString stringWithFormat:@"回应%@",[_dataDic objectForKey:@"realname"]];
        resPopV.textview.text = HAVEPROMPT;
        [resPopV showResPop];
        [resPopV release];
    }else{
        [Common checkProgressHUD:YOURSELFSEND andImage:nil showInView:self.view];
    }
    
}

//参加按钮点击
-(void) joinButtonClick:(UIButton*) btn{
    joinBtn = btn;
    
    NSLog(@"==I Join==");
    if ([[_dataDic objectForKey:@"user_id"] intValue] != [[Global sharedGlobal].user_id intValue]) {
        responsePopView* resPopV = [[responsePopView alloc] init];
        resPopV.delegate = self;
        resPopV.resLab.text = [NSString stringWithFormat:@"回应%@",[_dataDic objectForKey:@"realname"]];
        resPopV.textview.text = FREEPROMPT;
        [resPopV showResPop];
        [resPopV release];
    }else{
        [Common checkProgressHUD:YOURSELFSEND andImage:nil showInView:self.view];
    }
}

//回应按钮点击
-(void) responseButtonClick{
    NSLog(@"==I am free==");
    responsePopView* resPopV = [[responsePopView alloc] init];
    resPopV.delegate = self;
    resPopV.resLab.text = @"我也有空";
    resPopV.textview.text = FREEPROMPT;
    [resPopV showResPop];
    [resPopV release];
}

//头像点击
-(void) headViewTouch:(int)userId{
    MemberMainViewController* memberVC = [[MemberMainViewController alloc] init];
    memberVC.lookId = userId;
//    memberVC.accessType = AccessTypeLookOther;
    memberVC.pushType = PushTypesButtom;
    if (memberVC.lookId == [[Global sharedGlobal].user_id longLongValue] ) {
        memberVC.accessType = AccessTypeSelf;
    }else{
        memberVC.accessType = AccessTypeLookOther;
    }
    
    CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    RELEASE_SAFE(nav);
    RELEASE_SAFE(memberVC);
}

//加入临时会话
-(void) joinTempCircle:(long long) circleId{
    //查询到自己
    circle_contacts_model* contactMod = [[circle_contacts_model alloc] init];
    contactMod.where = [NSString stringWithFormat:@"user_id = %d",[[Global sharedGlobal].user_id intValue]];
    NSArray* arr = [contactMod getList];
    [contactMod release];
    
    //加入到制定临时圈子
    TemporaryCircleManager* circleManager = [[TemporaryCircleManager alloc] init];
    circleManager.tempdelegate = self;
    circleManager.memberArr = arr;
    circleManager.tempCircleID = circleId;
    [circleManager addMemberFromMemberArr];
}

#pragma mark - tempCircleManager
-(void) addMemberSuccessWithSender:(id)sender CircleID:(long long)circleID{
    //加入成功后，向临时会话发送消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendMessageToTemporaryCircle:) name:kNotiUpdateTempCircleInfo object:nil];
    [sender release];
}

- (void)sendMessageToTemporaryCircle:(NSNotification *)nofity
{
    if (messageTxt != nil && messageTxt.length > 0) {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotiUpdateTempCircleInfo object:nil];
        NSArray * temporayArr = nofity.object;
        NSDictionary * resultDic = [temporayArr firstObject];
        NSDictionary * temporayInfoDic = [resultDic objectForKey:@"circle"];
        NSNumber * tempID = [temporayInfoDic objectForKey:@"id"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self sendTempCircleMsg:messageTxt circleId:tempID.longLongValue];

        });
        
    }
}

//向对应临时会话发消息
-(void) sendTempCircleMsg:(NSString*) msg circleId:(long long) circleId{
    NSTimeInterval timeInt = [[NSDate date]timeIntervalSince1970];
    
    TogetherData* tData = [[TogetherData alloc] init];
    tData.ID = [[_dataDic objectForKey:@"id"] intValue];
    tData.txt = msg;
    //时间
    NSString* timeStr = [NSString stringWithFormat:@"%@ -- %@\n",[Common makeTime:[[_dataDic objectForKey:@"start_time"] intValue] withFormat:@"MM月dd日 HH:mm"],[Common makeTime:[[_dataDic objectForKey:@"end_time"] intValue] withFormat:@"MM月dd日 HH:mm"]];
    //地址
    NSString* addressStr = [_dataDic objectForKey:@"address"];
    //文本
    NSString* titleStr = [_dataDic objectForKey:@"title"];
    
    NSString* textStr = [NSString stringWithFormat:@"%@ %@ %@",timeStr,addressStr,titleStr];
    
    tData.msgdesc = textStr;
    
    MessageData * textMessageData = [[MessageData alloc] init];
    textMessageData.title = [NSString stringWithFormat:@"%@的聚聚",[_dataDic objectForKey:@"realname"]];
    textMessageData.senderID = [[Global sharedGlobal].user_id intValue];
    //发送消息给临时会话
//    long long circleId = [[_dataDic objectForKey:@"circle_id"] longLongValue];
    if (circleId != 0) {
        textMessageData.receiverID = circleId;
    }
    //测试用
//    long long circleId = 1408603830783486;//有我的
//    long long circleId = 1408606705549441;//没我的
    textMessageData.receiverID = circleId;
    
    textMessageData.sendCommandType = CMD_TEMP_CIRCLE_MSGSEND;
    
    textMessageData.msgtype = kMessageTypeTogether;
    textMessageData.talkType = MessageListTypeTempCircle;
    
    //复职speakinfo
    NSDictionary* speakinfo = [NSDictionary dictionaryWithObjectsAndKeys:
                               [[Global sharedGlobal].userInfo objectForKey:@"realname"],@"nickname",
                               [[Global sharedGlobal].userInfo objectForKey:@"portrait"],@"portrait",
                               [[Global sharedGlobal].userInfo objectForKey:@"realname"],@"realname",
                               [Global sharedGlobal].user_id,@"uid",
                               @"1",@"clienttype",
                               nil];
    textMessageData.speakerinfo = speakinfo;
    
    textMessageData.msgData = tData;
    
    textMessageData.flag = 1;
    textMessageData.sendtime = timeInt;
    
    dataManager = [[MessageDataManager alloc] init];
    [dataManager.dataQueue addObject:textMessageData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [dataManager restoreData:textMessageData];
        
        [[ChatTcpHelper shareChatTcpHelper]connectToHost];
        [TcpRequestHelper shareTcpRequestHelperHelper].delegate = self;
        [[TcpRequestHelper shareTcpRequestHelperHelper]sendMessagePackageCommandId:TCP_TEXTMESSAG_EPERSON_COMMAND_ID andMessageData:textMessageData];
    });
  
    
    [tData release];
    [textMessageData release];
}

//是否加入临时圈子
-(BOOL) isJoinedTempCircle:(long long) circleId{
    temporary_circle_member_list_model* tempMemberMod = [[temporary_circle_member_list_model alloc] init];
    tempMemberMod.where = [NSString stringWithFormat:@"circle_id = %lld and user_id = %lld",circleId,[[Global sharedGlobal].user_id longLongValue]];
    NSArray* memberArr = [tempMemberMod getList];
    
    if (memberArr.count == 0) {
        return NO;
    }else{
        return YES;
    }
    
    return YES;
}

#pragma mark - responsePop
//回应代理
-(void) sureButtonClick:(NSString*) msg{
    
    if ([[msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [Common checkProgressHUDShowInAppKeyWindow:@"内容不能为空" andImage:nil];
        return;
    }
    
    NSTimeInterval timeInt = [[NSDate date]timeIntervalSince1970];
    
    if (_type == CardTogether) {
        messageTxt = [msg copy];
//        long long circleId = 1408606705549441;//没我的
//        [self joinTempCircle:circleId];
        
        //有临时圈子id的时候，走加入临时圈子->向临时圈子发送聚聚消息流程，没有则向聚聚发起人发送聚聚单聊消息
        long long circleId = [[_dataDic objectForKey:@"circle_id"] longLongValue];
        if (circleId != 0) {
            //判断是否已经加入这个临时圈子,如果已经加入，就直接发聚聚消息，没有加入的话，就走加入流程
//            BOOL isJoin = [self isJoinedTempCircle:circleId];
//            if (isJoin) {
//                [self sendTempCircleMsg:msg circleId:circleId];
//            }else{
//                [self joinTempCircle:circleId];
//                
//            }
//            不用了，每个用户只能点参加一次
            
            [self joinTempCircle:circleId];
            
            return;
        }
        
        //聚聚类型
        TogetherData* tData = [[TogetherData alloc] init];
        tData.ID = [[_dataDic objectForKey:@"id"] intValue];
        tData.txt = msg;
        //时间
        NSString* timeStr = [NSString stringWithFormat:@"%@ -- %@\n",[Common makeTime:[[_dataDic objectForKey:@"start_time"] intValue] withFormat:@"MM月dd日 HH:mm"],[Common makeTime:[[_dataDic objectForKey:@"end_time"] intValue] withFormat:@"MM月dd日 HH:mm"]];
        //地址
        NSString* addressStr = [_dataDic objectForKey:@"address"];
        //文本
        NSString* titleStr = [_dataDic objectForKey:@"title"];
        
        NSString* textStr = [NSString stringWithFormat:@"%@ %@ %@",timeStr,addressStr,titleStr];
        
        tData.msgdesc = textStr;
        
        MessageData * textMessageData = [[MessageData alloc] init];
        textMessageData.title = [_dataDic objectForKey:@"realname"];
        textMessageData.senderID = [[Global sharedGlobal].user_id intValue];
        textMessageData.receiverID = [[_dataDic objectForKey:@"user_id"] intValue];
        textMessageData.sendCommandType = CMD_PERSONAL_MSGSEND;
        
        textMessageData.msgtype = kMessageTypeTogether;
        textMessageData.talkType = MessageListTypePerson;
        
        textMessageData.msgData = tData;
        
        textMessageData.flag = 1;
        textMessageData.sendtime = timeInt;
        
        dataManager = [[MessageDataManager alloc] init];
        [dataManager.dataQueue addObject:textMessageData];
        [dataManager restoreData:textMessageData];
        
        [[ChatTcpHelper shareChatTcpHelper]connectToHost];
        [TcpRequestHelper shareTcpRequestHelperHelper].delegate = self;
        [[TcpRequestHelper shareTcpRequestHelperHelper]sendMessagePackageCommandId:TCP_TEXTMESSAG_EPERSON_COMMAND_ID andMessageData:textMessageData];
        
        [tData release];
        [textMessageData release];
        
    }else{
        //我有我要
        wantHaveData* tData = [[wantHaveData alloc] init];
        tData.tbdesc = @" ";
        tData.tburl = @" ";
        tData.ID = [[_dataDic objectForKey:@"id"] intValue];
        tData.txt = msg;
        tData.msgdesc = [_dataDic objectForKey:@"title"];
        
        MessageData * textMessageData = [[MessageData alloc] init];
        textMessageData.title = [_dataDic objectForKey:@"realname"];
        textMessageData.senderID = [[Global sharedGlobal].user_id intValue];
        textMessageData.receiverID = [[_dataDic objectForKey:@"user_id"] intValue];
        textMessageData.sendCommandType = CMD_PERSONAL_MSGSEND;
        
        if (_type == CardOpenTime) {
            textMessageData.msgtype = kMessageTypeOpenTime;
        }else{
            if ([[_dataDic objectForKey:@"type"] intValue] == 3) {
                textMessageData.msgtype = kMessageTypeReplayHave;
                textMessageData.talkType = MessageListTypePerson;
                tData.type = PersonMessageHave;
                textMessageData.msgData = tData;
            }else if ([[_dataDic objectForKey:@"type"] intValue] == 4) {
                textMessageData.msgtype = kMessageTypeReplyWant;
                textMessageData.talkType = MessageListTypePerson;
                tData.type = PersonMessageWant;
                textMessageData.msgData = tData;
            }
        }
        textMessageData.flag = 1;
        textMessageData.sendtime = timeInt;
        
        dataManager = [[MessageDataManager alloc] init];
        [dataManager.dataQueue addObject:textMessageData];
        [dataManager restoreData:textMessageData];
        
        [[ChatTcpHelper shareChatTcpHelper]connectToHost];
        [TcpRequestHelper shareTcpRequestHelperHelper].delegate = self;
        [[TcpRequestHelper shareTcpRequestHelperHelper]sendMessagePackageCommandId:TCP_TEXTMESSAG_EPERSON_COMMAND_ID andMessageData:textMessageData];
        
        [tData release];
        [textMessageData release];
    }
    
}

//回应通知处理
-(void) finishedMessageSendWithDic:(NSNotification *)notify{
    NSDictionary* retDic = notify.object;
    int rcode = [[retDic objectForKey:@"rcode"]intValue];
    
    if (rcode == 0) {
        //        NSLog(@"++回应成功++");
//        [Common checkProgressHUD:@"回应成功" andImage:nil showInView:self.view];
        [Common checkProgressHUDShowInAppKeyWindow:@"回应成功" andImage:KAccessSuccessIMG];
    }else{
//        [Common checkProgressHUD:@"回应失败" andImage:nil showInView:self.view];
        [Common checkProgressHUDShowInAppKeyWindow:@"回应失败" andImage:KAccessFailedIMG];
    }
    
    [self updateDBJoinStatus:rcode];
    
    [self accessJoinCircle];
}

//发送回应请求，目的在于同步数据
-(void) accessJoinCircle{
    [self accessJoinTogether];
}

//更新数据库中参加状态,更新按钮状态,0成功，1失败
-(void) updateDBJoinStatus:(int) status{
    //更新按钮状态
    if (status == 0) {
        joinBtn.backgroundColor = COLOR_GRAY2;
        joinBtn.enabled = NO;
    }else{
        joinBtn.backgroundColor = [UIColor colorWithRed:0.12 green:0.55 blue:0.89 alpha:1.0];
        joinBtn.enabled = YES;
    }
    
    //更新数据库
}

//参加聚聚
-(void) accessJoinTogether{
    NSString* reqUrl = @"publish/gather.do?param=";
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [Global sharedGlobal].org_id,@"org_id",
                                       [Global sharedGlobal].user_id,@"user_id",
                                       [_dataDic objectForKey:@"id"],@"publish_id",
                                       [NSNumber numberWithInt:1],@"status",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_TOGETHER_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

//删除
-(void) accessDeleteDynamic{
    NSString* reqUrl = @"publish/delete.do?param=";
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                       [NSNumber numberWithInt:[[_dataDic objectForKey:@"id"] intValue]],@"publish_id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:MAINPAGE_DELETEDYANMIC_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

//请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    NSLog(@"did finish:%@",resultArray);
    
    switch (commandid) {
        case DYNAMIC_OOXX_COMMAND_ID:
        {
            //ooxx
            if (resultArray && ![[resultArray objectAtIndex:0] isKindOfClass:[NSString class]]) {
                NSDictionary* dic = [resultArray objectAtIndex:0];
                int ret = [[dic objectForKey:@"ret"] intValue];//0失败，1成功，2已投票
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (ret == 1) {
//                        [Common checkProgressHUD:@"投票成功" andImage:nil showInView:self.view];
                        [Common checkProgressHUDShowInAppKeyWindow:@"投票成功" andImage:KAccessSuccessIMG];
                        [_dataDic setValue:[NSNumber numberWithInt:1] forKey:@"is_choice"];
                        
                    }else if (ret == 2) {
//                        [Common checkProgressHUD:@"投过票了" andImage:nil showInView:self.view];
                        [Common checkProgressHUDShowInAppKeyWindow:@"投过票了" andImage:KAccessFailedIMG];
                    }else{
//                        [Common checkProgressHUD:@"投票失败" andImage:nil showInView:self.view];
                        [Common checkProgressHUDShowInAppKeyWindow:@"投票失败" andImage:KAccessFailedIMG];
                    }
                });
            }
        }
            break;
        case MAINPAGE_DELETEDYANMIC_COMMAND_ID:
        {
            //删除
            if (resultArray && ![[resultArray objectAtIndex:0] isKindOfClass:[NSString class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[[resultArray firstObject] objectForKey:@"ret"] intValue] == 1) {
                        [self deleteDynamicSuccess];
                    }else{
//                        [Common checkProgressHUD:@"删除失败" andImage:nil showInView:self.view];
                        [Common checkProgressHUDShowInAppKeyWindow:@"删除失败" andImage:KAccessFailedIMG];
                    }
                });
            }
        }
            break;
        case DYNAMIC_TOGETHER_COMMAND_ID:
        {
            //参加聚聚
            
        }
            break;
        default:
            break;
    }
}

//删除成功处理 删除数据库对应数据
-(void) deleteDynamicSuccess{
    dynamic_card_model* cardMod = [[dynamic_card_model alloc] init];
    cardMod.where = [NSString stringWithFormat:@"id = %d",[[_dataDic objectForKey:@"id"] intValue]];
    [cardMod deleteDBdata];
    [cardMod release];
    
    mainpage_newpublish_model* mainPubMod = [[mainpage_newpublish_model alloc] init];
    mainPubMod.where = [NSString stringWithFormat:@"id = %d",[[_dataDic objectForKey:@"id"] intValue]];
    [mainPubMod deleteDBdata];
    [mainPubMod release];
    
    mainpage_supplydemand_model* mainSupMod = [[mainpage_supplydemand_model alloc] init];
    mainSupMod.where = [NSString stringWithFormat:@"id = %d",[[_dataDic objectForKey:@"id"] intValue]];
    [mainSupMod deleteDBdata];
    [mainSupMod release];
    
    if (_detailType == DynamicDetailTypeMine) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMineDynamic" object:nil];
    }else if (_detailType == DynamicDetailTypeWantHave) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMineWantHave" object:nil];
    }else{
        
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    //    [dataManager release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateResponseNum" object:nil];
    
    [_redCircleView release];
    [cardV release];
    
    [_images release];
    [_dataDic release];
    [super dealloc];
}

@end
