//
//  MessageListViewController.m
//  ql
//
//  Created by yunlai on 14-2-26.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//
#import "Common.h"
#import "MessageListViewController.h"
#import "personalmessageCell.h"
#import "circleMessageCell.h"
#import "SidebarViewController.h"
#import "CRNavigationController.h"
#import "SessionViewController.h"
#import "NetManager.h"
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
#import "EmotionStoreManager.h"
#import "userInfo_setting_model.h"

#import "YLNullViewReminder.h"

@interface MessageListViewController () <EmotionStroeManagerDelegate>{
    
}

//主聊天列表table
@property (nonatomic, retain) UITableView *mainTableView;

//搜索栏
@property (nonatomic , retain) UISearchBar *searchBar;

//搜索最终数据
@property (nonatomic, retain) NSMutableArray *searchResults;

//列表数据
@property(nonatomic, retain) NSMutableArray * messageList;

//搜索控制器
@property (nonatomic , retain) UISearchDisplayController *searchCtl;


@end

@implementation MessageListViewController
@synthesize messageList = _messageList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isTouchCell = NO;
        self.messageList = [[[NSMutableArray alloc]init]autorelease];
        self.searchResults = [[[NSMutableArray alloc] init]autorelease];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInfoLists) name:kNotiReceivePersonMessage object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInfoLists) name:kNotiInviteMessageReceive object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInfoLists) name:kNotiReceiveTempCircleMsg object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInfoLists) name:kNotiUpdateTempCircleInfo object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//配置界面属性
    [self setUp];
    
    //加载小秘书和组织方欢迎信息
    if ([self checkFirstIntoMessageList]) {
        [self accessService];
    }
    
    EmotionStoreManager * emoticonManager = [[EmotionStoreManager alloc]init];
    emoticonManager.delegate = self;
    [Global sharedGlobal].isFirstInstall = [emoticonManager judgeFirstInstallAndLoadDownloadedEmoticon];
    if (![Global sharedGlobal].isFirstInstall) {
        RELEASE_SAFE(emoticonManager);
    }
    
    //加载navigation风格和聊天列表
    [self rightBarButton];
    [self loadNavigationBarBtn];
    [self loadMainView];
    [self loadSearchBar];
}

- (BOOL)checkFirstIntoMessageList
{
    NSDictionary * loginDic = [userInfo_setting_model getUserSettingInfo];
    int checkedSign = [[loginDic objectForKey:@"chat_message_checked"]intValue];
    if (checkedSign == 1) {
        return NO;
    } else {
        return YES;
    }
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

- (void)loadSearchBar{
    UISearchBar * tempSearch = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar = tempSearch;
    RELEASE_SAFE(tempSearch);
    self.searchBar.frame = CGRectMake(0.0f, 0.f, KUIScreenWidth, 44.0f);
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeDefault;
	self.searchBar.backgroundColor=[UIColor clearColor];
	self.searchBar.translucent= YES;
	self.searchBar.placeholder=@"搜索";
	self.searchBar.delegate = self;
    //设置为聊天列表头
    self.mainTableView.tableHeaderView = self.searchBar;
    
    //搜索控制器
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];

    self.searchCtl = searchController;
    RELEASE_SAFE(searchController);
    
    self.searchCtl.active = NO;
    self.searchCtl.searchResultsDataSource = self;
    self.searchCtl.searchResultsDelegate = self;
    self.searchCtl.delegate = self;
    self.searchCtl.searchResultsTableView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
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
    NSMutableArray * charArr = [chatlistGeter getList];
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
- (void)loadNavigationBarBtn{
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
    UITableView * tempTable = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight - 44.0f) style:UITableViewStylePlain];
    
    self.mainTableView = tempTable;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.separatorColor = [[ThemeManager shareInstance]getColorWithName:@"COLOR_AUXILIARY"];
    RELEASE_SAFE(tempTable);
    
    if (IOS_VERSION_7) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    self.mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainTableView];
}

/**
 * 上bar右侧按钮
 */

- (void)rightBarButton{
    UIButton *rightButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(rightBtnClickInChat) forControlEvents:UIControlEventTouchUpInside];
    UIImage* image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_chat.png"];
    [rightButton setImage:image forState:UIControlStateNormal];
    
    rightButton.frame = CGRectMake(320 - 50 , 30, 44.f, 44.f);

    UIBarButtonItem  *rightItem = [[UIBarButtonItem  alloc]initWithCustomView:rightButton];
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
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    RELEASE_SAFE(selectMenberController);
    RELEASE_SAFE(nav);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

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
    
    //判断是否为搜索框数据
    if (tableView == _searchCtl.searchResultsTableView)
    {
        messageDic = [_searchResults objectAtIndex:indexPath.row];
    }else{
        messageDic = [_messageList objectAtIndex:indexPath.row];
    }
    
    OriginCell * cell = [OriginCell cellFromListDic:messageDic andTableView:tableView];
    [cell freshWithInfoDic:messageDic];
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == _searchCtl.searchResultsTableView) {
        [_searchBar resignFirstResponder];
        [self turnToSessionViewControllerWithDic:_searchResults[indexPath.row]];
    }else{
        [self turnToSessionViewControllerWithDic:[_messageList objectAtIndex:indexPath.row]];
    }
}

- (void)turnToSessionViewControllerWithDic:(NSDictionary *)dic
{
    SessionViewController * session = [[SessionViewController alloc]init];
    session.selectedDic = dic;
    //从临时圈子创建流程过来的时候字典数据需要适配
    if ([dic objectForKey:@"id"] != nil) {
        NSDictionary * translateDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [dic objectForKey:@"id"],@"sender_id",
                                       [dic objectForKey:@"title"],@"name",
                                       [dic objectForKey:@"talk_type"],@"talk_type",
                                       nil];
        session.selectedDic = translateDic;
    }
    
    if ([[session.selectedDic objectForKey:@"talk_type"]intValue] == MessageListTypeCircle|| [[session.selectedDic objectForKey:@"talk_type"]intValue] == MessageListTypeTempCircle) {
        
        db_model * cmListGeter = nil;
        if ([[session.selectedDic objectForKey:@"talk_type"]intValue] == MessageListTypeCircle) {
            cmListGeter =[[circle_member_list_model alloc]init];
        } else if ([[session.selectedDic objectForKey:@"talk_type"]intValue] == MessageListTypeTempCircle){
            cmListGeter = [[temporary_circle_member_list_model alloc]init];
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
        NSNumber *senderIDNum = [deleteDic objectForKey:@"id"];
        
        long long receiverID  =[[Global sharedGlobal]user_id].longLongValue;
        long long senderID = [senderIDNum longLongValue];
        MessageListType talk_type = [[deleteDic objectForKey:@"talk_type"]intValue];
        
        [MessageDataManager deleteChatDBdataWithTalkType:talk_type andSenderID:senderID andReceiverID:receiverID];
        //刷新左侧边栏数目
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiUpdateLeftbarMark object:nil];
        
        [_messageList removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (_messageList.count == 0) {
            [self addNoneView];
        }
    }
}

//booky 添加空视图
-(void) addNoneView{
    YLNullViewReminder* noneView = [[YLNullViewReminder alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, KUIScreenHeight - 80) reminderImage:IMGREADFILE(@"img_chat_default1.png") reminderTitle:@"暂时没有新消息"];
    noneView.tag = 10000;
    noneView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    [self.view addSubview:noneView];
    RELEASE_SAFE(noneView);
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
                    NSDictionary * insertDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [[Global sharedGlobal] user_id],@"id",
                                                [NSNumber numberWithInt:1],@"chat_message_checked",
                                                nil];
                    [userInfo_setting_model insertOrUpdateInfoWithDic:insertDic];
                }
                
                for (NSDictionary * infoDic in welcomeMessageArr) {
                    MessageData * welcomeMsg = [MessageData generateMessageDataWithMessageRetrieveDic:infoDic];
                    [[MessageDataManager shareMessageDataManager] restoreData:welcomeMsg];
                }
                
                [self loadInfoLists];
            }
                break;
                default:
                break;
        }
    };
    [Common securelyparseHttpResultArr:resultArray andMethod:safeMethod];
}

- (void)addChatListWithArr:(NSMutableArray *)resultArray
{
    //对所取数据按照最新的消息时间来排序
    [self orderByTimeFromArray:resultArray];
    self.messageList = resultArray;
    
    //移除noneView
    UIView* v = [self.view viewWithTag:10000];
    if (v) {
        [v removeFromSuperview];
    }
    
    if (_messageList.count == 0) {
        [self addNoneView];
    }
    
    //从新加载列表
    [self.mainTableView reloadData];
}

- (void)orderByTimeFromArray:(NSMutableArray *)arr
{
    id *objects;
    NSRange range = NSMakeRange(0, arr.count );
    objects = malloc(sizeof(id) * range.length);
    [arr getObjects:objects range:range];
    NSArray * orderArr = [NSArray arrayWithObjects:objects count:arr.count];
    free(objects);
    
    NSArray * another = [orderArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
        int time1 = [[obj1 objectForKey:@"send_time"]intValue];
        int time2 = [[obj2 objectForKey:@"send_time"]intValue];
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
    
    for (int i = 0; i < arr.count; i ++) {
        [arr replaceObjectAtIndex:i withObject:[another objectAtIndex:i]];
    }
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
    [self turnToSessionViewControllerWithDic:circleDic];
    
    RELEASE_SAFE(sender);
}

#pragma mark - UISearchBarDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    UISearchBar *searchBar = self.searchCtl.searchBar;
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
            if ([subView isKindOfClass:[UIButton class]])
            {
                UIButton *cannelButton = (UIButton*)subView;
                [cannelButton setTitle:@"取消"forState:UIControlStateNormal];
                break;
            }
        }
    }
}

- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    [self.searchResults removeAllObjects];
    NSMutableArray* allContactAndCompanyArr = [NSMutableArray arrayWithCapacity:self.messageList.count];
    
    for (NSDictionary* dic in self.messageList) {
//        booky 8.8 老该字段名 以后该记得把相关部分一起该了好么
        NSString* str = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"title"],[dic objectForKey:@"content"]];
        [allContactAndCompanyArr addObject:str];
    }
    
    //不包含中文的搜索
    if (self.searchBar.text.length > 0 && ![Common isIncludeChineseInString:self.searchBar.text]) {
        for (int i=0; i<allContactAndCompanyArr.count; i++) {
          
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

#pragma mark - EmotionStoreManagerDelegate
- (void)getEmotionStoreDataSuccessWithDic:(NSDictionary *)dataDic sender:(EmotionStoreManager *)sender
{
    NSArray * emoticonsArr = [dataDic objectForKey:@"emoticons"];
    for (NSDictionary * emoticonDic in emoticonsArr) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSInteger emoticonID = [[emoticonDic objectForKey:@"emoticon_id"]integerValue];
            EmotionStoreManager * detailManager = [[EmotionStoreManager alloc]init];
            detailManager.delegate = self;
            BOOL sign = [detailManager judgeShouldAndLoadDownloadedDetailEmoticonWithEmoticonID:emoticonID];
            if (!sign) {
                RELEASE_SAFE(detailManager);
            }
        });
    }
    
    RELEASE_SAFE(sender);
}

- (void)dealloc
{
    LOG_RELESE_SELF;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.searchBar = nil;
    self.searchResults = nil;
    self.searchCtl = nil;
    self.messageList = nil;
    self.mainTableView = nil;
    [super dealloc];
}
@end
