//
//  SessionViewController.m
//  ql
//
//  Created by yunlai on 14-3-8.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "SessionViewController.h"
#import "SidebarViewController.h"
#import "TextMessageCell.h"
#import "GroupViewController.h"
#import "TcpRequestHelper.h"
#import "MessageDataManager.h"
#import "TextData.h"
#import "personal_chat_msg_model.h"
#import "SBJson.h"
#import "chatmsg_list_model.h"
#import "PictureData.h"
#import "invite_join_circlemsg_model.h"
#import "InviteJoinInfoCell.h"
#import "circle_chat_msg_model.h"
#import "circle_list_model.h"
#import "circle_member_list_model.h"
#import "temporary_circle_chat_msg_model.h"
#import "temporary_circle_list_model.h"
#import "MemberMainViewController.h"
#import "QBImagePickerController.h"
#import "CRNavigationController.h"
#import "iMMessageDataManager.h"
#import "DataChecker.h"
#import "wantHaveInfoCell.h"
#import "SystemNotifyCell.h"
#import "XHAudioPlayerHelper.h"
#import "VoiceData.h"
#import "CustomEmotionData.h"
#import "cardDetailViewController.h"
#import "VoiceMessageCell.h"
#import "login_info_model.h"
#import "EmotionStoreViewController.h"
#import "CustomEmoticonCell.h"

#import "TogetherCell.h"

//圈子成员列表
#import "CircleMemberList.h"

//圈子详情页面
#import "CircleDetailInviteViewController.h"
#import "CircleDetailOtherViewController.h"
#import "CircleDetailSelfViewController.h"
#import "TempCircleDetailOtherViewController.h"
#import "TempCircleDetailSelfViewController.h"
#import "UIImage+FixOrientation.h"
#import "temporary_circle_member_list_model.h"

#define IMG_SELECT_MAX_NUM      9

typedef enum{
    kButtonKeyBard,
    kButtonFaceView,
    kButtonRescource,
    kButtonVoice
}kButton;

@interface SessionViewController () <SnailMessageTableViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASIProgressDelegate,InviteJoinInfoCellDelegate,VoiceMessageCellDelegate,EmotionStoreViewControllerDelegate>
{    
}

@property (nonatomic, retain) UIButton * rightNaviButton;

@property (nonatomic, retain) NSMutableArray * unreadVoiceObjects;

@property (nonatomic, retain) NSMutableArray * sessionInfoList;

@property (nonatomic, assign) MessageDataManager * dataManager;

@property (nonatomic, retain) NSDictionary * circleInfoDic;

@property (nonatomic, assign) long long senderID;

@property (nonatomic, assign) int talkType;

@property (nonatomic, assign) long long userID;

@property (nonatomic, assign) BOOL isJoined;

@property (nonatomic, assign) NSInteger currentPageNum;

@end

@implementation SessionViewController

@synthesize style = _style;
@synthesize selectedDic = _selectedDic;

#pragma mark - DataSource Change

- (void)exChangeMessageDataSourceQueue:(void (^)())queue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue);
}

- (void)exMainQueue:(void (^)())queue {
    dispatch_async(dispatch_get_main_queue(), queue);
}

// http://stackoverflow.com/a/11602040 Keep UITableView static when inserting rows at the top
static CGPoint  delayOffset = {0.0};
- (void)insertMessage:(NSDictionary *)insertMessage atIndext:(NSInteger)index
{
    [self.sessionInfoList insertObject:insertMessage atIndex:index];
    
    delayOffset = self.messageTableView.contentOffset;
    
    delayOffset.y += [self calculateCellHeightWithDic:insertMessage];
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
    [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    
    [UIView setAnimationsEnabled:NO];
    [self.messageTableView beginUpdates];
    [self.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.messageTableView setContentOffset:delayOffset animated:NO];
    [self.messageTableView endUpdates];
    [UIView setAnimationsEnabled:YES];
    
    //判断并根据index将这个Cell插入到未读消息列表
    [self judgeObjectAndInsertItToUnreadArr:insertMessage withIndex:index];
}

- (void)judgeObjectAndInsertItToUnreadArr:(NSDictionary *)msgDic withIndex:(NSInteger)index
{
    MessageData * msgObject = [msgDic objectForKey:@"msgObject"];
    if (msgObject.msgData.objtype == dataTypeVoice) {
        VoiceData * voice = (VoiceData *)msgObject.msgData;
        if (voice.status == ReceiveMessageUnread) {
            if (index == 0) {
                [self.unreadVoiceObjects insertObject:voice atIndex:0];
            } else {
                [self.unreadVoiceObjects addObject:voice];
            }
        }
    }
}

- (void)addMessage:(NSDictionary *)addedMessageDic {
    [self.sessionInfoList addObject:addedMessageDic];
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
    [indexPaths addObject:[NSIndexPath indexPathForRow:self.sessionInfoList.count - 1 inSection:0]];
    
    [self.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self scrollToBottomAnimated:YES];
    
    [self judgeObjectAndInsertItToUnreadArr:addedMessageDic withIndex:self.sessionInfoList.count - 1 ];
}

- (void)removeMessageAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.sessionInfoList.count)
        return;
    [self.sessionInfoList removeObjectAtIndex:indexPath.row];
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
    [indexPaths addObject:indexPath];
    
    [self.messageTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.style = kSessionStylePerson;
        self.currentPageNum = 0; //change by snail

        self.sessionInfoList = [[NSMutableArray alloc]init];
        self.dataManager = [MessageDataManager shareMessageDataManager];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveChatMessage:) name:@"chatMessageReceive" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveConfirmJoinNotification:) name:kNotiConfirmJoinCircle object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resendMessages) name:kNotiLoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resendMessages) name:kNotiSendMessageSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveChatMessage:) name:kNotiReceiveTempCircleMsg object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpSubmitPictureSuccess:) name:kNotiSubmitMessageSuccess object:nil];
        
        //注册自己被删除的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(circleBeOutNotify) name:KNotiCircleBeOut object:nil];
        
    }
    return self;
}

//自己被踢出
-(void) circleBeOutNotify{
    if (self.talkType != MessageListTypeCircle && self.talkType != MessageListTypeTempCircle) {
        return;
    }
    
    [self.messageInputView resignFirstResponder];
    self.messageInputView.hidden = YES;
    self.rightNaviButton.hidden = YES;
}

#pragma mark- UIViewControllerLifeCircle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    //初始化一些该页面固有的基本信息，如该页面的发送方id是确定为user的id 接收方则为上级页面传入的sender_id
    [self loadFoundationInfo];
    //初始化聊天历史记录 并判断是否展示消息输入框 并滚到最后一栏
    [self loadSessionListAndScrollToBottomOrNot:YES];
    //初始化聊天信息的tableview
    [self loadTapGesture];
    //初始化导航吧风格
	[self loadNavigationBarBtn];
    /**
     * 查看本会话是否为已加入圈子状态
     * 注意，isJoined为标志变量，
     * 在其setter方法里控制着
     * 输入栏messageInputView和rightNavigationButton的状态
     **/
    [self checkJoinedSign];
    //加载上拉刷新视图
    [self loadMoreLoadingView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self makeupSelf];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self refreshChatList];
    if ([[XHAudioPlayerHelper shareInstance]isPlaying]) {
        [[XHAudioPlayerHelper shareInstance]stopAudio];
    }
}

//重置页面状态
- (void)makeupSelf
{
    self.title = [self.selectedDic objectForKey:@"name"];
}

//跟新聊天列表的未读记录
- (void)refreshChatList{
    chatmsg_list_model *chatGeter =[[chatmsg_list_model alloc]init];
    chatGeter.where = [NSString stringWithFormat:@"id = %lld and talk_type = %d",self.senderID,self.talkType];
    NSArray * chatList = [chatGeter getList];
    if (chatList.count > 0) {
        NSDictionary * unread = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"unreaded",nil];
        [chatGeter updateDB:unread];
    }
    RELEASE_SAFE(chatGeter);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiUpdateLeftbarMark object:nil];
}

//上拉刷新视图
- (void)loadMoreLoadingView
{
    // 上拉刷新   add by devin
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 50)];
    view.delegate = self;
    view.backgroundColor = [UIColor clearColor];
    [self.messageTableView addSubview:view];
    headerView = view;
    RELEASE_SAFE(view);
}

//初始化聊天窗口所需基本信息
- (void)loadFoundationInfo
{
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    //初始化未读语音Cell数组
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    self.unreadVoiceObjects = arr;
    RELEASE_SAFE(arr);
    
    self.talkType = [[self.selectedDic objectForKey:@"talk_type"]intValue];
    self.isJoined = NO;
    //获取默认用户名
    NSDictionary * userDic = [login_info_model getUserInfo];
    NSNumber * userNum = [userDic objectForKey:@"id"];
    self.userID  = userNum.longLongValue;
    
    //获取列表对应的聊天对象ID
    self.senderID = [[self.selectedDic objectForKey:@"sender_id"]longLongValue];

    if (self.talkType == MessageListTypeCircle) {
        self.circleInfoDic = [circle_list_model getCircleListWithCircleID:self.senderID];
        
    } else if (self.talkType == MessageListTypeTempCircle){
        self.circleInfoDic = [temporary_circle_list_model getTemporaryCircleListWithTempCircleID:self.senderID];
    }
}

//初始化个人历史信息列表
- (void)loadSessionListAndScrollToBottomOrNot:(BOOL)isScroll
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        db_model * listGeter = nil;
        NSString * whereStr = nil;
        whereStr = [NSString stringWithFormat:@"(sender_id = %lld and receiver_id = %lld) or (sender_id = %lld and receiver_id = %lld)order by sendtime desc",self.userID,self.senderID,self.senderID,self.userID];
        
        // 判断对话列表的风格，加载不同的数据
        if (self.talkType == MessageListTypePerson)
        {
            //获取单聊列表数据模型
            listGeter = [[personal_chat_msg_model alloc]init];
            
        } else if (self.talkType == MessageListTypeCircle)
        {
            //加载圈子模型 如果有邀请函则加载邀请函
            listGeter = [[circle_chat_msg_model alloc]init];
        }
        else if (self.talkType == MessageListTypeTempCircle){
            listGeter = [temporary_circle_chat_msg_model new];
        }
        
        listGeter.where = whereStr;
        NSArray * list = [listGeter fromPageNumber:self.currentPageNum pageNumber:QLPagingNumberCount];
        RELEASE_SAFE(listGeter);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新消息提醒列表统计数目 取消小红点
            [self refreshChatList];
            
            //获取前十条历史消息记录并插入到聊天table中
            self.currentPageNum += 10;
            for (int i = 0; i <list.count; i++) {
                NSDictionary * baseDic = [list objectAtIndex:i];
                MessageData * msg = [MessageDataManager getMessageDataFromDBDic:baseDic];
                msg.talkType = self.talkType;
                NSMutableArray * messageArr = [self addSessionListDicWithMessage:msg];
                RELEASE_SAFE(msg);
                
                for (int i = messageArr.count -1 ; i >= 0; i --) {
                    NSDictionary * messageDic = [messageArr objectAtIndex:i];
                    [self insertMessage:messageDic atIndext:0];
                }
            }
            
            if (self.isJoined == NO && (self.talkType == MessageListTypeCircle || self.talkType == MessageListTypeTempCircle))
            {
                self.messageInputView.hidden = YES;
            }
            if (isScroll) {
                [self scrollToBottomAnimated:NO];
            }
        });
    });
}

/**
 * 查看是否加入圈子
 */
- (void)checkJoinedSign
{
    switch (self.talkType) {
        case MessageListTypeCircle:
        {
            NSDictionary * judgeSelfDic = [circle_member_list_model getCircleMemberDicWith:self.senderID andUserID:self.userID];
            self.isJoined = (judgeSelfDic != nil)? YES: NO;
        }
            break;
        case MessageListTypeTempCircle:
        {
            NSDictionary * tempCircleJudgeSelfDic = [temporary_circle_member_list_model getTempCircleMemberDicWith:self.senderID andUserID:self.userID];
            self.isJoined = (tempCircleJudgeSelfDic !=nil)? YES :NO;
        }
            break;
        default:
            break;
    }

    // 加载圈子邀请信息
    NSMutableArray * invitedArr =[invite_join_circlemsg_model getInviteJoinMessageWithCircleID:self.senderID];
    
    NSDictionary * invitedDic = nil;
    if (invitedArr.count > 0) {
        invitedDic = [invitedArr lastObject];
        int joined = [[invitedDic objectForKey:@"joined"]intValue];
        //判断是否已经加入该圈子 0 为未加入 1 为已经加入
        if (joined == 0) {
            [self.sessionInfoList addObject:invitedDic];
        } else if (joined == 1) {
            self.isJoined = YES;
        }
    }
    
    if (self.talkType == MessageListTypePerson) {
        self.rightNaviButton.hidden = NO;
        self.messageInputView.hidden = NO;
    }
}

- (void)setIsJoined:(BOOL)isJoined
{
    _isJoined = isJoined;
    if (_isJoined) {
        self.messageInputView.hidden = NO;
        self.rightNaviButton.hidden = NO;
    } else {
        self.messageInputView.hidden = YES;
        self.rightNaviButton.hidden = YES;
    }
}

- (void)tapTohideOtherviews
{
    if ([self.messageInputView isInputSomething]) {
        [self layoutOtherMenuViewHiden:YES];
        [self.messageInputView resetAllButton];
    }
}

/**
 *  实例化导航栏按钮
 */
- (void)loadNavigationBarBtn{
    //返回按钮
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];

    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    if (IOS_VERSION_7) {
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    }
    
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20 , 30, 44.f, 44.f);
    //    RELEASE_SAFE(image);
    
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    RELEASE_SAFE(backItem);
    
    //详情按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(20.0f, 30.0f, 50.0f, 30.0f);
    [rightButton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    rightButton.titleLabel.font = KQLboldSystemFont(14);
    self.rightNaviButton = rightButton;
    
    if (self.talkType == MessageListTypePerson) {
        [rightButton setTitle:@"详情" forState:UIControlStateNormal];
    } else if (self.talkType == MessageListTypeCircle || self.talkType == MessageListTypeTempCircle){
        [rightButton setTitle:@"成员" forState:UIControlStateNormal];
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    RELEASE_SAFE(rightItem);
}

- (void)loadTapGesture
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UITapGestureRecognizer * singleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(tapTohideOtherviews)];
        singleTapRecognizer.delegate = self;
        [self.messageTableView addGestureRecognizer:singleTapRecognizer];
    });
}

#pragma mark - Button Click Method
/**
 *  返回事件
 */
- (void)backTo{
    if (_isCloudPagePresent) {
        [self dismissModalViewControllerAnimated:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// 右边按钮点击事件
- (void)rightButtonClick
{
    if (self.isJoined == NO && self.talkType == MessageListTypeCircle)
    {
        DataChecker * checker = [DataChecker new];
        checker.delegate = self;
        [checker updateCircleInfoWithID:self.senderID];
        return;
    }
    
    if (self.talkType == MessageListTypeCircle || self.talkType == MessageListTypeTempCircle) {
        
        NSNumber *createrID = [self.circleInfoDic objectForKey:@"creater_id"];
        //判断圈子人数是否多余2个人，否则直接跳转详情
        if (self.circleContactsList.count < 2)
        {
            UIViewController * pushViewController = nil;
            switch (self.talkType) {
                case MessageListTypeCircle:
                {
                    if (createrID.longLongValue == self.userID) {
                        CircleDetailSelfViewController * selfCircleDetail = [CircleDetailSelfViewController new];
                        selfCircleDetail.circleId = self.senderID;
                        pushViewController = selfCircleDetail;
                       
                    } else {
                        CircleDetailOtherViewController* otherDetailVC = [[CircleDetailOtherViewController alloc] init];
                        otherDetailVC.circleId = self.senderID;
                        pushViewController = otherDetailVC;
                    }
                }
                    break;
                case MessageListTypeTempCircle:
                {
                    if (createrID.longLongValue == self.userID) {
                        TempCircleDetailSelfViewController * tempSelfDetail = [TempCircleDetailSelfViewController new];
                        tempSelfDetail.circleId = self.senderID;
                        pushViewController = tempSelfDetail;
                    } else{
                        TempCircleDetailOtherViewController * tempOtherDetail = [TempCircleDetailOtherViewController new];
                        tempOtherDetail.circleId = self.senderID;
                        pushViewController = tempOtherDetail;
                    }
                }
                    break;
                    
                default:
                    break;
            }
            [self.navigationController pushViewController:pushViewController animated:YES];
            RELEASE_SAFE(pushViewController);
        }else{
            CircleMemberList* circleMemListVC = [[CircleMemberList alloc] init];
            circleMemListVC.circleId = self.senderID;
            circleMemListVC.circleName = [self.circleInfoDic objectForKey:@"name"];
            circleMemListVC.enterFromDetail = NO;
            if (self.talkType == MessageListTypeCircle) {
                circleMemListVC.circleType = StableCircle;
            }else if (self.talkType == MessageListTypeTempCircle) {
                circleMemListVC.circleType = TemporaryCircle;
            }
            [self.navigationController pushViewController:circleMemListVC animated:YES];
            RELEASE_SAFE(circleMemListVC);
        }
    }
    
    if (self.talkType == MessageListTypePerson || self.talkType == MessageListTypeSecretory || self.talkType == MessageListTypeOrg) {
        MemberMainViewController *memberMainView = [[MemberMainViewController  alloc] init];
        memberMainView.pushType = PushTypesButtom;
        memberMainView.accessType = AccessTypeCircleLook;
        memberMainView.isSessionInter = YES;
        memberMainView.lookId = self.senderID;
        CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberMainView];
        [self.navigationController presentModalViewController:nav animated:YES];
        
        RELEASE_SAFE(nav);
        RELEASE_SAFE(memberMainView);
    }
}

#pragma mark - SubmitMessageMethod

// 发送文本信息
- (void)submitMessageWithText:(NSString *)text
{
    // 获取编辑框中的内容并且加以判断
    NSString * textFieldString = text;
    
    // 生成发送消息所需字典 内容为本文消息字符串和 发送者信息字典
    NSDictionary * textMsgInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     textFieldString,kMessageData,
                                     self.selectedDic,kMessageUserInfo,nil];
    
    // 使用iMMessageDataManager 封装消息数据 并且向iM 服务器发送消息
    MessageData * sendingMessage = [IM_DATA_MANAGER sendTextData:textMsgInfoDic];
    [self insertMessageToLastCellWithMessage:sendingMessage];
}

//插入数据到最后一个cell
- (void)insertMessageToLastCellWithMessage:(MessageData *)message
{
    NSMutableArray * messageArr = [self addSessionListDicWithMessage:message];
    for (NSDictionary * messageDic in messageArr) {
        [self addMessage:messageDic];
    }
}

// 发送图片消息
- (void)submitMessageWithPictureInfo:(id)info
{
    NSDate * timeDate = [NSDate new];
    int timeInterval = (int)[timeDate timeIntervalSince1970];
    NSString * imgUrlStr = [NSString stringWithFormat:@"%d.png",timeInterval];
    RELEASE_SAFE(timeDate);
    //这个方法会被照片库选择结束 info 为数组 和 摄像头拍照后回调 info 为一个dictionary 因此分开处理
    if ([info isKindOfClass:[NSDictionary class]]) {
        
        UIImage * imgOrigin = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage * img = [imgOrigin fixOrientation];

        NSDictionary * imgInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     imgUrlStr,@"imgUrlStr",
                                     img,@"img",
                                     nil];
        
        //生成消息字典
        NSDictionary * picDataInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         self.selectedDic,kMessageUserInfo,
                                         imgInfoDic,kMessageData, nil];
        //使用消息发送器向Http服务器和iM服务器发送图片消息
        MessageData * sendingMessage = [[iMMessageDataManager shareiMMessageDataManager]sendImageData:picDataInfoDic];
        [self insertMessageToLastCellWithMessage:sendingMessage];
    } else if ([info isKindOfClass:[NSMutableArray class]]){
        int groupMessageIndex = 0;
        for (NSDictionary * imgDic in info) {
            UIImage * img = [imgDic objectForKey:@"UIImagePickerControllerOriginalImage"];
            imgUrlStr = [NSString stringWithFormat:@"%d%@",++groupMessageIndex,imgUrlStr];
            NSDictionary * imgMessageDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                            img,@"img",
                                            imgUrlStr,@"imgUrlStr",
                                            nil];
            
            //生成消息字典
            NSDictionary * picDataInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.selectedDic,kMessageUserInfo,imgMessageDic,kMessageData, nil];
            //使用消息发送器向Http服务器和iM服务器发送图片消息
            MessageData * sendingMessage = [[iMMessageDataManager shareiMMessageDataManager]sendImageData:picDataInfoDic];
            [self insertMessageToLastCellWithMessage:sendingMessage];
        }
    }
}

// 发送声音消息
- (void)submitMessageWithVoiceDic:(NSDictionary *)voiceDic
{
    //生成消息字典
    NSDictionary * voiceSendDic = [NSDictionary dictionaryWithObjectsAndKeys:self.selectedDic,kMessageUserInfo,voiceDic,kMessageData,nil];
    
    //使用消息发送器向Http服务器上传语音消息并向iM服务器发送语音消息
    MessageData * voiceMessage = [IM_DATA_MANAGER sendVoiceDataWithDic:voiceSendDic];
    [self insertMessageToLastCellWithMessage:voiceMessage];
}

//发送自定义表情消息
- (void)submitCustomMessageWithCustomEmotionData:(CustomEmotionData *)emotionData
{
    MessageData * customEmotionMessage = [IM_DATA_MANAGER sendCustomEmoticonWithEmoticonData:emotionData andInfoDic:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                     self.selectedDic,kMessageUserInfo, nil]];
    [self insertMessageToLastCellWithMessage:customEmotionMessage];
}

// 当从新登陆的时候从新发送存储在MessageDataManager 里面的消息
- (void)resendMessages
{
    if (self.dataManager.waitToResendQueue.count > 0) {
        MessageData * mData = [self.dataManager.waitToResendQueue firstObject];
        [[TcpRequestHelper shareTcpRequestHelperHelper]sendMessagePackageCommandId:TCP_TEXTMESSAG_EPERSON_COMMAND_ID andMessageData:mData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sessionInfoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *infoDic = [self.sessionInfoList objectAtIndex:indexPath.row];
    MessageData * cellMessage = [infoDic objectForKey:@"msgObject"];
    
    UITableViewCell *cell = nil;
    //只有邀请信息有这个字段 所以用它来判断
    if ([infoDic objectForKey:@"joined"] != nil)
    {
        NSString * inviteCellReuseIdentify = @"nviteCellReuseIdentify";
        cell = [tableView dequeueReusableCellWithIdentifier:inviteCellReuseIdentify];
        if (cell == nil || ![cell isKindOfClass:[InviteJoinInfoCell class]]) {
            cell = [[[InviteJoinInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inviteCellReuseIdentify]autorelease];
        }
        InviteJoinInfoCell * inviteCell = (InviteJoinInfoCell *)cell;
        [inviteCell assignCellValue:infoDic];
        inviteCell.delegate = self;
        
    } else if ([infoDic objectForKey:@"textMessage"]!= nil){
        
        NSString * textCellIdentify = @"textMessageCell";
        cell =  [tableView dequeueReusableCellWithIdentifier:textCellIdentify];
        if (cell == nil || ![cell isKindOfClass:[TextMessageCell class]]) {
            cell = [[[TextMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellIdentify] autorelease];
        }
        
        // 对每个不同的实例进行相应的布局
        TextMessageCell * textCell = (TextMessageCell *)cell;
        [textCell freshWithInfoDic:[self.sessionInfoList objectAtIndex:indexPath.row]];
    } else if ([infoDic objectForKey:@"pictureMessage"] != nil){
        
        NSString * pictureCellIdentify = @"pictureMessageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:pictureCellIdentify];
        if (cell == nil) {
            cell = [[[PictureMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pictureCellIdentify]autorelease];
        }
        PictureMessageCell * pictureCell = (PictureMessageCell *)cell;
        pictureCell.delegate = self;
        
        [pictureCell freshWithInfoDic:[self.sessionInfoList objectAtIndex:indexPath.row]];
    } else if ([infoDic objectForKey:@"wantHaveMessage"] != nil) {
        
        NSString* wantHaveCellIdentify = @"wantHaveInfoCell";
        cell = [tableView dequeueReusableCellWithIdentifier:wantHaveCellIdentify];
        if (cell == nil) {
            cell = [[[wantHaveInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wantHaveCellIdentify] autorelease];
        }
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wantHaveTap:)];
        cell.contentView.tag = [[infoDic objectForKey:@"id"] intValue];
        [cell.contentView addGestureRecognizer:tap];
        [tap release];
        
        wantHaveInfoCell* wantCell = (wantHaveInfoCell *)cell;
        [wantCell freshWithInfoDic:infoDic];
        
    }else if ([infoDic objectForKey:@"togetherMessage"] != nil) {
        
        NSString* togetherCellIdentify = @"togetherCell";
        cell = [tableView dequeueReusableCellWithIdentifier:togetherCellIdentify];
        if (cell == nil) {
            cell = [[[TogetherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:togetherCellIdentify] autorelease];
        }
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(togetherTap:)];
        cell.contentView.tag = [[infoDic objectForKey:@"id"] intValue];
        [cell.contentView addGestureRecognizer:tap];
        [tap release];
        
        TogetherCell* wantCell = (TogetherCell *)cell;
        [wantCell freshWithInfoDic:infoDic];
        
    } else if (cellMessage.msgData.objtype == dataTypeVoice) {
        
        NSString * voiceMessageCellIdentify = @"voiceMessageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:voiceMessageCellIdentify];
        if (cell == nil) {
            cell = [[[VoiceMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voiceMessageCellIdentify]autorelease];
        }
       
        VoiceMessageCell * voiceCell = (VoiceMessageCell *)cell;
        voiceCell.delegate = self;
        [voiceCell freshWithInfoDic:infoDic];
        
        //将cell作为消息对象的成员变量 后面的语音轮播使用
        VoiceData * voiceData = (VoiceData *)cellMessage.msgData;
        voiceData.currentCell = cell;
        
    } else if ([infoDic objectForKey:@"systemNotifyMessage"] != nil) {
        
        NSString * systemNotifyCellIdentify = @"systemNotifyCell";
        cell = [tableView dequeueReusableCellWithIdentifier:systemNotifyCellIdentify];
        if (cell == nil) {
            cell = [[SystemNotifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemNotifyCellIdentify];
        }
        
        SystemNotifyCell * notifyCell = (SystemNotifyCell *)cell;
        [notifyCell freshWithInfoDic:infoDic];
    }
    
    switch (cellMessage.msgData.objtype) {
        case dataTypeCustomEmotion:
        {
            NSString * customEmoticonCell = @"customEmoticonCell";
            cell = [tableView dequeueReusableCellWithIdentifier:customEmoticonCell];
            if (cell == nil) {
                cell = [[CustomEmoticonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customEmoticonCell];
            }
            
            CustomEmoticonCell *theCell = (CustomEmoticonCell *)cell;
            [theCell freshWithInfoDic:infoDic];
        }
            break;
            
        default:
            break;
    }
    
    //异常处理 如果数据源有问题则会展示一个血红色的cell
    if (cell != nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    } else {
        UITableViewCell * errorCell = [tableView dequeueReusableCellWithIdentifier:@"error"];
        if (errorCell == nil) {
            errorCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"error"];
        }
        errorCell.backgroundColor = [UIColor redColor];
        return errorCell;
    }
}

-(void) togetherTap:(UIGestureRecognizer*) ges{
    UIView* v = ges.view;
    int publishId = v.tag;
    
    [self accessDynamicDetail:publishId];
}

-(void) wantHaveTap:(UIGestureRecognizer*) ges{
    UIView* v = ges.view;
    int publishId = v.tag;
    
    [self accessDynamicDetail:publishId];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sessionDic = [self.sessionInfoList objectAtIndex:indexPath.row];
    return [self calculateCellHeightWithDic:sessionDic];
}

- (float)calculateCellHeightWithDic:(NSDictionary *)sessionDic
{
    MessageData * messageObject = [sessionDic objectForKey:@"msgObject"];
    
    if ([sessionDic objectForKey:@"systemNotifyMessage"] != nil) {
        return [SystemNotifyCell caculateCellHightWithMessageDic:sessionDic];
    }
    
    switch (messageObject.msgData.objtype) {
        case dataTypeVoice:
            return [VoiceMessageCell caculateCellHeighFrom:sessionDic];
            break;
//        case dataTypeText:
//            return [TextMessageCell caculateCellHeighFrom:sessionDic];
//            break;
//        case dataTypePicture:
//            return [PictureMessageCell caculateCellHeighFrom:sessionDic];
//            break;
//        case dataTypeWantHave:
//            return [wantHaveInfoCell caculateCellHeighFrom:sessionDic];
//            break;
//        case dataTypeTogether:
//            return [TogetherCell caculateCellHeighFrom:sessionDic];
            break;
        case dataTypeCustomEmotion:
            return [CustomEmoticonCell caculateCellHeighFrom:sessionDic];
        default:
            break;
    }
    if ([sessionDic objectForKey:@"textMessage"] != nil) {
        return [TextMessageCell caculateCellHeighFrom:sessionDic];
    }
    
    if ([sessionDic objectForKey:@"joined"] != nil) {
        return [InviteJoinInfoCell caculateCellHeighFrom:sessionDic];
    }
    
    if ([sessionDic objectForKey:@"pictureMessage"] != nil) {
        return [PictureMessageCell caculateCellHeighFrom:sessionDic];
    }

    if ([sessionDic objectForKey:@"togetherMessage"] != nil) {
        return [TogetherCell caculateCellHeighFrom:sessionDic];
    }
    
    if ([sessionDic objectForKey:@"wantHaveMessage"] != nil) {
        return [wantHaveInfoCell caculateCellHeighFrom:sessionDic];
    }
    
    return 80;
}

#pragma mark - Add Session ListDic With Message

- (NSDictionary *)insertSessionListDicWithMessage:(MessageData *)msg atIndex:(NSInteger)index
{
    NSDictionary * speaker_info = msg.speakerinfo;
    NSString * nickName = [speaker_info objectForKey:@"nickname"];
    NSString * senderName = @" ";
    if (nickName != nil && ![nickName isEqualToString:@""]) {
        senderName = nickName;
    }
    
    // 发送类型 0 为自己 1 为别人
    NSNumber *style;
    NSMutableArray *portrait = [[NSMutableArray alloc]init];
    long long sender_id = msg.senderID;
    
    //圈子聊天时 确定消息的发送类型 从而生成发送者头像
    if (self.talkType == MessageListTypeCircle || self.talkType == MessageListTypeTempCircle) {
        if ([[speaker_info objectForKey:@"uid"]longLongValue] == self.userID) {
            style = [NSNumber numberWithInt:0];
        } else {
            style = [NSNumber numberWithInt:1];
        }
        
        for (NSDictionary *dic in self.circleContactsList) {
            int user_id = [[dic objectForKey:@"user_id"]intValue];
            if (user_id == [[speaker_info objectForKey:@"uid"]intValue]) {
                NSString * portraitStr = [dic objectForKey:@"portrait"];
                [portrait addObject:portraitStr];
                break;
            }
        }
    } else {
        //单聊时 确定消息的发送类型
        portrait = [self.selectedDic objectForKey:@"portrait"];
        if (sender_id == self.userID) {
            style = [NSNumber numberWithInt:0];
        } else {
            style = [NSNumber numberWithInt:1];
        }
    }
    
    NSString *timeString = [Common makeTime:msg.sendtime withFormat:@"MM-dd-HH:mm"];
    NSDictionary * msgDataDic = [msg.msg firstObject];
    int msgType = [[msgDataDic objectForKey:@"objtype"]intValue];
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     timeString,@"time",
                                     senderName,@"name",
                                     style,@"sessionStyle",
                                     msg,@"msgObject",
                                     portrait,@"portrait",
                                     nil];
    
    //判断消息类型1 为文本消息 2 为图片消息
    switch (msgType) {
        case dataTypeText:
        {
            NSString *message = [[msgDataDic objectForKey:@"data"]objectForKey:@"txt"];
            [infoDic setObject:message forKey:@"textMessage"];
            [self.sessionInfoList insertObject:infoDic atIndex:index];//add by devin 每次从数据库取出的元素放到第0个，这样就就可以形成从小到大的顺序
        }
            break;
        case dataTypePicture:
        {
            NSString * thumbnailUrls = [[msgDataDic objectForKey:@"data"]objectForKey:@"tburl"];
            NSArray * thumbnailArr = [thumbnailUrls componentsSeparatedByString:@","];
            
            NSString * wholeImgUrlStr =[[msgDataDic objectForKey:@"data"]objectForKey:@"url"];
            NSArray * wholeImgArr = [wholeImgUrlStr componentsSeparatedByString:@","];
            
            for (int i = 0;i <thumbnailArr.count; i++) {
                NSString * thumbUrlStr = [thumbnailArr objectAtIndex:i];
                NSString * wholeUrlStr = [wholeImgArr objectAtIndex:i];
                
                infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           timeString,@"time",
                           senderName,@"name",
                           thumbUrlStr,@"pictureMessage",
                           wholeUrlStr,@"wholeImgUrl",
                           style,@"sessionStyle",
                           portrait,@"portrait",
                           msg,@"msgObject",
                           nil];
                [self.sessionInfoList insertObject:infoDic atIndex:index];//add by devin
            }
        }
            break;
        case dataTypeVoice:
        {
            [self.sessionInfoList insertObject:infoDic atIndex:index];//add by devin
        }
            break;
        case 7:
        {
            NSDictionary* msgData = [msgDataDic objectForKey:@"data"];
            
            int wantHaveType;
            if (self.talkType == MessageListTypeHave) {
                wantHaveType = 1;
            }else{
                wantHaveType = 2;
            }
            
            infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       timeString,@"time",
                       [msgData objectForKey:@"msgdesc"],@"wantHaveMessage",
                       [NSNumber numberWithInt:wantHaveType],@"type",
                       [NSNumber numberWithInt:[[msgData objectForKey:@"id"] intValue]],@"id",
                       nil];
            [self.sessionInfoList insertObject:infoDic atIndex:0];//add by devin
            
            NSString *message = [msgData objectForKey:@"txt"];
            NSDictionary* secInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                     timeString,@"time",
                                     senderName,@"name",
                                     message,@"textMessage",
                                     style,@"sessionStyle",nil];
            [self.sessionInfoList insertObject:secInfo atIndex:index];//add by devin
            
        }
            break;
        default:
            break;
    }
    return infoDic;
}

// add 表示插入最后面也就是最新的
- (NSMutableArray *)addSessionListDicWithMessage:(MessageData *)msg
{
    NSMutableArray * resultMessageArr = [NSMutableArray arrayWithCapacity:1];
    NSDictionary * speaker_info = msg.speakerinfo;
    NSString * nickName = [speaker_info objectForKey:@"nickname"];
    NSString * senderName = @" ";
    if (nickName != nil && ![nickName isEqualToString:@""]) {
        senderName = nickName;
    }
    
    // 发送类型 0 为自己 1 为别人
    NSNumber *style;
    NSMutableArray *portrait = [[NSMutableArray alloc]init];
    long long sender_id = msg.senderID;
    
    //圈子聊天时 确定消息的发送类型 从而生成发送者头像
    if (self.talkType == MessageListTypeCircle || self.talkType == MessageListTypeTempCircle) {
        if ([[speaker_info objectForKey:@"uid"]longLongValue] == self.userID) {
            style = [NSNumber numberWithInt:0];
        } else {
            style = [NSNumber numberWithInt:1];
        }
        
        for (NSDictionary *dic in self.circleContactsList) {
            int user_id = [[dic objectForKey:@"user_id"]intValue];
            if (user_id == [[speaker_info objectForKey:@"uid"]intValue]) {
                NSString * portraitStr = [dic objectForKey:@"portrait"];
                [portrait addObject:portraitStr];
                break;
            }
        }
    } else {
        //单聊时 确定消息的发送类型
        portrait = [speaker_info objectForKey:@"portrait"];
        if (sender_id == self.userID) {
            style = [NSNumber numberWithInt:0];
        } else {
            style = [NSNumber numberWithInt:1];
        }
    }
    
    NSNumber * timeNum = [NSNumber numberWithDouble:msg.sendtime];
    NSDictionary * msgDataDic = [msg.msg firstObject];
    int msgType = [[msgDataDic objectForKey:@"objtype"]intValue];
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     timeNum,@"time",
                                     senderName,@"name",
                                     style,@"sessionStyle",
                                     msg,@"msgObject",
                                     portrait,@"portrait",
                                     nil];
    
    //判断消息类型1 为文本消息 2 为图片消息
    switch (msgType) {
        case dataTypeText:
        {
            //如果发送方为一个特殊的角色 id 为1 则做系统消息展示
            NSString *message = [[msgDataDic objectForKey:@"data"]objectForKey:@"txt"];
            if ([[msg.speakerinfo objectForKey:@"uid"]intValue] == 1) {
                [infoDic setObject:message forKey:@"systemNotifyMessage"];
            } else {
                [infoDic setObject:message forKey:@"textMessage"];
            }
            [resultMessageArr addObject:infoDic];
            
        }
            break;
        case dataTypePicture:
        {
            NSString * thumbnailUrls = [[msgDataDic objectForKey:@"data"]objectForKey:@"tburl"];
    
            NSArray * thumbnailArr = [thumbnailUrls componentsSeparatedByString:@","];
            NSString * wholeImgUrlStr =[[msgDataDic objectForKey:@"data"]objectForKey:@"url"];
            NSArray * wholeImgArr = [wholeImgUrlStr componentsSeparatedByString:@","];
            
            for (int i = 0;i <thumbnailArr.count; i++) {
                NSString * thumbUrlStr = [thumbnailArr objectAtIndex:i];
                NSString * wholeUrlStr = [wholeImgArr objectAtIndex:i];
                
                infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           timeNum,@"time",
                           senderName,@"name",
                           thumbUrlStr,@"pictureMessage",
                           wholeUrlStr,@"wholeImgUrl",
                           style,@"sessionStyle",
                           msg,@"msgObject",
                           portrait,@"portrait",
                           nil];
                [resultMessageArr addObject:infoDic];
            }
        }
            break;
        case dataTypeVoice:
        {
            [resultMessageArr addObject:infoDic];
        }
            break;
        case dataTypeWantHave:
        {
            NSDictionary* msgData = [msgDataDic objectForKey:@"data"];
            
            NSString *txt = [msgData objectForKey:@"txt"];
            NSMutableDictionary * commentMessageDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
            [commentMessageDic setObject:txt forKey:@"textMessage"];
//            [commentMessageDic removeObjectForKey:@"msgObject"];

            infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       timeNum,@"time",
                       [msgData objectForKey:@"msgdesc"],@"wantHaveMessage",
                       msg,@"msgObject",
                       [NSNumber numberWithInt:[[msgData objectForKey:@"id"] intValue]],@"id",
                       nil];
            [resultMessageArr addObject:infoDic];
            [resultMessageArr addObject:commentMessageDic];
        }
            break;
        case dataTypeTogether:
        {
            NSDictionary* msgData = [msgDataDic objectForKey:@"data"];
            NSString *txt = [msgData objectForKey:@"txt"];

            NSMutableDictionary * commentMessageDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
            [commentMessageDic setObject:txt forKey:@"textMessage"];
//            [commentMessageDic removeObjectForKey:@"msgObject"];
            
            infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       timeNum,@"time",
                       [msgData objectForKey:@"msgdesc"],@"togetherMessage",
                       msg,@"msgObject",
                       [NSNumber numberWithInt:[[msgData objectForKey:@"id"] intValue]],@"id",
                       nil];
            [resultMessageArr addObject:infoDic];
            [resultMessageArr addObject:commentMessageDic];
        }
            break;
        default:
        {
            [resultMessageArr addObject:infoDic];
        }
            break;
    }
    return resultMessageArr;
}

#pragma mark -TempPictureMessageSendResolveLogic

- (void)httpSubmitPictureSuccess:(NSNotification *)noti
{
    MessageData * msg = [noti object];
    [self insertMessageToLastCellWithMessage:msg];
}


#pragma mark - ChatMessageReceivedCallBack
- (void)didReceiveChatMessage:(NSNotification *)noti
{
    MessageData *msgData = nil;
    msgData = [noti object];
    
    //判断接发送方id是否和当前聊天页面的对象一直如果一致则做界面展现，若不一致则忽略
    if (msgData.senderID == self.senderID) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiUpdateLeftbarMark object:nil];
        [self insertMessageToLastCellWithMessage:msgData];
    }
}

#pragma mark - ConfirmJoinCircleNotification

- (void)didReceiveConfirmJoinNotification:(NSNotification *)noti
{
    NSDictionary * retrieveDic = [noti object];
    
    if ([[retrieveDic objectForKey:@"recode"]intValue] == 0) {
        self.messageInputView.hidden = NO;
        self.isJoined = YES;
        [self.rightNaviButton setTitle:@"成员" forState:UIControlStateNormal];
        
        invite_join_circlemsg_model * iJListGeter = [[invite_join_circlemsg_model alloc]init];
        iJListGeter.where = [NSString stringWithFormat:@"circle_id = %lld",self.senderID];
        NSArray *jMsgList =[iJListGeter getList];
        NSDictionary * jMsgDic = nil;
        if (jMsgList.count != 0) {
            jMsgDic = [jMsgList lastObject];
        }
        
        NSDictionary * insertDic =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"joined", nil];
        
        if (jMsgDic != nil) {
            [iJListGeter updateDB:insertDic];
        }
        RELEASE_SAFE(iJListGeter);
        
        chatmsg_list_model * chatListGeter = [chatmsg_list_model new];
        chatListGeter.where = [NSString stringWithFormat:@"id = %lld and talk_type = %d",self.senderID,MessageListTypeCircle];
        NSDictionary * update = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:2],@"invited_sign", nil];
        [db_model updateDataWithModel:chatListGeter withDic:update];
        
        //跟新并获取圈子的信息并保存信息到本地
        DataChecker * checker = [DataChecker new];
        checker.delegate = self;
        [checker updateCircleInfoWithID:self.senderID];
    }
}

#pragma mark - InviteJoinInfoCellDelegate

- (void)confirmJoinCircle
{
    self.rightNaviButton.hidden = NO;
    
    NSDictionary *bodyJson = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithLongLong:[[self.selectedDic objectForKey:@"sender_id"] intValue]],@"circleid",
                              [NSNumber numberWithInt:1],@"agree",
                              nil];
    
    [[TcpRequestHelper shareTcpRequestHelperHelper]sendInviteJoinCircleConfirmCommandId:CMD_INVITE_JOIN_CONFIRM inviteId:[[self.selectedDic objectForKey:@"speaker_id"] longLongValue] bodyJson:bodyJson];
}

- (void)ignoreCircle
{
    [invite_join_circlemsg_model deleteInviteDataWithCircleID:self.senderID];
    [chatmsg_list_model deleteChatMsgListWithTalkType:MessageListTypeCircle andID:self.senderID];
//    [self dismissModalViewControllerAnimated:YES];
    
}

-(void) accessDynamicDetail:(int) publishId{
    NSString* reqUrl = @"member/publishDetail.do?param=";
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:publishId],@"publish_id",
                                       [Global sharedGlobal].user_id,@"user_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_DETAIL_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver
{
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        switch (commandid) {
            case GROUP_MEMBER_LIST_COMMAND_ID:
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *resultDic = [resultArray firstObject];
                    
                    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
                    NSMutableArray *orglistArray = [resultDic objectForKey:@"members"];
                    
                    for (int i =0; i< orglistArray.count; i++) {
                        NSDictionary *orgDic = [orglistArray objectAtIndex:i];
                        
                        //组织列表信息
                        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [orgDic objectForKey:@"user_id"],@"user_id",
                                              [orgDic objectForKey:@"created"],@"created",
                                              [orgDic objectForKey:@"portrait"],@"portrait",
                                              [orgDic objectForKey:@"realname"],@"realname",
                                              [orgDic objectForKey:@"role"],@"role",
                                              [NSNumber numberWithLongLong:self.senderID],@"circle_id",
                                              nil];
                        [self.circleContactsList addObject:dict];
                    }
                    
                    NSDictionary * portraitNameDic = [Common generatePortraitNameDicJsonStrWithContactArr:self.circleContactsList];
                    NSArray * portraitsArr = [portraitNameDic objectForKey:@"icon_path"];
                    NSString * portraitJsonStr = [portraitsArr JSONRepresentation];
                    
                    // 更新聊天列表圈子的头像 换成前三个人的头像少于三人的话就全部加上
                    chatmsg_list_model * cListGeter = [chatmsg_list_model new];
                    cListGeter.where = [NSString stringWithFormat:@"id = %lld",self.senderID];
                    NSDictionary * updateDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                portraitJsonStr, @"icon_path",nil];
                    [cListGeter updateDB:updateDic];
                    
                    RELEASE_SAFE(cListGeter);
                    RELEASE_SAFE(pool);
                });
                
                break;
            case DYNAMIC_DETAIL_COMMAND_ID:
            {
                if (resultArray.count) {
                    
                    //不同类型，提示语不一样
                    int type = [[[resultArray firstObject] objectForKey:@"type"] intValue];
                    NSString* msg = nil;
                    if (type == 8) {
                        msg = [NSString stringWithFormat:@"%@已被删除",self.title];
                    }else{
                        msg = @"这条动态已被删除";
                    }
                    
                    //delete字段0未删除，1已删除
                    int deleteStatus = [[[resultArray firstObject] objectForKey:@"delete"] intValue];
                    if (deleteStatus) {
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                    
                    cardDetailViewController* cardDetailVC = [[cardDetailViewController alloc] init];
                    
                    CardType cardT;
                    if (type == 0) {
                        cardT = CardImage;
                    }else if (type == 1) {
                        cardT = CardOOXX;
                    }else if (type == 2) {
                        cardT = CardOpenTime;
                    }else if (type == 3) {
                        cardT = CardWantOrHave;
                    }else if (type == 4){
                        cardT = CardWantOrHave;
                    }else if (type == 5){
                        cardT = CardNews;
                    }else if (type == 6) {
                        cardT = CardLabel;
                    }else if (type == 8) {
                        cardT = CardTogether;
                    }else{
                        cardT = CardImage;
                    }
                    
                    cardDetailVC.type = cardT;
                    cardDetailVC.dataDic = [resultArray firstObject];
                    cardDetailVC.detailType = DynamicDetailTypeAll;
                    cardDetailVC.enterFromDYList = NO;
                    
                    [self.navigationController pushViewController:cardDetailVC animated:YES];
                    RELEASE_SAFE(cardDetailVC);
                    
                }else{
                    [Common checkProgressHUD:@"服务器错误.." andImage:nil showInView:self.view];
                }
            }
                break;
            default:
                break;
        }
    } else {
        [Common checkProgressHUD:@"服务器请求数据失败" andImage:nil showInView:APPKEYWINDOW];
    }
}

#pragma mark - QBImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id )info
{
    [self submitMessageWithPictureInfo:info];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PictureMessageCellDelegate

- (void)haveClickPicture
{
    // 设置是否将table View 滚到底部cell的标示为NO table view 将不会滚动到底部
    self.shouldScrollToLastCell = NO;
    [self tapTohideOtherviews];
}

- (void)shouldHideWholePictureBrowser
{
    // 影藏图片全图浏览是恢复table view 滚动底部标示
    self.shouldScrollToLastCell = YES;
}

#pragma mark- DataCheckDelegate

- (void)dataCheckerUpdateCircleInfoSuccessWithSender:(DataChecker *)sender andCircleContects:(NSMutableArray *)contacts
{
    self.circleContactsList = contacts;
    
    self.circleInfoDic = [circle_list_model getCircleListWithCircleID:self.senderID];
    [self.messageTableView reloadData];
    [self scrollToBottomAnimated:YES];

    if (self.isJoined == NO && self.talkType == MessageListTypeCircle) {
        
        CircleDetailInviteViewController * circleDetail = [CircleDetailInviteViewController new];
        circleDetail.circleId = self.senderID;
        [self.navigationController pushViewController:circleDetail animated:YES];
        RELEASE_SAFE(circleDetail);

    }
    RELEASE_SAFE(sender);
}

#pragma mark - FatherDelegate

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date
{
    [self submitMessageWithText:text];
}

- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString*)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date
{
    NSDictionary * voiceDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               voicePath,@"voicePath",
                               voiceDuration,@"voiceDuration",
                               nil];
    [self submitMessageWithVoiceDic:voiceDic];
    
}

#pragma mark - Media ShareViewDelegate
//点击多媒体选择控件中的按钮回调 目前只开放了选择图片功能
- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            QBImagePickerController *imagePicker = [[QBImagePickerController alloc]init];
            imagePicker.showsCancelButton = YES;
            imagePicker.filterType = QBImagePickerFilterTypeAllPhotos;
            imagePicker.fullScreenLayoutEnabled = YES;
            imagePicker.allowsMultipleSelection = YES;
            imagePicker.limitsMaximumNumberOfSelection = YES;
            imagePicker.maximumNumberOfSelection = IMG_SELECT_MAX_NUM;
            imagePicker.delegate = self;
            
            CRNavigationController *nav = [[CRNavigationController alloc]initWithRootViewController:imagePicker];
            [self presentViewController:nav animated:YES completion:nil];
            RELEASE_SAFE(nav);
            RELEASE_SAFE(imagePicker);
        }
            break;
        case 1:
        {
            BOOL canUseCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
            if (canUseCamera) {
                UIImagePickerController * imageCamera = [[UIImagePickerController alloc]init];
                imageCamera.editing = YES;
                imageCamera.delegate = self;
                imageCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:imageCamera animated:YES];
                RELEASE_SAFE(imageCamera);
            } else {
                [Common checkProgressHUDShowInAppKeyWindow:@"设备不支持该功能" andImage:nil];
            }
        }
            break;
        case 2:
        {
            [Common checkProgressHUD:@"尽请期待" andImage:nil showInView:APPKEYWINDOW];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - EmotionViewDelegate

- (void)sendMessage
{
    NSString * text = self.messageInputView.inputTextView.text;
    if ([self judgeNilMessageAndShowAlertForText:text]) {
        return;
    }
    [self submitMessageWithText:self.messageInputView.inputTextView.text];
    self.messageInputView.inputTextView.text = nil;
}

- (void)openEmotionStore
{
    EmotionStoreViewController * storeController = [[EmotionStoreViewController alloc]init];
    storeController.delegate = self;
    [self.navigationController pushViewController:storeController animated:YES];
    RELEASE_SAFE(storeController);
}

- (void)didSelecteEmoticonItem:(EmoticonItemData *)emoticonItem atIndexPath:(NSIndexPath *)indexPath
{
    CustomEmotionData * tempEmoticonData =  [emoticonItem generateCustomEmotionData];
    [self submitCustomMessageWithCustomEmotionData:tempEmoticonData];
}

#pragma mark - scrollDelegate
//add by devin
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [headerView egoRefreshScrollViewDidScroll:scrollView];
}
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [headerView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - egoRefreshTableHeaderDelegate

-(void) egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    [self LoadingTableViewData]; //加载数据
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];//加载完成
}

//上拉刷新加载数据
-(void)LoadingTableViewData{
    [self loadSessionListAndScrollToBottomOrNot:NO];
}

// 加载完成
-(void)doneLoadingTableViewData{
    [headerView egoRefreshScrollViewDataSourceDidFinishedLoading:self.messageTableView];
}

#pragma mark - VoiceCellDelegate 

- (void)voiceMessageDidFinishedPlay:(id)sender
{
    VoiceMessageCell * currentCell = (VoiceMessageCell *)sender;
    
    NSInteger currentCellIndex;
    currentCellIndex = [self.unreadVoiceObjects indexOfObject:currentCell.voiceObject];
    //取出下一条未读消息播放并从未读数组移除
    if (currentCellIndex >= 0 && currentCellIndex +1 < self.unreadVoiceObjects.count)
    {
        VoiceData * nextVoiceData = [self.unreadVoiceObjects objectAtIndex:currentCellIndex + 1];
        VoiceMessageCell * nextCell = (VoiceMessageCell *)nextVoiceData.currentCell;
        if (nextCell != nil && [nextCell respondsToSelector:@selector(playCurrentVoice)]) {
            [nextCell playCurrentVoice];
        }
    }
    [self.unreadVoiceObjects removeObject:currentCell.voiceObject];
}

#pragma mark - EmoticonStoreViewControllerDelegate

- (void)downloadEmoticonSuccess
{
    [self loadEmotionView];
}

- (void)dealloc
{
    //booky
    self.unreadVoiceObjects = nil;
    self.sessionInfoList = nil;
    self.dataManager = nil;
    self.circleInfoDic = nil;
    self.messageTableView.delegate = nil;
    self.messageTableView = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotiSendMessageSuccess object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotiConfirmJoinCircle object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotiReceiveTempCircleMsg object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KNotiCircleBeOut object:nil];

    LOG_RELESE_SELF;
    [super dealloc];
}

@end
