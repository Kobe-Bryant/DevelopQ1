//
//  MessageListViewController.m
//  ql
//
//  Created by yunlai on 14-2-26.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//
#import "Common.h"
#import "MessageListViewController.h"
#import "SGActionView.h"
#import "personalmessageCell.h"
#import "circleMessageCell.h"
#import "SidebarViewController.h"
#import "CRNavigationController.h"
#import "SessionViewController.h"
#import "NetManager.h"
#import "login_info_model.h"
#import "Global.h"
#import "login_organization_model.h"
#import "SBJson.h"
#import "PictureData.h"
#import "TextData.h"
#import "chatmsg_list_model.h"
#import "invite_join_circlemsg_model.h"
#import "personal_chat_msg_model.h"
#import "NSString+MessageDataExtension.h"
#import "circle_member_list_model.h"
#import "temporary_circle_member_list_model.h"
#import "MessageDataManager.h"
#import "PinYinForObjc.h"

@interface MessageListViewController (){
    CGPoint _touchBeginPoint;
    UIPanGestureRecognizer *_slideViewGesture;
}
@end

@implementation MessageListViewController
@synthesize msgType;
@synthesize messageList = _messageList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.msgType = MessageListTypePerson;
        self.isTouchCell = NO;
        
        _messageList = [[NSMutableArray alloc]init];
        _organizeList = [[NSMutableArray alloc]init];
        _searchResults = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageWith:) name:@"chatMessageReceive" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInfoLists) name:@"inviteMessageReceive" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageWith:) name:kNotiReceiveTempCircleMsg object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMessageListData) name:kNotiUpdateTempCircleInfo object:nil];
    }
    return self;
}

- (void)reloadMessageListData
{
    [self loadInfoLists];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//配置界面属性
    [self setUp];
    
    //加载小秘书和组织方欢迎信息
    BOOL isWelcomed = [[[NSUserDefaults standardUserDefaults]objectForKey:@"GetWelcome"]boolValue];
    if (isWelcomed != YES) {
        [self accessService];
    }
    //加载navigation风格和聊天列表
    [self rightBarButton];
    
    if (msgType == MessageListTypePerson) {
        [self initNavigationBarBtn];
    }
    [self loadMainView];
    
    [self initSearchBar];
    
}

- (void)setUp
{
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    self.navigationItem.title = @"聊一聊";
    
    //在聊天界面设置主题
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)initSearchBar{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.frame = CGRectMake(0.0f, 0.f, KUIScreenWidth, 44.0f);
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_searchBar.keyboardType = UIKeyboardTypeDefault;
	_searchBar.backgroundColor=[UIColor clearColor];
	_searchBar.translucent= YES;
	_searchBar.placeholder=@"搜索";
	_searchBar.delegate = self;
    
//    float version = [[[ UIDevice currentDevice ] systemVersion ] floatValue ];
//    if ([ _searchBar respondsToSelector : @selector (barTintColor)]) {
//        float  iosversion7_1 = 7.1 ;
//        if (version >= iosversion7_1)
//        {  //iOS7.1
//            [[[[ _searchBar . subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
//            [ _searchBar setBackgroundColor :[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
//        }
//        else
//        {
//            //iOS7.0
//            [ _searchBar setBarTintColor :[ UIColor clearColor ]];
//            [ _searchBar setBackgroundColor :[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
//        }}
//    else
//    {
//        //iOS7.0 以下
//        [[ _searchBar.subviews objectAtIndex : 0 ] removeFromSuperview ];
//        [ _searchBar setBackgroundColor :[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
//    }
    
    //    if (IOS_VERSION_7) {
    //        _searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    //    }
    
    _mainTableView.tableHeaderView = _searchBar;
    
    //搜索控制器
    _searchCtl = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchCtl.active = NO;
    _searchCtl.searchResultsDataSource = self;
    _searchCtl.searchResultsDelegate = self;
    _searchCtl.delegate = self;
    _searchCtl.searchResultsTableView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadInfoLists];
}

- (void)loadInfoLists
{
    if (self.messageList.count > 0) {
        [self.messageList removeAllObjects];
    }
    chatmsg_list_model * chatlistGeter =[[chatmsg_list_model alloc]init];
    chatlistGeter.orderBy = @"unreaded";
    NSArray * charArr = [chatlistGeter getList];
    NSLog(@"loadInfoLists charArr %@",charArr);
    [self addChatListWithArr:charArr];
    RELEASE_SAFE(chatlistGeter);
}

- (void)accessService {
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:60],@"user_id",
                                    [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                    nil];
    
    [[NetManager sharedManager] accessService:jsonDic data:nil command:CHAT_WELCOME_COMMAND_ID accessAdress:@"member/welcome.do?param=" delegate:self withParam:nil];
}

/**
 *  实例化导航栏按钮
 */
- (void)initNavigationBarBtn{
    //返回按钮
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_header.png"];
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20 , 30, 44.f, 44.f);
    if (IOS_VERSION_7) {
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    }
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    RELEASE_SAFE(backItem);
}
/**
 *  返回事件
 */
- (void)backTo{
    if (![[SidebarViewController share]sideBarShowing]) {
        [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionLeft duration:0.15];
    }else{
        [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionNone duration:0.15];
    }
}

/**
 *  主页布局
 */
- (void)loadMainView{
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight - 44.0f) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.showsVerticalScrollIndicator = NO;
    //    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    
    if (IOS_VERSION_7) {
        [_mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    _mainTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_mainTableView];
    
//    UIImage * themeIconImg = [[ThemeManager shareInstance] getThemeImage:@"ico_common_header.png"];
//    UIImageView * themeIcon = [[UIImageView alloc]initWithImage:themeIconImg];
//    themeIcon.frame = CGRectMake(KUIScreenWidth /2 - themeIcon.frame.size.width/2, -themeIcon.frame.size.height -10, themeIcon.frame.size.width, themeIcon.frame.size.height);
//    [_mainTableView addSubview:themeIcon];
//    RELEASE_SAFE(themeIcon); //add vincent
}

/**
 * 上bar右侧按钮
 */

- (void)rightBarButton{
    
    UIButton *rightButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    
    [rightButton addTarget:self action:@selector(rightBtnClickInChat) forControlEvents:UIControlEventTouchUpInside];
    //    UIImage *image = [[UIImage alloc ]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ico_common_chat" ofType:@"png"]];
    UIImage* image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_chat.png"];
    [rightButton setImage:image forState:UIControlStateNormal];
    
    rightButton.frame = CGRectMake(320 - 50 , 30, 44.f, 44.f);
    //    RELEASE_SAFE(image);
    
    UIBarButtonItem  *rightItem = [[UIBarButtonItem  alloc]  initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    RELEASE_SAFE(rightItem);
}


#pragma mark - event Method
- (void)rightBtnClickInChat{
    choicelinkmanViewController *selectMenberController = [[choicelinkmanViewController alloc] init];
    selectMenberController.title = @"开始新的聊天";
    selectMenberController.accessType = AccessPageTypeChat;
    selectMenberController.delegate = self;
    selectMenberController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    selectMenberController.isStartChat = YES;
    
    CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:selectMenberController];
    [self.navigationController presentModalViewController:nav animated:YES];
    RELEASE_SAFE(selectMenberController);
    RELEASE_SAFE(nav);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _searchCtl.searchResultsTableView) {
        return _searchResults.count;
    }
    return _messageList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *messageDic;
    
    if (tableView == _searchCtl.searchResultsTableView) {
        messageDic = [_searchResults objectAtIndex:indexPath.row];
    }else{
        messageDic = [_messageList objectAtIndex:indexPath.row];
    }
    
    int listType = [[messageDic objectForKey:@"talk_type"]intValue];
    MessageListType type = listType;
    originCell * cell = nil;
    
    switch (type) {
        case MessageListTypePerson:
        case MessageListTypeSecretory:
        case MessageListTypeOrg:
            //个人好友消息
        {
            NSString *cellIdentifierPerson = @"personCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierPerson];
            
            if (cell == nil) {
                cell = [[[personalmessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierPerson] autorelease];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            
            [cell freshWithInfoDic:messageDic];
        }
            break;
        case MessageListTypeTempCircle:
        case MessageListTypeCircle:
            //圈子消息记录
        {
            NSString *cellIdentifierCircle = @"circleCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierCircle];
            
            if (cell == nil) {
                cell = [[[circleMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierCircle] autorelease];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            
            [cell freshWithInfoDic:messageDic];
        }
            break;
        case MessageListTypeHave:
        case MessageListTypeWant:
        {
            NSString* wantHaveIdentifier = @"wantHaveCell";
            cell = [tableView dequeueReusableCellWithIdentifier:wantHaveIdentifier];
            if (cell == nil) {
                cell = [[[personalmessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wantHaveIdentifier] autorelease];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            [cell freshWithInfoDic:messageDic];
        }
            break;
        default:
        {
            NSString *cellListWerid = @"cellListWerid";
            cell = [[[originCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellListWerid]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.contentView.backgroundColor = [UIColor redColor];
        }
            break;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)turnToSessionViewControllerWithDic:(NSDictionary *)dic
{
    SessionViewController * session = [[SessionViewController alloc]init];
    session.selectedDic = dic;
    //从 临时圈子创建流程过来的时候字典数据需要适配
    if ([dic objectForKey:@"id"] != nil) {
        NSDictionary * translateDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [dic objectForKey:@"id"],@"sender_id",
                                       [dic objectForKey:@"title"],@"name",
                                       [dic objectForKey:@"talk_type"],@"talk_type",
                                       nil];
        session.selectedDic = translateDic;
    }
    
    if ( [[session.selectedDic objectForKey:@"talk_type"]intValue] == MessageListTypeCircle|| [[session.selectedDic objectForKey:@"talk_type"]intValue] == MessageListTypeTempCircle) {
        
        db_model * cmListGeter = nil;
        if ([[session.selectedDic objectForKey:@"talk_type"]intValue] == MessageListTypeCircle) {
            cmListGeter =[[circle_member_list_model alloc]init];
        } else if ([[session.selectedDic objectForKey:@"talk_type"]intValue] == MessageListTypeTempCircle){
            cmListGeter = [temporary_circle_member_list_model new];
        }
        
        NSString * whereStr = [NSString stringWithFormat:@"circle_id = %lld",[[session.selectedDic objectForKey:@"sender_id"]longLongValue]];
        cmListGeter.where = whereStr;
        NSMutableArray * cmList = [cmListGeter getList];
        session.circleContactsList = cmList;
        RELEASE_SAFE(cmListGeter);
    }
    
    [self.navigationController pushViewController:session animated:YES];
    RELEASE_SAFE(session);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && tableView != _searchCtl.searchResultsTableView) {
        
        NSDictionary * deleteDic = [self.messageList objectAtIndex:indexPath.row];
        NSNumber *senderIDNum = [deleteDic objectForKey:@"sender_id"];
        
        long long receiverID  =[[Global sharedGlobal]user_id].longLongValue;
        long long senderID = [senderIDNum longLongValue];
        MessageListType talk_type = [[deleteDic objectForKey:@"talk_type"]intValue];
        
        [MessageDataManager deleteChatDBdataWithTalkType:talk_type andSenderID:senderID andReceiverID:receiverID];
      
        [_messageList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * currentCell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray * subViews = currentCell.subviews;
    NSLog(@"-----%@",subViews);
    UIView * scrollView = [subViews firstObject];
    NSLog(@"-----%@",scrollView);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _searchCtl.searchResultsTableView) {
        return NO;
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    NSLog(@"_messageList:%@",_messageList);
    if (tableView == _searchCtl.searchResultsTableView) {
        [_searchBar resignFirstResponder];
        [self turnToSessionViewControllerWithDic:_searchResults[indexPath.row]];
    }else{
        [self turnToSessionViewControllerWithDic:[_messageList objectAtIndex:indexPath.row]];
    }
}


#pragma mark - NetWorkManagerDelegate

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    NSLog(@"didFinishCommand MessageDataManager %@",resultArray);
    
    ParseMethod safeMethod = ^(){
        switch (commandid) {
            case CHAT_WELCOME_COMMAND_ID:
            {
                //第一次点击聊一聊界面 获取欢迎消息逻辑处理
                NSDictionary * resultDic = [resultArray firstObject];
                NSArray * welcomeMessageArr = [resultDic objectForKey:@"welcomes"];
                //如果获取成功则设置 用户默认值 下次进入该界面时不会拉取欢迎信息
                if (welcomeMessageArr.count > 0) {
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"GetWelcome"];
                }
                
                for (NSDictionary * infoDic in welcomeMessageArr) {
                    MessageData * welcomeMsg = [MessageData generateMessageDataWithMessageRetrieveDic:infoDic];
                    [[MessageDataManager shareMessageDataManager] restoreData:welcomeMsg];
                }
                
                [self loadInfoLists];
            }
                break;
                
            case GROUP_MEMBER_LIST_COMMAND_ID:
            {
                NSLog(@"Get gourp list %@",resultArray);
                [self loadInfoLists];
            }
                break;
            default:
                break;
        }
    };
    [Common securelyparseHttpResultArr:resultArray andMethod:safeMethod];
}

- (void)addChatListWithArr:(NSArray *)resultArray{
    if (resultArray.count != 0 && ![[resultArray firstObject] isKindOfClass:[NSString class]] ) {
        for (NSDictionary *dic in resultArray) {
            
            NSString *content = [dic objectForKey:@"content"];
            NSArray * msgArr = nil;
            if (content != nil && ![content isEqualToString:@""]) {
                msgArr = [content JSONValue];
            }
            NSDictionary * msgDic = [msgArr firstObject];
            NSString * messageStr = nil;
            
            // New 出来一个数据对象 完成插入字典数据到messagelist 后释放
            if ([[msgDic objectForKey:@"objtype"]intValue] == dataTypeText) {
                TextData * textData = [[TextData alloc]initWithDic:msgDic];
                messageStr = textData.txt;
                //释放掉之前创建的Datas
                RELEASE_SAFE(textData);
            } else if ([[msgDic objectForKey:@"objtype"]intValue] == dataTypePicture){
                messageStr = @"图片消息";
            } else if ([[msgDic objectForKey:@"objtype"]intValue] == dataTypeVoice) {
                messageStr = @"语音消息";
            }
            // 防止messageStr 为空导致后面插入的dictionary数据不完全
            if (messageStr == nil) {
                messageStr = @"消息";
            }
            
            NSNumber *sender_id = [dic objectForKey:@"id"];
            NSString * title = [dic objectForKey:@"title"];
            NSNumber *unreadNum = [dic objectForKey:@"unreaded"];
            NSNumber * time = [dic objectForKey:@"send_time"];
            NSString * portraitJsonStr = [dic objectForKey:@"icon_path"];
            NSNumber * invitedSign = [dic objectForKey:@"invited_sign"];
            NSMutableArray * portraitArr = nil;
            if (portraitJsonStr != nil && ![portraitJsonStr isEqualToString:@""]) {
                portraitArr = [portraitJsonStr JSONValue];
            }
            
            if (portraitArr == nil) {
                portraitArr = [NSMutableArray arrayWithObjects:DEFAULT_MALE_PORTRAIT_NAME, nil];
            }
            
            NSNumber * speaker_id = [NSNumber numberWithInt:[[dic objectForKey:@"speak_id"]intValue]];
            
            // 判断Type  1 为组织方 2 为小秘书 3 为单聊 4为圈子聊 5为临时圈子聊天
            int talk_type = [[dic objectForKey:@"talk_type"]intValue];
            NSDictionary *getDic = nil;
            
            switch (talk_type) {
                case MessageListTypeOrg:
                    break;
                case MessageListTypeSecretory:
                    break;
                case MessageListTypePerson:
                case MessageListTypeCircle:
                case MessageListTypeTempCircle:
                    break;
                default:
                    break;
            }
            
            //将得到的数据项拼凑成可用的dictionary 然后插入到_Messagelist 列表中
            for (int i = 0; i < _messageList.count; i++) {
                NSDictionary *listDic = [_messageList objectAtIndex:i];
                if ([[listDic objectForKey:@"sender_id"]longLongValue] == sender_id.longLongValue){
                    
                    getDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              sender_id,@"sender_id",
                              unreadNum,@"messageSum",
                              title,@"name",
                              time,@"time",
                              portraitArr, @"portrait",
                              messageStr,@"message",
                              [NSNumber numberWithInt:talk_type],@"talk_type",
                              nil];
                    
                    
                    if (getDic != nil) {
                        [_messageList replaceObjectAtIndex:i withObject:getDic];
                    }
                }
            }
            if (getDic == nil) {
                getDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          sender_id,@"sender_id",
                          unreadNum,@"messageSum",
                          title,@"name",
                          time,@"time",
                          messageStr,@"message",
                          portraitArr,@"portrait",
                          [NSNumber numberWithInt:talk_type],@"talk_type",
                          speaker_id,@"speaker_id",
                          invitedSign,@"invitedSign",
                          nil];
                
                if (_messageList.count > 2) {
                    [_messageList insertObject:getDic atIndex:0];
                } else {
                    [_messageList addObject:getDic];
                }
            }
        }
        
        // 根据发送时间来对 除小秘书和组织方之外的消息排序
        id *objects;
        NSRange range = NSMakeRange(0, _messageList.count );
        objects = malloc(sizeof(id) * range.length);
        [_messageList getObjects:objects range:range];
        NSArray * orderArr = [NSArray arrayWithObjects:objects count:_messageList.count];
        free(objects);
        
        NSArray * another = [orderArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
            int time1 = [[obj1 objectForKey:@"time"]intValue];
            int time2 = [[obj2 objectForKey:@"time"]intValue];
            //排序逻辑 以发送时间排序， 如果发送时间相同则按照id升序排列
            if (time1 > time2) {
                return NSOrderedAscending;
            } else if (time1 < time2) {
                return NSOrderedDescending;
            } else {
                if ([[obj1 objectForKey:@"sender_id"]longLongValue] > [[obj2 objectForKey:@"sender_id"]longLongValue]) {
                    return NSOrderedAscending;
                } else if ([[obj1 objectForKey:@"sender_id"]longLongValue] < [[obj2 objectForKey:@"sender_id"]longLongValue]) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }
        }];
        
        for (int i = 0; i < _messageList.count; i ++) {
            [_messageList replaceObjectAtIndex:i withObject:[another objectAtIndex:i]];
        }
        NSLog(@"_messageList %@",_messageList);
        [_mainTableView reloadData];
    }
}

#pragma mark - MessageReceiveNotification

- (void)didReceiveMessageWith:(NSNotification *)noti
{
    [self loadInfoLists];
}

#pragma mark - ChoiceLMDelegate

- (void)sureLMClick:(NSArray *)selectLMs
{
    NSLog(@"Get Contect List %@",selectLMs);
    NSMutableArray * porMuArr = [NSMutableArray new];
    
    if (selectLMs.count == 1) {
        NSDictionary * selectDic = [selectLMs firstObject];
        NSNumber * select_id = [selectDic objectForKey:@"user_id"];
        NSString * realName = [selectDic objectForKey:@"realname"];
        NSString * portraitStr = [selectDic objectForKey:@"portrait"];
        [porMuArr addObject:portraitStr];
        NSString *porJosnStr = [porMuArr JSONRepresentation];
        
        NSNumber * talk_type = [NSNumber numberWithInt:3];
        
        NSTimeInterval time = [[NSDate date]timeIntervalSince1970];
        NSNumber *timeNum = [NSNumber numberWithInt:time];
        NSNumber *unreadNum = [NSNumber numberWithInt:0];
        
        
        NSDictionary *chatInsert = [NSDictionary dictionaryWithObjectsAndKeys:select_id,@"id",realName,@"title",talk_type,@"talk_type",porJosnStr,@"icon_path",timeNum,@"send_time",unreadNum,@"unreaded",nil];
        
        chatmsg_list_model *inseter = [[chatmsg_list_model alloc]init];
        inseter.where = [NSString stringWithFormat:@"id = %d",select_id.intValue];
        NSArray *chatlist =[inseter getList];
        if (chatlist.count == 0) {
            [inseter insertDB:chatInsert];
        } else {
            [inseter updateDB:chatInsert];
        }
        
        RELEASE_SAFE(inseter);// add vincent
        
        NSArray * portraitArr = [porJosnStr JSONValue];
        // 直接跳转会话窗口
        NSDictionary * sessionDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     select_id,@"sender_id",
                                     realName,@"name",
                                     portraitArr,@"portrait",
                                     [NSNumber numberWithInt:MessageListTypePerson],@"talk_type",
                                     nil];
        [self turnToSessionViewControllerWithDic:sessionDic];
    }
    else if (selectLMs.count >1) {
        TemporaryCircleManager * tManager = [[TemporaryCircleManager alloc]init];
        tManager.tempdelegate = self;
        
        //使用临时圈子创建类来创建一个临时圈子
        tManager.memberArr = selectLMs;
        [tManager createTemporaryCielre];
    }
    RELEASE_SAFE(porMuArr);
}

#pragma mark- TemporaryCircleManagerDelegate

- (void)createTemporaryCircleSuccessWithSender:(id)sender CircleDic:(NSDictionary *)circleDic{
    
    [self loadInfoLists];
    [self turnToSessionViewControllerWithDic:circleDic];
    
    RELEASE_SAFE(sender);
}

#pragma mark - UISearchBarDelegate

-(void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    //    if (IOS_VERSION_7) {
    //        controller.searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    //    }
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    UISearchBar *searchBar = self.searchCtl.searchBar;
    
    //    if (IOS_VERSION_7) {
    //        searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"];
    //    }
    
    [searchBar setShowsCancelButton:YES animated:NO];
    
    // 改变cannel按钮的文字 ios 5.0, 6.0
    for (UIView *subView in searchBar.subviews)
    {
        // 获得UINavigationButton按钮，也就是Cancel按钮对象，并修改此按钮的各项属性
        if ([subView isKindOfClass:[UIButton class]]) {
            
            UIButton *cannelButton = (UIButton*)subView;
            
            [cannelButton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
    
    // 改变cannel按钮的文字,7.0
    UIView *subView0 = searchBar.subviews[0]; // IOS7.0中searchBar组成复杂点
    
    if (IOS_VERSION_7) {
        
        for (UIView *subView in subView0.subviews)
        {
            // 获得UINavigationButton按钮，也就是Cancel按钮对象，并修改此按钮的各项属性
            if ([subView isKindOfClass:[UIButton class]]) {
                
                UIButton *cannelButton = (UIButton*)subView;
                
                [cannelButton setTitle:@"取消"forState:UIControlStateNormal];
                
                break;
            }
        }
    }
}

- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    [_searchResults removeAllObjects];
    
    NSMutableArray* allContactAndCompanyArr = [NSMutableArray arrayWithCapacity:_messageList.count];
    
    for (NSDictionary* dic in _messageList) {
        NSString* str = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"name"],[dic objectForKey:@"message"]];
        [allContactAndCompanyArr addObject:str];
        NSLog(@"--dic:%@--",dic);
    }
    
    //不包含中文的搜索
    if (self.searchBar.text.length > 0 && ![Common isIncludeChineseInString:self.searchBar.text]) {
        
        //        for (int i=0; i<allContactsArr.count; i++) {
        for (int i=0; i<allContactAndCompanyArr.count; i++) {
            
            // 判断NSString中的字符是否为中文
            //            if ([Common isIncludeChineseInString:[allContactsArr[i] objectForKey:@"realname"]]) {
            if ([Common isIncludeChineseInString:allContactAndCompanyArr[i]]) {
                
                // 转换为拼音
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:allContactAndCompanyArr[i]];
                
                // 搜索是否在转换后拼音中
                NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    
                    [_searchResults addObject:_messageList[i]];
                    
                }else{
                    // 转换为拼音的首字母
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:allContactAndCompanyArr[i]];
                    
                    // 搜索是否在范围中
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    
                    if (titleHeadResult.length>0) {
                        
                        [_searchResults addObject:_messageList[i]];
                        
                    }
                }
                
            }
            else {
                
                NSRange titleResult=[allContactAndCompanyArr[i] rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    [_searchResults addObject:_messageList[i]];
                }
            }
        }
        // 搜索中文
    } else if (self.searchBar.text.length>0 && [Common isIncludeChineseInString:self.searchBar.text]) {
        
        for (int i=0; i<allContactAndCompanyArr.count; i++) {
            NSString *tempStr = allContactAndCompanyArr[i];
            
            NSRange titleResult=[tempStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            
            if (titleResult.length>0) {
                [_searchResults addObject:[_messageList objectAtIndex:i]];
            }
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    if ([_searchResults count] == 0) {
        
        UITableView *tableView1 = self.searchCtl.searchResultsTableView;
        
        for( UIView *subview in tableView1.subviews ) {
            
            if([subview isKindOfClass:[UILabel class]]) {
                
                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                
                lbl.text = [NSString stringWithFormat:@"没有找到\"%@\"相关的联系人",self.searchBar.text];
                
            }
        }
        
    }
    // Return YES to cause the search result table view to be reloaded.
    return YES;
    
}


- (void)dealloc
{
    RELEASE_SAFE(_searchResults);
    RELEASE_SAFE(_searchBar);
    RELEASE_SAFE(_searchCtl);
    
    LOG_RELESE_SELF;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    RELEASE_SAFE(_messageList);
    RELEASE_SAFE(_mainTableView);
    RELEASE_SAFE(_organizeList);
    [super dealloc];
}
@end
