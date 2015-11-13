//
//  MemberWantHaveViewController.m
//  ql
//
//  Created by yunlai on 14-8-5.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "MemberWantHaveViewController.h"

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

@interface MemberWantHaveViewController (){
    
    //加载效果view
    TYDotIndicatorView *_darkCircleDot;
    //卡片对象组
    NSMutableArray* cardsArr;
    
}

@end

@implementation MemberWantHaveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    cardsArr = [[NSMutableArray alloc] init];
    
    dytableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, KUIScreenHeight - 44.0f) style:UITableViewStylePlain];
    dytableview.delegate = self;
    dytableview.dataSource = self;
    dytableview.backgroundColor = [UIColor clearColor];
    dytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:dytableview];
    
    _darkCircleDot = [[TYDotIndicatorView alloc] initWithFrame:CGRectMake(0, 0.f, KUIScreenWidth, KUIScreenHeight) dotStyle:TYDotIndicatorViewStyleCircle dotColor:[UIColor colorWithWhite:0.6 alpha:1.0] dotSize:CGSizeMake(10, 10)];
    if (IOS_VERSION_7) {
        _darkCircleDot.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.3];
    }else{
        _darkCircleDot.backgroundColor = [UIColor clearColor];
    }
    [_darkCircleDot startAnimating];
    [self.view addSubview:_darkCircleDot];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addNewCard" object:nil];
    
    //个人的我有我要
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteMineWantHave" object:nil];
    
    //注册发布动态成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewCard:) name:@"addNewCard" object:nil];
    
    //个人的我有我要
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wantHaveDeleteNotice:) name:@"deleteMineWantHave" object:nil];
    self.navigationItem.title = @"我有我要";
    
    [self accessMysupplydemandService];
}

//我有我要 删除通知
-(void) wantHaveDeleteNotice:(NSNotification*) notify{
    [self accessMysupplydemandService];
}

- (void)viewWillAppear:(BOOL)animated{
    //查看他人动态时需显示，不然有bug
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//发布动态成功后刷新
-(void) addNewCard:(NSNotification*) notify{
    [self accessMysupplydemandService];
}

/**
 *  返回按钮
 */
- (void)backBarBtn{
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    
    [backButton setImage:[[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    backButton.frame = CGRectMake(0 , 30, 44.f, 44.f);
    if (IOS_VERSION_7) {
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    }
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    RELEASE_SAFE(backItem);
}

- (void)backTo{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - +号按钮点击
-(void) addBtnClick{
    CHTumblrMenuView* _CHmenuView = [[CHTumblrMenuView alloc] init];
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
    
    [_CHmenuView show];
    RELEASE_SAFE(_CHmenuView);
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
            noneLab.numberOfLines = 2;
            noneLab.textColor = [UIColor darkGrayColor];
            noneLab.backgroundColor = [UIColor whiteColor];
            noneLab.font = KQLboldSystemFont(15);
            
            UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [publishBtn setFrame:CGRectMake(20.f, 60.f, 280.f, 140.f)];
            [publishBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
            
            [publishBtn setBackgroundImage:IMGREADFILE(@"img_member_default4.png") forState:UIControlStateNormal];
            [cell.contentView addSubview:noneLab];
            
            [cell.contentView addSubview:publishBtn];
            
            noneLab.text = @"发布您想要的或者您有的商业\n信息，能更好的促进交流合作，快去发布吧~";
            
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
        //个人的我有我要
//        cardDetailVC.detailType = DynamicDetailTypeWantHave;
        
        if (self.lookId) {
            cardDetailVC.detailType = DynamicDetailTypeAll;
            cardDetailVC.enterFromDYList = NO;
        }else{
            cardDetailVC.detailType = DynamicDetailTypeWantHave;
        }
        
        [self.navigationController pushViewController:cardDetailVC animated:NO];
        RELEASE_SAFE(cardDetailVC);
    }
}

- (void)accessMysupplydemandService{
    NSString* reqUrl = @"member/mysupplydemand.do?param=";
    
    NSNumber* userId = nil;
    
    if (self.lookId != 0) {
        userId = [NSNumber numberWithLongLong:self.lookId];
    }else{
        userId = [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]];
    }
    
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       userId,@"user_id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    
    [[NetManager sharedManager] accessService:requestDic data:nil command:MAINPAGE_SUPPLUYDEMAND_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

#pragma mark - 网络请求回调
//请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    NSLog(@"did finish");
    //移除loading
    [_darkCircleDot removeFromSuperview];
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        switch (commandid) {
            case MAINPAGE_SUPPLUYDEMAND_COMMAND_ID:
            {
                NSLog(@"my supply");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cardsArr removeAllObjects];
                    [cardsArr addObjectsFromArray:resultArray];
                    
                    [dytableview reloadData];
                });
            }
                break;
            default:
                break;
        }
    }else{
        [Common checkProgressHUD:@"网络连接错误" andImage:nil showInView:self.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    RELEASE_SAFE(dytableview);
    RELEASE_SAFE(_darkCircleDot);
    RELEASE_SAFE(cardsArr);
    
    RELEASE_SAFE(progressHUDTmp);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addNewCard" object:nil];
    
    //个人的我有我要
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteMineWantHave" object:nil];
    
    [super dealloc];
}

@end
