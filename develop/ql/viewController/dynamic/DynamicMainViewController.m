//
//  DynamicViewController.m
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "DynamicMainViewController.h"
#import "config.h"
#import "scanViewController.h"
#import "SidebarViewController.h"
#import "MeetingMainViewController.h"
#import "TalkingMainViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "imageBrowser.h"
#import "DyListViewController.h"

#import "MemberDetailViewController.h"
#import "MessageListViewController.h"
#import "MemberMainViewController.h"

#import "CHTumblrMenuView.h"
#import "TYDotIndicatorView.h"
#import "cardDetailViewController.h"

#import "Common.h"
#import "aboutMeMsgListViewController.h"
#import "dynamic_card_model.h"

#import "dyCardTableViewCell.h"
#import "ThemeManager.h"
#import "Global.h"
#import "NetManager.h"

@interface DynamicMainViewController (){
    //加载效果view
    TYDotIndicatorView *_darkCircleDot;
    //卡片对象组
    NSMutableArray* cardsArr;
    
    BOOL accessBeforeTable;//蛋疼bug
}

//@我 数字提醒
@property(retain,nonatomic) UILabel* redCircleView;
//底部+号发动态 按钮
@property(retain,nonatomic) UIButton* btmBtn;
//返回按钮图片
@property(retain,nonatomic) UIImage * backImg;
//空视图
@property(retain,nonatomic) UILabel* noneView;

@end

//最大卡片数目 用于是否加载更多
#define MAXCARDCOUNT 2

@implementation DynamicMainViewController
@synthesize redCircleView = _redCircleView;
@synthesize backImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cardsArr = [[NSMutableArray alloc] init];
        accessBeforeTable = NO;
        
        [self getCardsDBData];
    }
    return self;
}

//更新动态卡片数据库通知处理 用于记住点赞和投票选项
-(void) updateDyDBData:(NSNotification*) notify{
    NSDictionary* dic = (NSDictionary*)notify.object;
    NSLog(@"==update dic:%@==",dic);
    
    NSString* key = nil;
    if ([dic objectForKey:@"is_care"]) {
        key = @"is_care";
    }else{
        key = @"user_choice";
    }
    
    dynamic_card_model* cardMod = [[dynamic_card_model alloc] init];
    cardMod.where = [NSString stringWithFormat:@"id = %d",[[dic objectForKey:@"id"] intValue]];
    BOOL updateYes = [cardMod updateDB:[NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:key],key, nil]];
    
    if (updateYes) {
        NSDictionary* cardDic = [NSDictionary dictionaryWithDictionary:[cardsArr objectAtIndex:selectedIndex]];
        [cardsArr removeObjectAtIndex:selectedIndex];
        //    [cardDic setValue:[dic objectForKey:@"is_care"] forKey:@"is_care"];
        
        NSNumber* responseSum = nil;
        if ([dic objectForKey:@"response_sum"]) {
            responseSum = [NSNumber numberWithInt:[[dic objectForKey:@"response_sum"] intValue]];
        }else{
            responseSum = [NSNumber numberWithInt:[[cardDic objectForKey:@"response_sum"] intValue]];
        }
        
        NSDictionary* newDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                [cardDic objectForKey:@"id"],@"id",
                                [cardDic objectForKey:@"user_id"],@"user_id",
                                [cardDic objectForKey:@"type"],@"type",
                                [cardDic objectForKey:@"realname"],@"realname",
                                [cardDic objectForKey:@"title"],@"title",
                                [cardDic objectForKey:@"content"],@"content",
                                [cardDic objectForKey:@"pics"],@"pics",
                                [cardDic objectForKey:@"province"],@"province",
                                [cardDic objectForKey:@"city"],@"city",
                                [cardDic objectForKey:@"care_sum"],@"care_sum",
                                [cardDic objectForKey:@"comment_sum"],@"comment_sum",
                                responseSum,@"response_sum",
                                [cardDic objectForKey:@"start_time"],@"start_time",
                                [cardDic objectForKey:@"end_time"],@"end_time",
                                [cardDic objectForKey:@"url_content"],@"url_content",
                                [cardDic objectForKey:@"created"],@"created",
                                [cardDic objectForKey:@"portrait"],@"portrait",
                                [key isEqualToString:@"is_care"]?[dic objectForKey:@"is_care"]:[cardDic objectForKey:@"is_care"],@"is_care",
                                [cardDic objectForKey:@"is_choice"],@"is_choice",
                                [cardDic objectForKey:@"choice1_sum"],@"choice1_sum",
                                [cardDic objectForKey:@"choice2_sum"],@"choice2_sum",
                                [key isEqualToString:@"user_choice"]?[dic objectForKey:@"user_choice"]:[cardDic objectForKey:@"user_choice"],@"user_choice",
                                nil];
        [cardsArr insertObject:newDic atIndex:selectedIndex];
    }
    
    [cardMod release];
}

//@我 通知处理 接收IM通知，实时显示@我数据
-(void) dynamicAboutMeNotice:(NSNotification*) notify{
    NSLog(@"--aboutMe notify--");
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

- (void)viewWillAppear:(BOOL)animated{
    //查看他人动态时需显示，不然有bug
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self initTheme];
    
    //更新@我
    [self dynamicAboutMeNotice:nil];
    
    //注册新动态通知、@我通知、更新动态数据库通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDynamicNotice:) name:@"newDynamicNotice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicAboutMeNotice:) name:@"dynamicAboutMeNotice" object:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newDynamicNotice" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dynamicAboutMeNotice" object:nil];
}

//读取数据库数据
-(void) getCardsDBData{
    //读取缓存动态数据
    dynamic_card_model* cardMod = [[dynamic_card_model alloc] init];
    cardMod.orderBy = @"created";
    cardMod.orderType = @"desc";
    cardMod.limit = 20;
    cardMod.where = [NSString stringWithFormat:@"org_id = %@",[Global sharedGlobal].org_id];
    [cardsArr addObjectsFromArray:[cardMod getList]];
    [cardMod release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //配置界面属性
    [self setUp];
    DLog(@"Bar: %@  , View: %@",self.navigationController.navigationBar, self.navigationController.view);

    isLoading = NO;
    
    //注册换肤通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    
    //注册发布动态成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewCard:) name:@"addNewCard" object:nil];
    
    //注册新动态通知、@我通知、更新动态数据库通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDyDBData:) name:@"updateDyDBData" object:nil];
    
    dytableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, KUIScreenHeight - 44.0f) style:UITableViewStylePlain];
    dytableview.delegate = self;
    dytableview.dataSource = self;
    dytableview.backgroundColor = [UIColor clearColor];
    dytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:dytableview];
    
    //loading 5.21 chenfeng add
    _darkCircleDot = [[TYDotIndicatorView alloc] initWithFrame:CGRectMake(0, 0.f, KUIScreenWidth, KUIScreenHeight) dotStyle:TYDotIndicatorViewStyleCircle dotColor:[UIColor colorWithWhite:0.6 alpha:1.0] dotSize:CGSizeMake(10, 10)];
    if (IOS_VERSION_7) {
        _darkCircleDot.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.3];
    }else{
        _darkCircleDot.backgroundColor = [UIColor clearColor];
    }
    [_darkCircleDot startAnimating];
    [self.view addSubview:_darkCircleDot];
    
    //加入上拉和下拉组件
    [self addheadAndFoot];
    
    self.navigationItem.title = @"动态";
    
    [self rightBarButton];
    
    [self initButtomView];
    
    [self.view bringSubviewToFront:_darkCircleDot];
    
    if (cardsArr.count == 0) {
        
        [self accessDynamiclist];
    }else{
        [dytableview reloadData];
        [self freshRedLabAndFooter];
        
//        如果当前的数据加载完毕的话，等待界面消失  add vincent
        [self performSelector:@selector(removeLoading) withObject:nil afterDelay:1.0];
    }
}

- (void)setUp
{
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)removeLoading{
    //移除loading
    [_darkCircleDot removeFromSuperview];
}

//发布动态成功后刷新
-(void) addNewCard:(NSNotification*) notify{
    [self accessDynamiclist];
    
}

- (void)themeNotification:(NSNotification *)notification {
    if (IOS_VERSION_7) {
        [[UINavigationBar appearance] setBarTintColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"]];
    }
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_header.png"];
    
    self.backImg = image;
    
    [self backBarBtn];
}

//初始化主题
- (void)initTheme {
    NSString *themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
    if (themeName.length == 0) {
        return;
    }
    [ThemeManager shareInstance].themeName = themeName;
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:themeName];
    
    if (IOS_VERSION_7) {
        [[UINavigationBar appearance] setBarTintColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"]];
    }
}

//加上上拉和下拉部件
-(void) addheadAndFoot{
    dytableview.contentSize = CGSizeMake(self.view.bounds.size.width, (self.view.bounds.size.height/3)*cardsArr.count);
    
    footerVew = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, dytableview.contentSize.height, self.view.bounds.size.width, 50)];
    footerVew.delegate = self;
    footerVew.backgroundColor = [UIColor clearColor];
    
    [dytableview addSubview:footerVew];
    [dytableview bringSubviewToFront:footerVew];
    
    footerVew.hidden = YES;
    if (cardsArr.count >= MAXCARDCOUNT) {
        footerVew.hidden = NO;
    }
    
    headerView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 50)];
    headerView.delegate = self;
    headerView.backgroundColor = [UIColor clearColor];
    [dytableview addSubview:headerView];
}

-(void) freshRedLabAndFooter{
    //更新未读数
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
    
    if ([Global sharedGlobal].newDynamicNum != 0) {
        [self showDynamicAlert:[Global sharedGlobal].newDynamicNum];
    }
    
    dytableview.contentSize = CGSizeMake(self.view.bounds.size.width, (320)*cardsArr.count);
    footerVew.frame = CGRectMake(0, dytableview.contentSize.height, self.view.bounds.size.width, 50);
    if (cardsArr.count >= MAXCARDCOUNT) {
        footerVew.hidden = NO;
    }else{
        footerVew.hidden = YES;
    }
    
    [dytableview bringSubviewToFront:footerVew];
}

#pragma mark - scrollDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [footerVew egoRefreshScrollViewDidScroll:scrollView];
    [headerView egoRefreshScrollViewDidScroll:scrollView];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (cardsArr.count >= MAXCARDCOUNT) {
        [footerVew egoRefreshScrollViewDidEndDragging:scrollView];
    }
    [headerView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - egodelegate
-(void) egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    [self accessDynamiclist];
}

-(void) loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view{
    [self accessDLMore];
    
}
/**
 *  返回按钮
 */
- (void)backBarBtn{
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
//    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];

    [backButton setImage:self.backImg forState:UIControlStateNormal];
    
    backButton.frame = CGRectMake(0 , 30, 44.f, 44.f);
    if (IOS_VERSION_7) {
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    }
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    RELEASE_SAFE(backItem);
}

#pragma mark - event Method
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
 * 上部菜单
 */
- (void)rightBarButton{
    UIView* rightBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 60, 44)];
    
    UIButton *rightButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];

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
    [rightBarView addSubview:_redCircleView];
    
    _redCircleView.hidden = YES;
    
    UIBarButtonItem  *rightItem = [[UIBarButtonItem  alloc]  initWithCustomView:rightBarView];
    self.navigationItem.rightBarButtonItem = rightItem;
    RELEASE_SAFE(rightItem);
    
    RELEASE_SAFE(rightBarView);
}

//配置底部按钮
-(void) initButtomView{
    UIView* buttomView = [[UIView alloc] init];
    if (IOS_VERSION_7) {
       buttomView.frame = CGRectMake(0, self.view.bounds.size.height - 64 - 50, self.view.bounds.size.width, 50);
    }else{
       buttomView.frame = CGRectMake(0, self.view.bounds.size.height - 64 - 50 +20, self.view.bounds.size.width, 50);
    }
    
    buttomView.backgroundColor = [UIColor colorWithPatternImage:[[ThemeManager shareInstance] getThemeImage:@"bg_feed_shadow.png"]];
        buttomView.alpha = 0.8;
    
    [self.view addSubview:buttomView];
    
    UIImage* image = [[ThemeManager shareInstance] getThemeImage:@"btn_feed_plus.png"];
    _btmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btmBtn.backgroundColor = [UIColor clearColor];
    [_btmBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_btmBtn setImage:image forState:UIControlStateNormal];
    [_btmBtn setFrame:CGRectMake((buttomView.bounds.size.width - 50)/2, 0, 50, 50)];
    [buttomView addSubview:_btmBtn];
    
    RELEASE_SAFE(buttomView);
}

#pragma mark - +号按钮点击
-(void) addBtnClick{
    CHTumblrMenuView* _CHmenuView = [[CHTumblrMenuView alloc] init];
    [_CHmenuView addMenuItemWithTitle:@"照相" andIcon:IMG(@"ico_feed_pic") andSelectedBlock:^{
        NSLog(@"图文");
        //发布图文
//        TalkingMainViewController* talkVC = [[TalkingMainViewController alloc] init];
//        talkVC.pType = PublicImages;
//        talkVC.enterPhoto = YES;
//        [self.navigationController pushViewController:talkVC animated:NO];
//        RELEASE_SAFE(talkVC);
        
        WatermarkCameraViewController *watermarkCamera = [[WatermarkCameraViewController alloc]init];
        watermarkCamera.type = 1;
        watermarkCamera.currentImageCount = 0;
        watermarkCamera.delegate = self;
        [self presentViewController:watermarkCamera animated:YES completion:nil];
        [watermarkCamera release];
        
    }];
    [_CHmenuView addMenuItemWithTitle:@"图文" andIcon:IMG(@"ico_feed_text") andSelectedBlock:^{
        NSLog(@"图文");
        //发布图文
        TalkingMainViewController* talkVC = [[TalkingMainViewController alloc] init];
        talkVC.pType = PublicImages;
        [self.navigationController pushViewController:talkVC animated:YES];
        RELEASE_SAFE(talkVC);
        
    }];
    [_CHmenuView addMenuItemWithTitle:@"聚聚" andIcon:IMG(@"ico_feed_party") andSelectedBlock:^{
        NSLog(@"聚聚");
        MeetingMainViewController* meetVC = [[MeetingMainViewController alloc] init];
        [self.navigationController pushViewController:meetVC animated:YES];
        RELEASE_SAFE(meetVC);
    }];
    [_CHmenuView addMenuItemWithTitle:@"我有" andIcon:IMG(@"ico_feed_have") andSelectedBlock:^{
        NSLog(@"我有");
        TalkingMainViewController* talkVC = [[TalkingMainViewController alloc] init];
        talkVC.pType = PublicHave;
        [self.navigationController pushViewController:talkVC animated:YES];
        RELEASE_SAFE(talkVC);
        
    }];
    [_CHmenuView addMenuItemWithTitle:@"我要" andIcon:IMG(@"ico_feed_want") andSelectedBlock:^{
        NSLog(@"我要");
        TalkingMainViewController* talkVC = [[TalkingMainViewController alloc] init];
        talkVC.pType = PublicWant;
        [self.navigationController pushViewController:talkVC animated:YES];
        RELEASE_SAFE(talkVC);
        
    }];
    [_CHmenuView addMenuItemWithTitle:@"OOXX" andIcon:IMG(@"ico_feed_ox") andSelectedBlock:^{
        
        NSLog(@"OOXX");
        TalkingMainViewController* talkVC = [[TalkingMainViewController alloc] init];
        talkVC.pType = PublicOOXX;
        [self.navigationController pushViewController:talkVC animated:YES];
        RELEASE_SAFE(talkVC);
        
    }];
    
    [_CHmenuView show];
    RELEASE_SAFE(_CHmenuView);
}

#pragma mark - waterCamera
-(void) didSelectImages:(NSArray *)images{
    TalkingMainViewController* talkVC = [[TalkingMainViewController alloc] init];
    talkVC.pType = PublicImages;
    talkVC.selectedImages = [images mutableCopy];
    [self.navigationController pushViewController:talkVC animated:YES];
    RELEASE_SAFE(talkVC);
}

//@我点击
- (void)rightBtnClick{
    NSLog(@"++@me++");
    
    [Global sharedGlobal].dyMe_unread_num = 0;
    _redCircleView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDynamicNotice" object:nil];
    
    aboutMeMsgListViewController* aboutMeVC = [[aboutMeMsgListViewController alloc] init];
    [self.navigationController pushViewController:aboutMeVC animated:YES];
    RELEASE_SAFE(aboutMeVC);
    
}

#pragma mark - tableviewdelegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (cardsArr.count) {
        return cardsArr.count;
    }
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (cardsArr.count) {
        return 320;
    }else{
        return self.view.bounds.size.height;
    }
    return 320;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = nil;
    
    if (cardsArr.count) {
        identifier = @"tableCardCell";
        
        dyCardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[[dyCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            for (UIView* v in [cell.contentView viewWithTag:1000].subviews) {
                [v removeFromSuperview];
            }
        }
        
        cell.dataDic = [cardsArr objectAtIndex:indexPath.row];
        
        return cell;
        
    }else{
        identifier = @"noneCardCell";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            UILabel* noneLab = [[UILabel alloc] init];
            noneLab.frame = CGRectMake(0, 12, self.view.bounds.size.width, self.view.bounds.size.height);
            noneLab.textAlignment = UITextAlignmentCenter;
            noneLab.numberOfLines = 0;
            noneLab.textColor = [UIColor darkGrayColor];
            noneLab.backgroundColor = [UIColor whiteColor];
            noneLab.font = KQLboldSystemFont(15);
            
            if (accessBeforeTable) {
                noneLab.text = @"暂时还没有动态";
            }else{
                noneLab.text = @"";
            }
            
            self.noneView = noneLab;
            
            [cell.contentView addSubview:noneLab];
            
            [noneLab release];
            
        }
        
        return cell;
    }
    
    return nil;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (cardsArr.count) {
        selectedIndex = indexPath.row;
        NSDictionary* dic = [cardsArr objectAtIndex:indexPath.row];
        
        [self accessDynamicDetail:[[dic objectForKey:@"id"] intValue]];
        

//        cardDetailViewController* cardDetailVC = [[cardDetailViewController alloc] init];
//        int type = [[dic objectForKey:@"type"] intValue];
//        
//        CardType cardT;
//        if (type == 0) {
//            cardT = CardImage;
//        }else if (type == 1) {
//            cardT = CardOOXX;
//        }else if (type == 2) {
//            cardT = CardOpenTime;
//        }else if (type == 3) {
//            cardT = CardWantOrHave;
//        }else if (type == 4){
//            cardT = CardWantOrHave;
//        }else if (type == 5){
//            cardT = CardNews;
//        }else if (type == 6) {
//            cardT = CardLabel;
//        }else if (type == 8) {
//            cardT = CardTogether;
//        }else{
//            cardT = CardImage;
//        }
//        cardDetailVC.type = cardT;
//        cardDetailVC.dataDic = dic;
//        cardDetailVC.detailType = DynamicDetailTypeAll;
//        
//        [self.navigationController pushViewController:cardDetailVC animated:NO];
//        RELEASE_SAFE(cardDetailVC);
    
    }
}

#pragma mark - accessService
-(void) accessDynamicDetail:(int) publishId{
    NSString* reqUrl = @"member/publishDetail.do?param=";
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:publishId],@"publish_id",
                                       [Global sharedGlobal].user_id,@"user_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_DETAIL_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

//请求动态列表
-(void) accessDynamiclist{
    NSString *reqUrl = @"member/publishlist.do?param=";
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
//                                       [Global sharedGlobal].province,@"province",
//                                       [Global sharedGlobal].locationCity,@"city",
//                                       [NSNumber numberWithInt:0],@"id",
                                       nil];
    
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_MAINLIST_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

-(void) accessDynamicRelationMe{
    NSString* reqUrl = @"publish/relationme.do?param=";
    
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_RELATIONME_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}
//请求动态加载更多
-(void) accessDLMore{
    NSString* reqUrl = @"member/publishlist.do?param=";
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
//                                       [Global sharedGlobal].province,@"province",
//                                       [Global sharedGlobal].locationCity,@"city",
                                       [NSNumber numberWithInt:[[[cardsArr lastObject] objectForKey:@"id"] intValue]],@"id",
                                       [NSNumber numberWithInt:[[[cardsArr lastObject] objectForKey:@"created"] intValue]],@"created",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_MAINLIST_MORE_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

-(void) reloadMoreList{
    [dytableview reloadData];
    isLoading = NO;
}

#pragma mark - 网络请求回调
//请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    NSLog(@"did finish");
    //移除loading
    [_darkCircleDot removeFromSuperview];
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        switch (commandid) {
            case DYNAMIC_MAINLIST_COMMAND_ID:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [headerView egoRefreshScrollViewDataSourceDidFinishedLoading:dytableview];

                    [cardsArr removeAllObjects];
                    [cardsArr addObjectsFromArray:resultArray];
                    
                    [self freshRedLabAndFooter];
                    
                    [dytableview reloadData];
                    
                    if (cardsArr.count == 0) {
                        self.noneView.text = @"暂时还没有动态";
                        accessBeforeTable = YES;
                    }
                    
                    [Global sharedGlobal].newDynamicNum = 0;
                    [self dissmissDynamicAlert];
                    
                    //5,17 andy add 去掉左侧菜单提醒红点
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDynamicNotice" object:nil];
                    
                    //        如果当前的数据加载完毕的话，等待界面消失  add vincent
                    [self performSelector:@selector(removeLoading) withObject:nil afterDelay:1.0];
                });
                
            }
                break;
            case DYNAMIC_RELATIONME_COMMAND_ID:
            {
                NSLog(@"relation me");
                if (resultArray) {
                    
                }
            }
                break;
            case DYNAMIC_MAINLIST_MORE_COMMAND_ID:
            {
                NSLog(@"load more");
                
                [footerVew egoRefreshScrollViewDataSourceDidFinishedLoading:dytableview];
                if (resultArray.count) {
                    [cardsArr addObjectsFromArray:resultArray];
                    
                    [self freshRedLabAndFooter];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reloadMoreList];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Common checkProgressHUD:@"没有更多了" andImage:nil showInView:self.view];
                    });
                    
                }
                
            }
                break;
            case DYNAMIC_DETAIL_COMMAND_ID:
            {
                NSDictionary* dic = [resultArray firstObject];
                
                //delete字段0未删除，1已删除
                int deleteStatus = [[[resultArray firstObject] objectForKey:@"delete"] intValue];
                if (deleteStatus) {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"这条动态已被删除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                    return;
                }
                
                cardDetailViewController* cardDetailVC = [[cardDetailViewController alloc] init];
                int type = [[dic objectForKey:@"type"] intValue];
                
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
                cardDetailVC.dataDic = dic;
                cardDetailVC.detailType = DynamicDetailTypeAll;
                
                [self.navigationController pushViewController:cardDetailVC animated:NO];
                RELEASE_SAFE(cardDetailVC);
            }
                break;
            default:
                break;
        }
    }else{
        [headerView egoRefreshScrollViewDataSourceDidFinishedLoading:dytableview];
        [footerVew egoRefreshScrollViewDataSourceDidFinishedLoading:dytableview];
        
    }
}

//展示新动态提醒
-(void) showDynamicAlert:(int) num{
    if (progressHUDTmp == nil) {
        progressHUDTmp = [[UILabel alloc] init];
        progressHUDTmp.frame = CGRectMake(self.view.bounds.size.width/2 - 120/2, 0, 120, 20);
        progressHUDTmp.textAlignment = UITextAlignmentCenter;
        progressHUDTmp.textColor = [UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1.0];
        progressHUDTmp.font = KQLboldSystemFont(13);
        progressHUDTmp.layer.cornerRadius = progressHUDTmp.bounds.size.height/2;
        progressHUDTmp.backgroundColor = [UIColor colorWithRed:0.17 green:0.18 blue:0.20 alpha:1.0];
        progressHUDTmp.alpha = 0.8;
        [self.view addSubview:progressHUDTmp];
    }
    progressHUDTmp.text = [NSString stringWithFormat:@"收到%d条新动态哦",num];
    
    progressHUDTmp.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        progressHUDTmp.alpha = 0.8;
    } completion:^(BOOL finished){
        progressHUDTmp.hidden = NO;
    }];
    
}

//隐藏新动态提醒
-(void) dissmissDynamicAlert{
    [UIView animateWithDuration:0.3 animations:^{
        progressHUDTmp.alpha = 0.0;
    } completion:^(BOOL finished){
        progressHUDTmp.hidden = YES;
    }];
}

//有新动态通知处理
-(void) newDynamicNotice:(NSNotification*) notify{
    [self showDynamicAlert:[Global sharedGlobal].newDynamicNum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addNewCard" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateDyDBData" object:nil];
    
    RELEASE_SAFE(dytableview);
    RELEASE_SAFE(backImg);
    RELEASE_SAFE(_darkCircleDot);
    RELEASE_SAFE(cardsArr);
    
    RELEASE_SAFE(progressHUDTmp);
    
    RELEASE_SAFE(_redCircleView);
    
    [super dealloc];
}

@end
