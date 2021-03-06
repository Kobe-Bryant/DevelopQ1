//
//  CircleMajorViewController.m
//  ql
//
//  Created by Dream on 14-8-19.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "CircleMajorViewController.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "OrganizeViewController.h"
#import "GroupViewController.h"
#import "circleMainPageCell.h"
#import "CreateCircleViewController.h"
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
#import "MajorTableViewCell.h"
#import "org_member_list_model.h"
#import "MajorListCell.h"
#import "personalCell.h"
#import "YLDataObj.h"
#import "CircleCellEditButton.h"

#define Organization_Data   @"Organization_Data"  //组织层级数据 （根据这个跳转不同的界面）
#define Circle_Data         @"Circle_Data"        //圈子数据 （push到圈子界面）

@interface CircleMajorViewController ()<RATreeViewDelegate, RATreeViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,createCircleDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIImage* backImg;
    NSMutableArray *_searchResults;     // 搜索出的数据
   
    UITableView *_listTableview;    //一级层级圈子
    
    NSMutableArray* _memberArr;
    //keys
    NSMutableArray* _keysArr;
    //data
    NSMutableDictionary* _dataDict;
    //    有头衔成员
    NSMutableArray* _haveHonorArr;
    NSIndexPath* _selectIndexPath;
    CircleCellEditButton *editButton;
}

@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) RATreeView *treeView;
@property (nonatomic , retain) UISearchBar *searchBar;
@property (nonatomic , retain) UISearchDisplayController *searchCtl;
@property (nonatomic , retain) NSMutableArray *orgArray; //组织数据
@property (nonatomic , retain) NSArray *circleArry;      //圈子数据
@property (nonatomic, retain) NSDictionary * mainOrgDic; //一级组织 字典
@property (nonatomic, retain) NSMutableArray *twoArray;  //二级组织数据（不是RADataObject，普通数组）
@property (nonatomic, retain) NSMutableArray *threeArray;//三级组织数据（不是RADataObject，普通数组）

@property (nonatomic, retain) NSArray *secArray; //根据是否为0 判断是否有层级
@property (nonatomic, retain) NSMutableArray *listOneArray;
@property (nonatomic , retain) NSMutableArray *oneArray;

@end

@implementation CircleMajorViewController
@synthesize searchBar = _searchBar;
@synthesize searchCtl = _searchCtl;
@synthesize orgArray = _orgArray;
@synthesize mainOrgDic = _mainOrgDic;
@synthesize treeView = _treeView;
@synthesize circleArry = _circleArry;
@synthesize twoArray = _twoArray;
@synthesize threeArray = _threeArray;
@synthesize secArray = _secArray;
@synthesize listOneArray = _listOneArray;
@synthesize oneArray = _oneArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backStyle = kBackStyleNormal;
        self.title = @"圈子";
        _searchResults = [[NSMutableArray alloc]init];
        self.twoArray = [[NSMutableArray alloc]init];
        self.threeArray = [[NSMutableArray alloc]init];
        self.listOneArray = [[NSMutableArray alloc]init];
        
        _memberArr = [[NSMutableArray alloc] init];
        _haveHonorArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.treeView = nil;
    self.mainOrgDic = nil;
    self.twoArray = nil;
    self.threeArray = nil;
    self.secArray = nil;
    self.listOneArray = nil;
    self.oneArray = nil;
    _listTableview.delegate = nil;
    [_listTableview release];
    RELEASE_SAFE(_searchBar);
    RELEASE_SAFE(_searchCtl);
    RELEASE_SAFE(_orgArray);    // 组织
    RELEASE_SAFE(_circleArry);  // 圈子
    RELEASE_SAFE(_searchResults);     // 搜索出的数据
    
    [super dealloc];
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
    
    if (_treeView) {
        _treeView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    }
    
    UIImage *image = nil;
    if (self.backStyle == kBackStyleMessage) {
        image =  [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    } else {
        image =  [[ThemeManager shareInstance] getThemeImage:@"ico_common_header.png"];
    }
    
    backImg = image;
    [self initBarBtn];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initTheme];

    if (IOS_VERSION_7) {
        [[UINavigationBar appearance] setBarTintColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"]];
    }
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    
    
//    isOpen = NO; //每次另个界面进来从新设置为0，（箭头的指向设置）
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
//    //圈子成员变更提醒
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadCircleListData) name:kNotiCircleMemberChange object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(circleInfoChangeNotify:) name:KNotiCircleInfoChange object:nil];
    
    [self loadCircleGroupListData];
    
    if ([self.secArray count]) {
         [self loadCircleGroupTable];//加载组织列表和圈子列表
    } else {
         [self loadCircleListTable]; //一级组织列表
    }
    
     [self searchBarInit];
    
}

- (void)loadCircleGroupListData
{
    //一级组织名
    self.oneArray = [org_list_model oneOrgMember];
    
    //分离一级组织和二级组织
    for (NSDictionary * orgDic in self.oneArray) {
        if ([[orgDic objectForKey:@"parent_id"]intValue] == 0) {
            self.mainOrgDic = orgDic; //一级组织 一对键值对
        }
    }
    
    //组织数据库所有的数据
    org_list_model* orgMod = [[org_list_model alloc] init];
    
    //根据递归（parent_id和上一级的id相同）取出二级组织
    orgMod.where = [NSString stringWithFormat:@"parent_id = %d",[[self.mainOrgDic objectForKey:@"id"] intValue]];
    orgMod.orderBy = @"id";
    self.secArray = [orgMod getList];
    
    //如果存在二级组织的情况
    if ([self.secArray count]) {
        
        
        //所有的三级组织和对应的二级组织Key-Value
       NSMutableDictionary* secAndThrDic = [NSMutableDictionary dictionaryWithCapacity:0];
        for (NSDictionary* dic in self.secArray) {
            orgMod.where = [NSString stringWithFormat:@"parent_id = %d",[[dic objectForKey:@"id"] intValue]];
            NSArray* arr = [orgMod getList];
            [secAndThrDic setObject:arr forKey:[dic objectForKey:@"id"]];
        }
        
        //排序
        NSArray* keys = [secAndThrDic allKeys];
        NSArray* sortKeys = [keys sortedArrayUsingComparator:^(id obj1, id obj2){
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        
        }];
        
        // 二级和三级对应数据结构
        NSMutableArray *secObjectArr = [NSMutableArray array];//存放二级组织的数据
        for (int i = 0; i < [sortKeys count]; i++) {
            NSString *secId = [sortKeys objectAtIndex:i];
            
            //如果有第三层级，则把数据放入数组中
            NSMutableArray *thrObjectArr = [NSMutableArray array]; //存放三级组织的数据
            if ([sortKeys count]) {
                
                for (NSDictionary *thrDic in [secAndThrDic objectForKey:secId]) {
                    
                    [self.threeArray addObject:thrDic]; // 存储三级组织数据
                    RADataObject *thrObject =  [RADataObject dataObjectWithName:[thrDic objectForKey:@"name"] count:[thrDic objectForKey:@"member_count"] children:nil type:Organization_Data];
                    [thrObjectArr addObject:thrObject];
                }
            }
            //第二级 ，根据id取出key 为name的值
            orgMod.where = [NSString stringWithFormat:@"id = %@",secId];
            NSDictionary* secDic = [[orgMod getList] firstObject];
            [self.twoArray addObject:secDic]; //这里方便跳转下一个页面取值
           
            RADataObject *secAndThrOrgObject = [RADataObject dataObjectWithName:[secDic objectForKey:@"name"] count:[secDic objectForKey:@"member_count"] children:thrObjectArr type:Organization_Data];
            
            [secObjectArr addObject:secAndThrOrgObject];
        }
        
        //一级和二级对应数据结构
        RADataObject *oneAndTwoOrgObject = [RADataObject dataObjectWithName:[self.mainOrgDic objectForKey:@"name"] count:[self.mainOrgDic objectForKey:@"member_count"] children:secObjectArr type:Organization_Data];
        
        [orgMod release];
       // self.data = [NSArray arrayWithObjects:oneAndTwoOrgObject,circleObject,nil];
        self.data = [NSArray arrayWithObjects:oneAndTwoOrgObject,nil];
        [_treeView reloadData];
        
    } else { // 只有一级组织情况
        
        [self getOrgMemberListData];

    }

}

//获取组织列表数据
-(void) getOrgMemberListData{
    [_haveHonorArr removeAllObjects];
    [_memberArr removeAllObjects];
    
    //取出有头衔的成员
    NSArray* haveHonorMemberArr = [org_member_list_model getHaveHonorMember:[[self.mainOrgDic objectForKey:@"id"] integerValue]];
    [_haveHonorArr addObjectsFromArray:haveHonorMemberArr];
    
    //取出没有头衔的成员
    NSArray* noHonorMemberArr = [org_member_list_model getNoHonorMember:[[self.mainOrgDic objectForKey:@"id"] integerValue]];
    
    // 根据数据首字母排列数据
    _dataDict = [[YLDataObj accordingFirstLetterGetTips:noHonorMemberArr] mutableCopy];
    _keysArr = [[[_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
    if (haveHonorMemberArr.count) {
        [_keysArr insertObject:@"" atIndex:0];
    }
    
    if (haveHonorMemberArr.count) {
        NSArray* newHaveHonorMemberArr = [YLDataObj sortRealNameWith:haveHonorMemberArr];
        [_dataDict setObject:newHaveHonorMemberArr forKey:@""];
    }
    
    // 获取所有名字
    for (int i =0; i<_keysArr.count; i++) {
        [_memberArr addObjectsFromArray:[_dataDict objectForKey:[_keysArr objectAtIndex:i]]];
    }
}


- (void)loadCircleGroupTable {
    
    _treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight - 44)];
    _treeView.delegate = self;
    _treeView.dataSource = self;
    _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    [_treeView setBackgroundColor:COLOR_LIGHTWEIGHT];
    [self.view addSubview:_treeView];

}

// 主界面
- (void)loadCircleListTable{
    _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, KUIScreenWidth, KUIScreenHeight - 44) style:UITableViewStyleGrouped];
    _listTableview.dataSource = self;
    _listTableview.delegate = self;
    _listTableview.backgroundColor = COLOR_LIGHTWEIGHT;
    
    if (IOS_VERSION_7) {
        [_listTableview setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_listTableview];
    if (IOS_VERSION_7) {
        // ios7的UITableVIew按字母排序的索引怎么改成背景是透明
        if ([_listTableview respondsToSelector:@selector(setSectionIndexColor:)]) {
            _listTableview.sectionIndexBackgroundColor = COLOR_LIGHTWEIGHT;
            _listTableview.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
            // 索引字体颜色
            _listTableview.sectionIndexColor = COLOR_GRAY2;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == _listTableview) {
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, KUIScreenWidth, 60)];
        sectionView.backgroundColor = [UIColor colorWithRed:239/255.0 green:240/255.0 blue:241/255.0 alpha:1];
        UIImage *image = [UIImage imageNamed:@"ico_common_logo.png"];
        UIImageView *iconImage = [[UIImageView alloc]initWithImage:image];
        iconImage.frame = CGRectMake(20, (60 - image.size.height)/2, image.size.width, image.size.height);
        [sectionView addSubview:iconImage];
        [iconImage release];
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.frame.origin.x + iconImage.frame.size.width + 15, 14.0, 200, 30)];
        titleLable.font = [UIFont systemFontOfSize:16.0];
        titleLable.text = [self.mainOrgDic objectForKey:@"name"];
        titleLable.textColor = RGBACOLOR(52, 52, 52, 1);
        [sectionView addSubview:titleLable];
        [titleLable release];
        
        return [sectionView autorelease];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _listTableview) {
         return 60.0;
    }
    return 0.0;
}

- (void)searchBarInit {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.frame = CGRectMake(0.0f, 0.f, 320, 44.0f);
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_searchBar.keyboardType = UIKeyboardTypeDefault;
	_searchBar.backgroundColor=[UIColor clearColor];
	_searchBar.translucent=YES;
	_searchBar.placeholder=@"搜索";
    _searchBar.delegate = self;
    
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
    
    if ([self.secArray count]) {
        _treeView.treeHeaderView = _searchBar;
    } else {
       _listTableview.tableHeaderView = _searchBar;
    }
}

#pragma mark TreeView Data Source

-(NSInteger)numberOfTreeViewInSection:(RATreeView *)treeView {
    return 1;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    RADataObject *data = item;
    return [data.children count];
    
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = [UIColor colorWithRed:239/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    } else if(treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor colorWithRed:246/255.0 green:247/255.0 blue:249/255.0 alpha:1];
    }
}


- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    // 如果有二层级就显示层级，反之则显示成员列表
    if ([self.secArray count]) {
        //圈子UI主界面
        static NSString *identifier = @"Cell";
        MajorTableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[MajorTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.nameLable.text = ((RADataObject *)item).name;
        cell.countLable.text = ((RADataObject *)item).count;
        cell.countLable.frame = CGRectMake(280 - 5*cell.countLable.text.length, 12.0, 50.f, 30.f);
        
        cell.imageView.image = nil;
        cell.bidButton.hidden = YES;
        if (treeNodeInfo.treeDepthLevel == 0) {
            cell.countLable.text = nil;
            cell.bidButton.hidden = NO; //一级层级不可点击（上面覆盖一层button，设为不可点击，就ok了）
            
            if ([((RADataObject *)item).type isEqualToString:Organization_Data]) {
                cell.imageView.image = [UIImage imageNamed:@"ico_common_logo.png"];
            } else {
                cell.imageView.image = [UIImage imageNamed:@"group_circle.png"];
            }
            cell.nameLable.font = [UIFont systemFontOfSize:17.0];
            cell.nameLable.frame = CGRectMake(85, 13.0, cell.nameLable.frame.size.width, cell.nameLable.frame.size.height);
            cell.lineImage.frame = CGRectMake(0, 59.5, 320, 0.5);
                                    
        } else if (treeNodeInfo.treeDepthLevel == 1){
            
            cell.nameLable.frame = CGRectMake(20, 11.0,cell.nameLable.frame.size.width, cell.nameLable.frame.size.height);
            cell.nameLable.textColor = [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1];
            cell.lineImage.frame = CGRectMake(0, 52.5, 320, 0.5);
        } else {
            cell.nameLable.frame = CGRectMake(20, 9.0,cell.nameLable.frame.size.width, cell.nameLable.frame.size.height);
            cell.nameLable.textColor = [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1];
            cell.lineImage.frame = CGRectMake(0, 42.5, 320, 0.5);
        }
        
        // 设置箭头
        cell.arrowImage.hidden = YES;
        if (treeNodeInfo.treeDepthLevel == 1 || treeNodeInfo.treeDepthLevel == 2) {
            if (![((RADataObject *)item).children count]) {
                cell.arrowImage.hidden = NO;
            }
        }
        return cell;

    }

    return nil;
}

- (void)send:(UIButton *)sender{

    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"邀请"]) {
        NSLog(@"邀请");
        button.hidden = YES;
        
        UILabel *lable = (UILabel *)[self.view viewWithTag:button.tag + 100];
        lable.text = @"已邀请";
        lable.hidden = NO;
        
    } else {
        NSLog(@"聊聊");
    }
}

#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if ([self.secArray count]) {
        if (treeNodeInfo.treeDepthLevel == 0) {
            return 60.0;
        } else if(treeNodeInfo.treeDepthLevel == 1) {
            return 53.0;
        } else {
            return 43.0;
        }
    } else {
        /**
         *公司没有层级关系，显示成员列表
         */

      if (treeNodeInfo.treeDepthLevel == 1 && [((RADataObject *)item).type isEqualToString:Organization_Data]) {
          return 54.0;
      } else {
          return 60.0;
      }
     
    }
    return 0.0;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if (treeDepthLevel == 0 || treeDepthLevel == 1){
        return YES;
    }
    return NO;
}

-(void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInf indexPathInTreeView:(NSIndexPath *)indexPath{
   
    //组织层级跳转
    //如果有层级关系
    if ([self.secArray count]) {

        // 组织跳转
        if ((treeNodeInf.treeDepthLevel == 1 && [((RADataObject *)item).type isEqualToString:Organization_Data]) ||  treeNodeInf.treeDepthLevel == 2) {
            RADataObject *data = item;
            if ([data.children count]) {
                //还有子层，设置箭头指向
//                MajorTableViewCell *cell = (MajorTableViewCell *)[_treeView.tableView cellForRowAtIndexPath:indexPath];
            } else {
                
                if (treeNodeInf.treeDepthLevel == 1) {
                    OrganizationMemberList* orgMemListVC = [[OrganizationMemberList alloc] init];
                    orgMemListVC.orgId = [[[self.twoArray objectAtIndex:treeNodeInf.positionInSiblings] objectForKey:@"id"] longLongValue];
                    orgMemListVC.orgName = [[self.twoArray objectAtIndex:treeNodeInf.positionInSiblings] objectForKey:@"name"];
                    [self.navigationController pushViewController:orgMemListVC animated:YES];
                    RELEASE_SAFE(orgMemListVC);
                } else if(treeNodeInf.treeDepthLevel == 2) {
                    
                    NSInteger thrId = 0;
                    for (NSDictionary *thrDic in self.threeArray) {
                        if ([[thrDic objectForKey:@"name"] isEqualToString:data.name]) {
                            thrId = [[thrDic objectForKey:@"id"] integerValue];
                        }
                    }
                    OrganizationMemberList* orgMemListVC = [[OrganizationMemberList alloc] init];
                    orgMemListVC.orgId = thrId;
                    orgMemListVC.orgName = data.name;
                    [self.navigationController pushViewController:orgMemListVC animated:YES];
                    RELEASE_SAFE(orgMemListVC);
                }
            }
        }
    } else {
//        /**
//         *公司没有层级关系，显示成员列表
//         */
//        
//        if (treeNodeInf.treeDepthLevel == 1 && [((RADataObject *)item).type isEqualToString:Organization_Data]) {
//            MemberMainViewController* memberVC = [[MemberMainViewController alloc] init];
//            memberVC.lookId = [[[self.listOneArray objectAtIndex:treeNodeInf.positionInSiblings] objectForKey:@"user_id"]intValue];
//            //        add vincent
//            if (memberVC.lookId == [[Global sharedGlobal].user_id longLongValue] ) {
//                memberVC.accessType = AccessTypeSelf;
//            }else{
//                memberVC.accessType = AccessTypeLookOther;
//            }
//            memberVC.pushType = PushTypesButtom;
//            
//            CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberVC];
//            [self.navigationController presentModalViewController:nav animated:YES];
//            
//            RELEASE_SAFE(nav);
//            RELEASE_SAFE(memberVC);
//        }
    }
    
}

#pragma mark -- 搜索功能自定义tableView delegate,dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchCtl.searchResultsTableView) {
        return _searchResults.count;
    } else if (tableView == _listTableview) {
        NSArray *arr = [_dataDict objectForKey:[_keysArr objectAtIndex:section]];
        return  arr.count;
    }
    return section;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        
    } else if (tableView == _listTableview) {
    
        static NSString *GroupCell = @"GroupCell";
        
        personalCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupCell];
        
        if (cell == nil) {
            cell = [[[personalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupCell]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        NSArray *orgArr = [_dataDict objectForKey:[_keysArr objectAtIndex:indexPath.section]];
        
        NSString *conpanyName;
        
        //组织列表数据
        int isMsg = [[[orgArr objectAtIndex:indexPath.row]objectForKey:@"is_supply"]intValue];
        conpanyName = [[orgArr objectAtIndex:indexPath.row]objectForKey:@"company_name"];
        NSString *honor = [[orgArr objectAtIndex:indexPath.row]objectForKey:@"honor"];
        //激活状态
        int activateStatus = [[[orgArr objectAtIndex:indexPath.row]objectForKey:@"status"]intValue];
        //邀请状态
        int inviteStatus = [[[orgArr objectAtIndex:indexPath.row] objectForKey:@"invite_status"] intValue];
        
        [cell setCellStyleShowMsg:isMsg company:conpanyName tips:honor];
        
        [cell inviteButtonIsHidden:activateStatus];
        if (activateStatus) {
            
        }else{
            [cell setButtonTitleType:MemberlistTypeOrg isInvite:inviteStatus];
        }
        
        cell.companyLabel.text = conpanyName;
        
        NSString *nameStr = [[orgArr objectAtIndex:indexPath.row]objectForKey:@"realname"];
        //动态计算宽度
        CGSize titleSize = [nameStr sizeWithFont:KQLSystemFont(16) constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
        CGFloat topMargin;
        if (conpanyName.length !=0) {
            topMargin = 5.f;
        }else{
            topMargin = 15.f;
        }
        cell.userName.frame = CGRectMake(66.f, 10.f, titleSize.width + 10, 30);
        cell.positionLabel.frame = CGRectMake(85 + titleSize.width, 10.f, 100, 30);
        cell.companyLabel.frame = CGRectMake(66.f,30, 200, 30);
        
        cell.userName.text = nameStr;
        
        NSURL *imgUrl = [NSURL URLWithString:[[orgArr objectAtIndex:indexPath.row]objectForKey:@"portrait"]];
        
        if ([[orgArr[indexPath.row]objectForKey:@"sex"] intValue] == 1) {
            
            [cell.headView setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME)];
        }else{
            [cell.headView setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
        }
        
        [cell.inviteBtn setTag:[[[orgArr objectAtIndex:indexPath.row]objectForKey:@"user_id"] intValue]];
        cell.inviteBtn.cellIndexPath = indexPath;
        
        [cell.inviteBtn addTarget:self action:@selector(inviteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return nil;
}

#pragma mark - inviteButtonClick
-(void) inviteButtonClick:(CircleCellEditButton*) sender{
    editButton = sender;
    _selectIndexPath = sender.cellIndexPath;
    
    NSString *nameString = nil;
    //booky 9.5 分开搜索，分别取数据呀
//    if (isSearch) {
//        nameString = [[_searchResultArr objectAtIndex:_selectIndexPath.row] objectForKey:@"realname"];
//    }else{
        NSArray *orgArr = [_dataDict objectForKey:[_keysArr objectAtIndex:_selectIndexPath.section]];
        nameString = [[orgArr objectAtIndex:_selectIndexPath.row]objectForKey:@"realname"];
//    }
    
    //    add vincent
    //    NSArray *orgArr = [_dataDict objectForKey:[_keysArr objectAtIndex:_selectIndexPath.section]];
    //    NSString *nameString = [[orgArr objectAtIndex:_selectIndexPath.row]objectForKey:@"realname"];
    
    //    @"系统将发送一条短信邀请xx加入云圈，请确认是否发送"
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"邀请加入云圈" message:[NSString stringWithFormat:@"系统将发送一条短信邀请%@加入云圈，请确认是否发送。",nameString] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 10000;
    [alertView show];
    [alertView release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchCtl.searchResultsTableView){
        return 60.f;
    } else if (tableView == _listTableview) {
        return 60.0;
    }
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
        
    } else if (tableView == _listTableview) {
        
        NSArray *orgArr = [_dataDict objectForKey:[_keysArr objectAtIndex:indexPath.section]];
        
        MemberMainViewController* memberVC = [[MemberMainViewController alloc] init];
        memberVC.lookId = [[[orgArr objectAtIndex:indexPath.row] objectForKey:@"user_id"]intValue];
        //        add vincent
        if (memberVC.lookId == [[Global sharedGlobal].user_id longLongValue] ) {
            memberVC.accessType = AccessTypeSelf;
        }else{
            memberVC.accessType = AccessTypeLookOther;
        }
        memberVC.pushType = PushTypesButtom;
        
        CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberVC];
        [self.navigationController presentModalViewController:nav animated:YES];
        
        RELEASE_SAFE(nav);
        RELEASE_SAFE(memberVC);
        
    }
}

#pragma mark -- UISearchBarDelegate

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

#pragma mark -- 返回按钮及事件

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

@end
