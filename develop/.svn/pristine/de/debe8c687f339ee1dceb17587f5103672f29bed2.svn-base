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
#import "circlelistCell.h"
#import "YLSearchResultCell.h"
#import "CreateCircleViewController.h"
#import "CircleDetailViewController.h"
#import "address_book_model.h"
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
#import "CircleDetailSelfViewController.h"
#import "CircleDetailOnlySelfViewController.h"

#import "CircleMemberList.h"
#import "OrganizationMemberList.h"

#define kCellHeight 150.f;

@interface CircleMainViewController ()
{
    int clickCircleId;
}
@end

@implementation CircleMainViewController
@synthesize searchBar = _searchBar;
@synthesize searchCtl = _searchCtl;
@synthesize orgArray = _orgArray;
@synthesize circleArry = _circleArry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _orgArray = [[NSArray alloc]init];
        _circleArry = [[NSArray alloc]init];
        
        self.backStyle = kBackStyleNormal;
        self.title = @"圈子";
        
        _searchResults = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    //加载列表数据和界面
    [self mainLoadView];
    [self searchBarInit];
    [self accessService];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    //圈子成员变更提醒
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(circleReminder:) name:kNotiCircleMemberChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(circleReminder:) name:KNotiCircleInfoChange object:nil];
    
    DLog(@"%@",self.circleArry);

}

- (void)viewWillAppear:(BOOL)animated
{
    if (IOS_VERSION_7) {
        [[UINavigationBar appearance] setBarTintColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"]];
    }
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    [self loadGroupCircleInfo];
    
}

- (void)loadGroupCircleInfo
{
    address_book_model *orgMod = [[address_book_model alloc]init];
    orgMod.where = @"parent_id = 0";
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:0];
    [arr addObjectsFromArray:[orgMod getList]];
    orgMod.where = @"member_count != 0";
    [arr addObjectsFromArray:[orgMod getList]];
    
    self.orgArray = arr;
//    self.orgArray = [orgMod getList];
    
    circle_list_model *circleMod = [[circle_list_model alloc]init];
    circleMod.where = @"name != ''";
    self.circleArry = [circleMod getList];
    
    [_listTableView reloadData];
    RELEASE_SAFE(orgMod);
    RELEASE_SAFE(circleMod);
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
//    _searchBar.barStyle = UIBarStyleBlack;

//    if (IOS_VERSION_7) {
//        _searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    }
    
    _listTableView.tableHeaderView = _searchBar;
    
    //搜索控制器
    _searchCtl = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchCtl.active = NO;
    _searchCtl.searchResultsDataSource = self;
    _searchCtl.searchResultsDelegate = self;
    _searchCtl.delegate = self;
    _searchCtl.searchResultsTableView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
}

/**
 *  // 主视图列表
 */
- (void)mainLoadView{
    
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight - 60) style:UITableViewStylePlain];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.showsVerticalScrollIndicator = NO;
    _listTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
//    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_listTableView];
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    
    //返回按钮
    
    [backButton setBackgroundColor:[UIColor clearColor]];
    
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];

    UIImage *image = nil;
    if (self.backStyle == kBackStyleMessage) {
        image =  [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    } else {
        image =  [[ThemeManager shareInstance] getThemeImage:@"ico_common_header.png"];
    }
    
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(20 , 30, 44.f, 44.f)];
    if (IOS_VERSION_7) {
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    }
//    RELEASE_SAFE(image);
    
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
    
    switch (self.backStyle) {
        case kBackStyleMessage:
            [self dismissModalViewControllerAnimated:YES];
            break;
        case kBackStyleNormal:
            if (![[SidebarViewController share]sideBarShowing]) {
                [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionLeft duration:0.15];
            }else{
                [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionNone duration:0.15];
            }

            break;
        default:
            break;
    }
}

//圈子成员变更
- (void)circleReminder:(NSNotification *)note{
  
    int circleId = [[note.object objectForKey:@"circleid"] intValue];
    
    circle_list_model *circleMod = [[circle_list_model alloc]init];
    self.circleArry = [circleMod getList];
    
    
    for (int i =0; i <self.circleArry.count; i++) {
        
        DLog(@"%@",[[self.circleArry objectAtIndex:i]objectForKey:@"circle_id"]);
    
        
        if ([[[self.circleArry objectAtIndex:i]objectForKey:@"circle_id"]intValue] == circleId){
            
            [_listTableView reloadData];
            
            break;
        }
    }
}

#pragma mark - createcircleDelegate
- (void)createCircleSuccess{
    [self accessService];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchCtl.searchResultsTableView) {
        return _searchResults.count;
    }
    else {
        switch (section) {
            case 0:
            {
                return self.orgArray.count - 1;
            }
                break;
            case 1:
            {
                return self.circleArry.count + 1;
            }
                break;
            default:
                break;
        }
        return 1;
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
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 60.f)];
//    [sectionView setBackgroundColor:RGBACOLOR(62, 69, 74, 1)];
//    [sectionView setBackgroundColor:[UIColor whiteColor]];
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
       
        if (self.orgArray.count !=0) {
            tips.text = [[self.orgArray objectAtIndex:0]objectForKey:@"name"];
        }
        
    }else{
        iconV.image = IMGREADFILE(@"ico_group_circle.png");
        tips.text = @" 私人圈子";
    }
    
    [sectionView addSubview:tips];
    RELEASE_SAFE(tips);
    RELEASE_SAFE(iconV);
    
    return [sectionView autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //搜索结果列表
    if (tableView == self.searchCtl.searchResultsTableView) {
        
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        static NSString *searchCell = @"searchCell";
        
        YLSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
        
        if (nil == cell) {
            
            cell = [[[YLSearchResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCell]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell.userNameLab.text = [_searchResults[indexPath.row] objectForKey:@"realname"];
        cell.company_nameLab.text = [_searchResults[indexPath.row] objectForKey:@"company_name"];
        
        NSURL* urlStr = [NSURL URLWithString:[_searchResults[indexPath.row] objectForKey:@"portrait"]];
        [cell.userHearV setImageWithURL:urlStr placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
        
        NSLog(@"_searchResults==%@",_searchResults);
        
        
        return cell;
        
    }else{
        //主界面列表
        static NSString *listCell = @"listCell";
        
        circlelistCell *cell = (circlelistCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if (nil == cell) {
            
            cell = [[[circlelistCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listCell]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        switch (indexPath.section) {
            case 0:
            {
                cell.clubName.text = [[self.orgArray objectAtIndex:indexPath.row+1]objectForKey:@"name"];
                
            }
                break;
            case 1:
            {
                
//                BOOL MSGinform = [[NSUserDefaults standardUserDefaults] boolForKey:@"MSGinform"];
//                
//                if (MSGinform) {
//                    
//                    
//                }
                
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
                    
//                    if ([self checkUserCreatedCircleNum]) {
//                        cell.hidden = YES;
//                    }
                    
                    if (self.backStyle == kBackStyleMessage) {
                        cell.hidden = YES;
                    }
                    
                }else{
                    
                    // 是否有圈子成员便更
                    NSDictionary* dic = [self.circleArry objectAtIndex:indexPath.row];
                    if ([[dic objectForKey:@"unread"] intValue] == 1) {
                        [cell isHaveMessageAlert:1 circleName:[dic objectForKey:@"name"]];
                    }
                    
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
//        memberMainView.pushType = PushTypesLeft;
        memberMainView.pushType = PushTypesButtom;
        memberMainView.accessType = AccessTypeSearchLook;
        memberMainView.userInfoDic = [_searchResults objectAtIndex:indexPath.row];
        memberMainView.lookId = [[[_searchResults objectAtIndex:indexPath.row] objectForKey:@"user_id"] intValue];
//        [self.navigationController pushViewController:memberMainView animated:YES];
//        [self presentViewController:memberMainView animated:YES completion:nil];
        CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberMainView];
        [self.navigationController presentModalViewController:nav animated:YES];
        RELEASE_SAFE(nav);
        
        RELEASE_SAFE(memberMainView);
        
    }else{
        
        switch (indexPath.section) {
            case 0:
            {
            
                //组织列表
//                GroupViewController *groupCtl = [[GroupViewController alloc]init];
//                groupCtl.listType = MemberlistTypeOrg;
//                groupCtl.orgId = [[[_orgArray objectAtIndex:indexPath.row+1]objectForKey:@"id"]intValue];
//                groupCtl.orgName = [[_orgArray objectAtIndex:indexPath.row+1]objectForKey:@"name"];
//                
//                [self.navigationController pushViewController:groupCtl animated:YES];
//                RELEASE_SAFE(groupCtl);
                OrganizationMemberList* orgMemListVC = [[OrganizationMemberList alloc] init];
                orgMemListVC.orgId = [[[_orgArray objectAtIndex:indexPath.row] objectForKey:@"id"] longLongValue];
                orgMemListVC.orgName = [[_orgArray objectAtIndex:indexPath.row] objectForKey:@"name"];
                [self.navigationController pushViewController:orgMemListVC animated:YES];
                
                [orgMemListVC release];
                
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
                    
                    CreateCircleViewController * createCircle = [[CreateCircleViewController alloc]init];
                    createCircle.delegate = self;
                    
                    CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:createCircle];
                    [self.navigationController presentModalViewController:nav animated:YES];
                    RELEASE_SAFE(createCircle);
                    RELEASE_SAFE(nav);
                    
                }else{
                    
                    [self changeTheCircleUnreadStatus:[self.circleArry objectAtIndex:indexPath.row]];
                    
//                    [self accessCircleListService:indexPath.row];
//                    clickCircleId = indexPath.row;
                    
                    CircleMemberList* circleMemListVC = [[CircleMemberList alloc] init];
                    circleMemListVC.circleId = [[[_circleArry objectAtIndex:indexPath.row] objectForKey:@"circle_id"] longLongValue];
                    circleMemListVC.circleName = [[_circleArry objectAtIndex:indexPath.row] objectForKey:@"name"];
                    circleMemListVC.circleType = StableCircle;
                    circleMemListVC.enterFromDetail = NO;
                    
                    [self.navigationController pushViewController:circleMemListVC animated:YES];
                    [circleMemListVC release];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"circleChangeLeftSiderNotice" object:nil];
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
    
    [circleMod release];
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

#pragma mark - accessService

- (void)accessService{
    
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                        [NSNumber numberWithInt:0],@"circle_ver",
                                        [NSNumber numberWithInt:0],@"org_ver",
                                        [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:GROUP_LIST_COMMAND_ID accessAdress:@"addressbook.do?param=" delegate:self withParam:nil];
}

//圈子成员列表
- (void)accessCircleListService:(int)row{
    
    NSNumber *circleIDNum = [NSNumber numberWithLongLong:[[[_circleArry objectAtIndex:row]objectForKey:@"circle_id"] longLongValue]];
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [Global sharedGlobal].user_id ,@"user_id",
                                        circleIDNum,@"circle_id",
                                        [NSNumber numberWithInt:0],@"ver",
                                        nil];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:circleIDNum,@"circle_id", nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:GROUP_MEMBER_LIST_COMMAND_ID accessAdress:@"circle/detail.do?param=" delegate:self withParam:param];
    
}


- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
       
        switch (commandid) {
            case GROUP_LIST_COMMAND_ID:
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    address_book_model *orgMod = [[address_book_model alloc]init];
//                    orgMod.where = @"member_count != 0";
//                    self.orgArray = [orgMod getList];
                    orgMod.where = @"parent_id = 0";
                    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:0];
                    [arr addObjectsFromArray:[orgMod getList]];
                    orgMod.where = @"member_count != 0";
                    [arr addObjectsFromArray:[orgMod getList]];
                    self.orgArray = arr;
                    
                    circle_list_model *circleMod = [[circle_list_model alloc]init];
                    circleMod.where = @"name != ''";
                    self.circleArry = [circleMod getList];
                    
                    RELEASE_SAFE(orgMod);
                    RELEASE_SAFE(circleMod);
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                       [_listTableView reloadData];
                       
                    });
                });
                
            }break;
            case GROUP_MEMBER_LIST_COMMAND_ID:
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *resultDic = [resultArray firstObject];
                    
                    NSMutableArray *orglistArray = [resultDic objectForKey:@"members"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //判断圈子人数是否多余2个人，否则直接跳转详情
                        if ([orglistArray count] < 2) {
//                            CircleDetailViewController *detailCtl = [[CircleDetailViewController alloc]init];
//                            NSDictionary *circleInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                        [[_circleArry objectAtIndex:clickCircleId]objectForKey:@"circle_id"],@"circle_id",
//                                                        [[_circleArry objectAtIndex:clickCircleId]objectForKey:@"name"],@"name",
//                                                        [NSNumber numberWithInt:MessageListTypeCircle],@"talk_type",
//                                                        [[self.circleArry objectAtIndex:clickCircleId] objectForKey:@"creater_name"],@"creater_name",
//                                                        [[_circleArry objectAtIndex:clickCircleId]objectForKey:@"content"],@"content",
//                                                        [[_circleArry objectAtIndex:clickCircleId] objectForKey:@"creater_id"],@"creater_id",
//                                                        [[_circleArry objectAtIndex:clickCircleId] objectForKey:@"portrait"],@"portrait",
//                                                        nil];
//                            
//                            detailCtl.detailDictionary = circleInfo;
//                            detailCtl.detailType = CircleDetailTypeDefault;
                            
//                            circle_member_list_model* circleMemMod = [[circle_member_list_model alloc] init];
//                            circleMemMod.where = [NSString stringWithFormat:@"circle_id = %d and user_id = %d",[[[_circleArry objectAtIndex:clickCircleId] objectForKey:@"circle_id"] intValue],[[[_circleArry objectAtIndex:clickCircleId] objectForKey:@"creater_id"] intValue]];
//                            NSMutableArray* memArr = [circleMemMod getList];
//                            [circleMemMod release];
                            
//                            detailCtl.memberArray = orglistArray;
                            
                            CircleDetailOnlySelfViewController* detailCtl = [[CircleDetailOnlySelfViewController alloc] init];
                            detailCtl.circleId = [[[_circleArry objectAtIndex:clickCircleId]objectForKey:@"circle_id"] longLongValue];
                            
                            [self.navigationController pushViewController:detailCtl animated:YES];
                            RELEASE_SAFE(detailCtl);
                            
                        }else{
                            if (self.backStyle == kBackStyleNormal) {
                                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[_circleArry objectAtIndex:clickCircleId]];
                                [dic setObject:[NSNumber numberWithInt:MessageListTypeCircle] forKey:@"talk_type"];
                                
                                GroupViewController *groupCtl = [[GroupViewController alloc]init];
                                groupCtl.listType = MemberlistTypeCircle;
//                                groupCtl.circleDic = [_circleArry objectAtIndex:clickCircleId];
                                groupCtl.circleDic = dic;
                                groupCtl.circleId = [[groupCtl.circleDic objectForKey:@"id"]intValue];
                                groupCtl.circleArr = [orglistArray mutableCopy];
                                
                                DLog(@"%@",groupCtl.circleDic);
                                [self.navigationController pushViewController:groupCtl animated:YES];
                                RELEASE_SAFE(groupCtl);
                                
                                // 当从聊一聊界面今日该成员界面的时候则直接跳转致聊天窗口
                            } else if (self.backStyle == kBackStyleMessage) {
                                NSDictionary * tcircleDic = [_circleArry objectAtIndex:clickCircleId];
                                NSDictionary * sessionNeedDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [tcircleDic objectForKey:@"id"],@"sender_id",
                                                                 [tcircleDic objectForKey:@"name"],@"name",
                                                                 [NSNumber numberWithInt:MessageListTypeCircle],@"talk_type",nil];
                                SessionViewController * session = [[SessionViewController alloc]init];
                                session.selectedDic = sessionNeedDic;
                                session.circleContactsList = orglistArray;
                                
                                NSDictionary * nameAndPorArr = [Common generatePortraitNameDicJsonStrWithContactArr:orglistArray];
                                NSArray * portraitArr = [nameAndPorArr objectForKey:@"icon_path"];
                                
                                NSDictionary * recordDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            [tcircleDic objectForKey:@"id"],@"id",
                                                            [NSNumber numberWithInt:MessageListTypeCircle],@"talk_type",
                                                            portraitArr,@"icon_path",
                                                            [tcircleDic objectForKey:@"name"],@"title",
                                                            nil];
                                BOOL isSuccess =  [chatmsg_list_model insertOrUpdateRecordWithDic:recordDic];
                                if (!isSuccess) {
                                    [Common checkProgressHUD:@"发起会话产生列表失败" andImage:nil showInView:APPKEYWINDOW];
                                }
                                
                                [self.navigationController pushViewController:session animated:YES];
                                RELEASE_SAFE(session);
                                
                            }
                           
                        }

                    });
                    
                });
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

-(void) dealloc{
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
