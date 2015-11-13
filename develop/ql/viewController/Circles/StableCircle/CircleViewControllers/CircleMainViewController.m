//
//  CircleMainViewController.m
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "CircleMainViewController.h"
#import "SidebarViewController.h"
#import "Common.h"
#import "PinYinForObjc.h"
#import "circleMainPageCell.h"
#import "UIImageScale.h"
#import "CirclelistCell.h"
#import "YLSearchResultCell.h"
#import "CreateCircleViewController.h"
#import "org_list_model.h"
#import "circle_list_model.h"
#import "user_circles_model.h"
#import "circle_contacts_model.h"
#import "login_organization_model.h"
#import "UIImageView+WebCache.h"
#import "MemberMainViewController.h"
#import "circle_member_list_model.h"
#import "CRNavigationController.h"
#import "SessionViewController.h"
#import "chatmsg_list_model.h"

#import "circle_member_list_model.h"

#import "CircleDetailSuccessViewController.h"
#import "CircleDetailOnlySelfViewController.h"
#import "CircleDetailOtherViewController.h"

#import "CircleMemberList.h"
#import "OrganizationMemberList.h"

#import "config.h"
#import "ThemeManager.h"
#import "Global.h"

#define kCellHeight 150.f;

@interface CircleMainViewController ()
{
    int clickCircleId;
    UIImage* backImg;
}

@property (nonatomic, retain) NSDictionary * mainOrgDic;

@end

@implementation CircleMainViewController
@synthesize searchBar = _searchBar;
@synthesize searchCtl = _searchCtl;
@synthesize orgArray = _orgArray;
@synthesize circleArry = _circleArry;
@synthesize oneArray = _oneArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _circleArry = [[NSArray alloc]init];
        
//        self.backStyle = kBackStyleNormal;
        self.title = @"圈子";
        
        _searchResults = [[NSMutableArray alloc]init];
    }
    return self;
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

-(void) themeNotification:(NSNotification*) notify{
    if (IOS_VERSION_7) {
        [[UINavigationBar appearance] setBarTintColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"]];
    }
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    if (_listTableView) {
        _listTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    }
    
    UIImage *image = nil;
    
    backImg = image;
    [self initBarBtn];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    //加载组织列表和圈子列表
    [self loadCircleGroupTable];
    
    //加载并刷新列表数据
    [self loadCircleGroupListData];
    
    //加载搜索框
    [self searchBarInit];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    //圈子成员变更提醒
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadCircleListData) name:kNotiCircleMemberChange object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(circleInfoChangeNotify:) name:KNotiCircleInfoChange object:nil];
    
    DLog(@"%@",self.circleArry);
}

- (void)loadCircleGroupListData
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        //获取组织列表
        self.orgArray = [org_list_model getAllOrgWithMemberIsnotNone];
    //一级组织名
      self.oneArray = [org_list_model oneOrgMember];
    
        NSLog(@"获取组织列表 self.orgArray %@",self.orgArray);
    
        for (NSDictionary * orgDic in self.oneArray) {
            if ([[orgDic objectForKey:@"parent_id"]intValue] == 0) {
                self.mainOrgDic = orgDic;
            }
        }
        circle_list_model *circleMod = [[circle_list_model alloc]init];
        circleMod.where = @"name != ''";
        self.circleArry = [circleMod getList];
        RELEASE_SAFE(circleMod);
    
        NSLog(@"self.circleArry %@",self.circleArry);
//        dispatch_sync(dispatch_get_main_queue(), ^{
            [_listTableView reloadData];
//        });
//    });
}

//
- (void)loadCircleListData
{
    circle_list_model * circleListGeter = [circle_list_model new];
    circleListGeter.where = @"name != ''";
    self.circleArry = [circleListGeter getList];
    RELEASE_SAFE(circleListGeter);
    [_listTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initTheme];
    
    if (IOS_VERSION_7) {
        [[UINavigationBar appearance] setBarTintColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"]];
    }
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    [self loadCircleGroupListData];
}

#pragma mark - event Method

/**
 *  搜索框
 */
- (void)searchBarInit {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.frame = CGRectMake(0.0f, 0.f, KUIScreenWidth, 44.0f);
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_searchBar.keyboardType = UIKeyboardTypeDefault;
	_searchBar.backgroundColor=[UIColor clearColor];
	_searchBar.translucent=YES;
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
    
    _listTableView.tableHeaderView = _searchBar;
    
    //搜索控制器
    _searchCtl = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchCtl.active = NO;
    _searchCtl.searchResultsDataSource = self;
    _searchCtl.searchResultsDelegate = self;
    _searchCtl.delegate = self;
    _searchCtl.searchResultsTableView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    _searchCtl.searchResultsTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_searchCtl.searchResultsTableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

/**
 *  // 主视图列表
 */
- (void)loadCircleGroupTable{
    
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight - 44) style:UITableViewStylePlain];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.showsVerticalScrollIndicator = NO;
    _listTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_listTableView];
    
    [self initBarBtn];
    
}

//返回按钮
-(void) initBarBtn{
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    //返回按钮
    [backButton setBackgroundColor:[UIColor clearColor]];
    
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    
    [backButton setImage:backImg forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(20 , 30, 44.f, 44.f)];
    if (IOS_VERSION_7) {
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    }
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    RELEASE_SAFE(backItem);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回事件
- (void)backTo{
    
//    switch (self.backStyle) {
//        case kBackStyleMessage:
//            [self dismissModalViewControllerAnimated:YES];
//            break;
//        case kBackStyleNormal:
//            if (![[SidebarViewController share]sideBarShowing]) {
//                [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionLeft duration:0.15];
//            }else{
//                [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionNone duration:0.15];
//            }
//            break;
//        default:
//            break;
//    }
}

//圈子信息变更通知
-(void) circleInfoChangeNotify:(NSNotification*) notify{
    
    circle_list_model *circleMod = [[circle_list_model alloc]init];
    circleMod.where = @"name != ''";
    self.circleArry = [circleMod getList];
    RELEASE_SAFE(circleMod);
    
//    [_listTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_listTableView reloadData];
    
}

//圈子成员变更
- (void)circleReminder:(NSNotification *)note{
  
    int circleId = [[note.object objectForKey:@"circleid"] intValue];

    circle_list_model *circleMod = [[circle_list_model alloc]init];
    self.circleArry = [circleMod getList];
    
    for (int i =0; i <self.circleArry.count; i++)
    {
        DLog(@"%@",[[self.circleArry objectAtIndex:i]objectForKey:@"circle_id"]);
        if ([[[self.circleArry objectAtIndex:i]objectForKey:@"circle_id"]intValue] == circleId){
            
            [_listTableView reloadData];
            break;
        }
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchCtl.searchResultsTableView) {
        return _searchResults.count;
    }
    else {
        switch (section) {
            //组织方列表
            case 0:
            {
                return self.orgArray.count;
            }
                break;
            //圈子列表
            case 1:
            {
                return self.circleArry.count + 1;
            }
                break;
            default:
            {
                return 0;
            }
                break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.searchCtl.searchResultsTableView) {
        return 1;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.searchCtl.searchResultsTableView) {
        return 0.f;
    }else{
        return 60.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    // 添加自定义section视图
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 10.f)];

    [sectionView setBackgroundColor:[UIColor colorWithPatternImage:[[ThemeManager shareInstance] getThemeImage:@"under_bar.png"]]];
    
    UIImageView *iconV = [[UIImageView alloc]initWithFrame:CGRectMake(15.f, 10.f, 40.f, 40.f)];
    iconV.layer.cornerRadius = 20;
    iconV.clipsToBounds = YES;
    
    [sectionView addSubview:iconV];
    
    // 提示语
    UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(65.f, 15.f, KUIScreenWidth, 30.f)];
    tips.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    tips.backgroundColor = [UIColor clearColor];
    tips.font = KQLboldSystemFont(16);
    
    if (section == 0) {
        iconV.image = [[ThemeManager shareInstance] getThemeImage:@"ico_group_logo.png"];
        
        if (self.oneArray.count !=0) {
            tips.text = [self.mainOrgDic objectForKey:@"name"];
        }
    }else{
        iconV.image = IMGREADFILE(@"ico_group_circle.png");
        tips.text = @" 私人圈子";
    }
    
    //添加点击手势
    if (section == 0) {
//        UIImageView* accessoryView = [[UIImageView alloc] init];
//        accessoryView.image = IMGREADFILE(@"ico_group_arrow.png");
//        accessoryView.frame = CGRectMake(KUIScreenWidth - 40, 15, 30, 30);
//        [sectionView addSubview:accessoryView];
//        [accessoryView release];
//        
        tips.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeadClick:)];
        [tips addGestureRecognizer:tap];
        [tap release];
    }
    tips.tag = section;
    
    [sectionView addSubview:tips];
    RELEASE_SAFE(tips);
    RELEASE_SAFE(iconV);
    
    return [sectionView autorelease];
}

//列表头部的点击事件
-(void) tableHeadClick:(UITapGestureRecognizer*) tap{
    UILabel* lab = (UILabel*)tap.view;
    if (lab.tag == 0) {
        OrganizationMemberList* orgMemListVC = [[OrganizationMemberList alloc] init];
        orgMemListVC.orgId = 0;//传0，或者不传
        orgMemListVC.orgName = lab.text;
        [self.navigationController pushViewController:orgMemListVC animated:YES];
        
        RELEASE_SAFE(orgMemListVC);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //搜索结果列表
    if (tableView == self.searchCtl.searchResultsTableView) {
        static NSString *searchCell = @"searchCell";
        
        YLSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
        
        if (nil == cell) {
            
            cell = [[[YLSearchResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCell]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell.userNameLab.text = [_searchResults[indexPath.row] objectForKey:@"realname"];
        cell.company_nameLab.text = [_searchResults[indexPath.row] objectForKey:@"company_name"];
        
//        姓名字体的变化 add vincent
        if ([[_searchResults[indexPath.row] objectForKey:@"realname"] rangeOfString:self.searchBar.text].location != NSNotFound) {
            NSRange rang1 = [[_searchResults[indexPath.row] objectForKey:@"realname"] rangeOfString:self.searchBar.text];
            NSMutableAttributedString  *numStr = [[NSMutableAttributedString alloc] initWithString:[_searchResults[indexPath.row] objectForKey:@"realname"]];
            [numStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:rang1];
            cell.userNameLab.attributedText = numStr;
        }
        
//        公司名字的字体的颜色的变化 add vincent
        if ([[_searchResults[indexPath.row] objectForKey:@"company_name"] rangeOfString:self.searchBar.text].location != NSNotFound) {
            NSRange rang1 = [[_searchResults[indexPath.row] objectForKey:@"company_name"] rangeOfString:self.searchBar.text];
            NSMutableAttributedString  *numStr = [[NSMutableAttributedString alloc] initWithString:[_searchResults[indexPath.row] objectForKey:@"company_name"]];
            [numStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:rang1];
            cell.company_nameLab.attributedText = numStr;
        }
        
        NSURL* urlStr = [NSURL URLWithString:[_searchResults[indexPath.row] objectForKey:@"portrait"]];
        [cell.userHearV setImageWithURL:urlStr placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
        
        NSLog(@"_searchResults==%@",_searchResults);
        return cell;
        
    }else{
        //主界面列表
        static NSString *listCell = @"listCell";
        
        CirclelistCell *cell = (CirclelistCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if (nil == cell) {
            
            cell = [[[CirclelistCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listCell]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        switch (indexPath.section) {
            case 0:
            {
                cell.clubName.text = [[self.orgArray objectAtIndex:indexPath.row]objectForKey:@"name"];
                
            }
                break;
            case 1:
            {
                if (indexPath.row == self.circleArry.count) {
                    
                    UIImageView *iconV = [[UIImageView alloc]initWithFrame:CGRectMake(95.f, 20.f, 20.f, 20.f)];
                    iconV.image = [[ThemeManager shareInstance] getThemeImage:@"ico_group_add.png"];
                    
                    [cell.contentView addSubview:iconV];
                    RELEASE_SAFE(iconV);
                    
                    UILabel *titleT = [[UILabel alloc]initWithFrame:CGRectMake(120.f, 15.f, 110.f, 30.f)];
                    titleT.text = @"创建私人圈子";
                    titleT.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
                    titleT.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:titleT];
                    RELEASE_SAFE(titleT);
                    
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.markLabel.hidden = YES;
                
//                    if (self.backStyle == kBackStyleMessage) {
//                        cell.hidden = YES;
//                    }
                }else{

                    // 是否有圈子成员便更
//                    NSDictionary* dic = [self.circleArry objectAtIndex:indexPath.row];
//                    if ([[dic objectForKey:@"unread"] intValue] == 1) {
//                        [cell isHaveMessageAlert:1 circleName:[dic objectForKey:@"name"]];
//                    }
                    //booky 8.7 无圈子提醒
                    
                    cell.clubName.text = [[self.circleArry objectAtIndex:indexPath.row]objectForKey:@"name"];
                }
            }
                break;
            default:
                break;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //搜索结果列表
    if (tableView == self.searchCtl.searchResultsTableView) {
        
        MemberMainViewController *memberMainView = [[MemberMainViewController  alloc] init];
        
        memberMainView.pushType = PushTypesButtom;
//        memberMainView.accessType = AccessTypeSearchLook;
        memberMainView.userInfoDic = [_searchResults objectAtIndex:indexPath.row];
        memberMainView.lookId = [[[_searchResults objectAtIndex:indexPath.row] objectForKey:@"user_id"] intValue];
        if (memberMainView.lookId == [[Global sharedGlobal].user_id longLongValue] ) {
            memberMainView.accessType = AccessTypeSelf;
        }else{
            memberMainView.accessType = AccessTypeLookOther;
        }
        CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberMainView];
        [self.navigationController presentModalViewController:nav animated:YES];
        RELEASE_SAFE(nav);
        RELEASE_SAFE(memberMainView);
        
    }else{
        switch (indexPath.section) {
            case 0:
            {
                OrganizationMemberList* orgMemListVC = [[OrganizationMemberList alloc] init];
                orgMemListVC.orgId = [[[_orgArray objectAtIndex:indexPath.row] objectForKey:@"id"] longLongValue];
                orgMemListVC.orgName = [[_orgArray objectAtIndex:indexPath.row] objectForKey:@"name"];
                [self.navigationController pushViewController:orgMemListVC animated:YES];
                
                RELEASE_SAFE(orgMemListVC);
            }
                break;
            case 1:
            {
                // 创建圈子
                if (indexPath.row == _circleArry.count) {
                    
                    if ([self checkUserCreatedCircleNum]) {
                        [Common checkProgressHUD:@"每个人最多只能创建5个私人圈子哦" andImage:nil showInView:self.view];
                        return;
                    }
                    
                    CreateCircleViewController* createCircle = [[CreateCircleViewController alloc]init];
                    createCircle.delegate = self;
                    
                    CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:createCircle];
                    [self.navigationController presentModalViewController:nav animated:YES];
                    RELEASE_SAFE(createCircle);
                    RELEASE_SAFE(nav);
                    
                }else{
                    
                    //判断所选圈子已有成员数
                    NSDictionary * circleDic = [self.circleArry objectAtIndex:indexPath.row];
                    long long circleID =[[circleDic objectForKey:@"circle_id"]longLongValue];
                    long long createrID = [[circleDic objectForKey:@"creater_id"]longLongValue];
                    long long userID = [[[Global sharedGlobal]user_id] longLongValue];
                    
                    NSMutableArray * memberList = [circle_member_list_model getAllMemberWithCircle:circleID];
                    
                    //如果成员数大于等于2 则跳转成员
                    if (memberList.count > 1) {
                        CircleMemberList* circleMemListVC = [[CircleMemberList alloc] init];
                        circleMemListVC.circleId = [[[_circleArry objectAtIndex:indexPath.row] objectForKey:@"circle_id"] longLongValue];
                        circleMemListVC.circleName = [[_circleArry objectAtIndex:indexPath.row] objectForKey:@"name"];
                        circleMemListVC.circleType = StableCircle;
                        circleMemListVC.enterFromDetail = NO;
                        
                        [self.navigationController pushViewController:circleMemListVC animated:YES];
                        RELEASE_SAFE(circleMemListVC);
                    } else {
                        if (createrID == userID) {
                            CircleDetailOnlySelfViewController * circleDetail = [CircleDetailOnlySelfViewController new];
                            circleDetail.circleId = circleID;
                            [self.navigationController pushViewController:circleDetail animated:YES];
                            RELEASE_SAFE(circleDetail);
                        } else {
                            CircleDetailOtherViewController * circleOtherDetail = [CircleDetailOtherViewController new];
                            circleOtherDetail.circleId = circleID;
                            [self.navigationController pushViewController:circleOtherDetail animated:YES];
                            RELEASE_SAFE(circleOtherDetail);
                        }
                    }
                    
                    [self changeTheCircleUnreadStatus:[self.circleArry objectAtIndex:indexPath.row]];
                    
//                    add vincent 圈子红点去掉
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"circleChangeLeftSiderNotice" object:nil];
                }
            }
                break;
            default:
                break;
        }
    }
}

//检查已创建圈子数目
-(BOOL) checkUserCreatedCircleNum{
    circle_list_model* circleMod = [[circle_list_model alloc] init];
    circleMod.where = [NSString stringWithFormat:@"creater_id = %d",[[Global sharedGlobal].user_id intValue]];
    NSArray* createdCircleArr = [circleMod getList];
    [circleMod release];
    
    if (createdCircleArr.count >= CREATECIRCLEMAX) {
        return YES;
    }
    return NO;
}

-(void) changeTheCircleUnreadStatus:(NSDictionary*) circleDic{
    circle_list_model* circleMod = [[circle_list_model alloc] init];
    
    NSNumber* circleId = [circleDic objectForKey:@"circle_id"];
    circleMod.where = [NSString stringWithFormat:@"circle_id = %lld",[circleId longLongValue]];
    
    [circleMod updateDB:[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:0],@"unread",
                         nil]];
    
    RELEASE_SAFE(circleMod);
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
    
    //获取所有联系人数据
    circle_contacts_model *contactMod = [[circle_contacts_model alloc]init];
    
    NSArray *allContactsArr = [contactMod getList];
    
    RELEASE_SAFE(contactMod);
    
    NSMutableArray* allContactAndCompanyArr = [NSMutableArray arrayWithCapacity:allContactsArr.count];
    
    for (NSDictionary* dic in allContactsArr) {
        NSString* str = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"realname"],[dic objectForKey:@"company_name"]];
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
                    
                    [_searchResults addObject:allContactsArr[i]];
                    
                }else{
                    // 转换为拼音的首字母
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:allContactAndCompanyArr[i]];
                    
                    // 搜索是否在范围中
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    
                    if (titleHeadResult.length>0) {
                        [_searchResults addObject:allContactsArr[i]];
                    }
                }
            }
            else {
                
                NSRange titleResult=[allContactAndCompanyArr[i] rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    [_searchResults addObject:allContactsArr[i]];
                }
            }
        }
        // 搜索中文
    } else if (self.searchBar.text.length>0 && [Common isIncludeChineseInString:self.searchBar.text]) {
        
        for (int i=0; i<allContactAndCompanyArr.count; i++) {
            NSString *tempStr = allContactAndCompanyArr[i];
            
            NSRange titleResult=[tempStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            
            if (titleResult.length>0) {
                [_searchResults addObject:[allContactsArr objectAtIndex:i]];
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

#pragma CreateCircleViewController

- (void)createCircleSuccess
{
    [self loadCircleGroupListData];
}

#pragma mark - Dealloc

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    RELEASE_SAFE(_listTableView);
    
    RELEASE_SAFE(_searchBar);
    RELEASE_SAFE(_searchCtl);
    
    RELEASE_SAFE(_orgArray);    // 组织
    RELEASE_SAFE(_circleArry);  // 圈子
    RELEASE_SAFE(_searchResults);     // 搜索出的数据
    [super dealloc];
}

@end
