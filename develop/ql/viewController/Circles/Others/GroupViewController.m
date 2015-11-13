//
//  GroupViewController.m
//  ql
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "GroupViewController.h"
#import "personalCell.h"
#import "CreateCircleViewController.h"
#import "CircleMainViewController.h"
#import "PinYinForObjc.h"
#import "YLDataObj.h"
#import "PXAlertView.h"
#import "UIImageScale.h"
#import "UIImageView+WebCache.h"
#import "circle_member_list_model.h"
#import "org_member_list_model.h"
#import "circle_contacts_model.h"
#import "MemberMainViewController.h"
#import "TcpRequestHelper.h"
#import "TYDotIndicatorView.h"
#import "CRNavigationController.h"
#import "CircleEditActionSheet.h"
#import "TemporaryCircleManager.h"

#import "CircleDetailSelfViewController.h"

@interface GroupViewController ()
{
    CGFloat padding;
    NSMutableArray *checkIndexArr;
    UITextField *_msgTextField;
    NSMutableArray *_editArray;
    MBProgressHUD *_progressHUD;//加载提示框
    UIButton *editBtn;          //上bar编辑按钮
    UIButton *detailBtn;        //上bar详情按钮
    BOOL isHidden;              //是否隐藏cell编辑按钮
    TYDotIndicatorView *_darkCircleDot;
}
@property (nonatomic ,retain) UITextField *msgTextField;
@property (nonatomic ,retain) NSMutableArray *allContactArr;//所有联系人中圈子的成员数据
@end

@implementation GroupViewController
@synthesize searchBar = _searchBar;
@synthesize searchCtl = _searchCtl;
@synthesize keyArr,dataDict,listType,orgName,orgId,circleId,orgIntro,createrName,circleDic,circleArr;
@synthesize msgTextField = _msgTextField;
@synthesize allContactArr = _allContactArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         _memberArray = [[NSMutableArray alloc]initWithCapacity:0];
        checkIndexArr = [[NSMutableArray alloc]initWithCapacity:0];
        _editArray = [[NSMutableArray alloc]initWithCapacity:0];
        _allContactArr = [[NSMutableArray alloc]initWithCapacity:0];
        
        _enterFromDetail = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [super viewDidLoad];
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
  
    // 表格
    [self mainViewList];
    
    // 搜索框
    [self searchBarInit];
    
    //loading
    _darkCircleDot = [[TYDotIndicatorView alloc] initWithFrame:CGRectMake(0, 0, KUIScreenWidth, KUIScreenHeight) dotStyle:TYDotIndicatorViewStyleCircle dotColor:[UIColor colorWithWhite:0.7 alpha:1.0] dotSize:CGSizeMake(10, 10)];
    _darkCircleDot.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.1];
    [_darkCircleDot startAnimating];
    [self.view addSubview:_darkCircleDot];
    
    //组织成员列表
    if (self.listType == MemberlistTypeOrg) {
        
        self.title = self.orgName;
        
        [self accessOrgListService];

    }else if (self.listType == MemberlistTypeCircle)
    {
        self.title = @"成员";
        isHidden = YES;
        //圈子成员列表
        [self circleArrData];
        [self initNavBar];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if (_groupTableView) {
        [_groupTableView reloadData];
    }
}

// 数据处理
- (void)circleArrData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 根据数据首字母排列数据
        self.dataDict = [YLDataObj accordingFirstLetterGetTips:self.circleArr];
        self.keyArr = [[[self.dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
        
        // 获取所有名字
        for (int i =0; i<self.keyArr.count; i++) {
            [_memberArray addObjectsFromArray:[self.dataDict objectForKey:[self.keyArr objectAtIndex:i]]];
        }
        
        //获取联系人的公司和职务信息
        circle_contacts_model *contactMod = [[circle_contacts_model alloc]init];
        
        for (int i =0; i<_memberArray.count; i++) {
            contactMod.where = [NSString stringWithFormat:@"user_id = %@",[[_memberArray objectAtIndex:i]objectForKey:@"user_id"]];
            NSArray *myCircleArr = [contactMod getList];
            [_allContactArr addObject:myCircleArr];
        }
        
        RELEASE_SAFE(contactMod);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_groupTableView reloadData];
            
            if (_darkCircleDot) {
                [_darkCircleDot removeFromSuperview];
            }
            
        });
    });
}

// 主界面
- (void)mainViewList{
    
    _groupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, KUIScreenWidth, KUIScreenHeight - 50) style:UITableViewStylePlain];
    
    _groupTableView.dataSource = self;
    
    _groupTableView.delegate = self;
    
    _groupTableView.backgroundColor = [UIColor clearColor];
    
//    _groupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _groupTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_groupTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:_groupTableView];
    
    if (IOS_VERSION_7) {
        // ios7的UITableVIew按字母排序的索引怎么改成背景是透明
        if ([_groupTableView respondsToSelector:@selector(setSectionIndexColor:)]) {
            
            _groupTableView.sectionIndexBackgroundColor = [UIColor clearColor];
            
            _groupTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
            
            // 索引字体颜色
//            _groupTableView.sectionIndexColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
            _groupTableView.sectionIndexColor = COLOR_GRAY2;
        }
    }

}

//上Bar按钮
- (void)initNavBar{
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    [editBtn setFrame:CGRectMake(0.f, 0.f, 40.f, 30.f)];
    [editBtn setTag:123];
    [editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    
    detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    [detailBtn setTag:321];
    [detailBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    [detailBtn setFrame:CGRectMake(0.f, 0.f, 50.f, 30.f)];
    [detailBtn addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
   
    
    UIBarButtonItem  *detailItem = [[UIBarButtonItem  alloc]  initWithCustomView:detailBtn];
    UIBarButtonItem  *editItem = [[UIBarButtonItem  alloc]  initWithCustomView:editBtn];
    
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:detailItem,editItem ,nil];
    
    self.navigationItem.rightBarButtonItems = buttonArray;
    
    if ([[self.circleDic objectForKey:@"creater_id"] intValue] != [[Global sharedGlobal].user_id intValue]) {
        editBtn.hidden = YES;
    }
    
    if (self.enterFromDetail) {
        editBtn.hidden = YES;
        detailBtn.hidden = YES;
    }
    
    if (self.circleArr.count < 2) {
        editBtn.hidden = YES;
    }
    
}

// 搜索框
- (void)searchBarInit {
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.frame = CGRectMake(0.0f, 0.f, KUIScreenWidth, 40.0f);
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
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
//    _searchBar.barStyle = UIBarStyleBlack;
    
//    if (IOS_VERSION_7) {
//        _searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    }
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KUIScreenWidth, 44.f)];
    _groupTableView.tableHeaderView = headView;
    [headView addSubview:_searchBar];
    RELEASE_SAFE(headView);
    
    //搜索控制器
    _searchCtl = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchCtl.active = NO;
    _searchCtl.searchResultsDataSource = self;
    _searchCtl.searchResultsDelegate = self;
    _searchCtl.delegate = self;
    _searchCtl.searchResultsTableView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    [self setSearchCtl:_searchCtl];
    
}

// 编辑
- (void)editClick{
    isHidden =  NO;
    [editBtn setHidden:YES];
    
    [detailBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    [_groupTableView reloadData];
}

// 详情
- (void)detailClick{
    if (isHidden) {
        //是否改变详情按钮标题
        CircleDetailSelfViewController* detailCtl = [[CircleDetailSelfViewController alloc] init];
        detailCtl.circleId = [[self.circleDic objectForKey:@"circle_id"] longLongValue];
        
        [self.navigationController pushViewController:detailCtl animated:YES];
        RELEASE_SAFE(detailCtl);
        
    }else{
        isHidden =  YES;
        [editBtn setHidden:NO];
        
        [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
        [_groupTableView reloadData];
    }
    
}

- (void)dealloc
{
    RELEASE_SAFE(_groupTableView);
    [self setSearchCtl:nil];
    
    [super dealloc];
}

// 列表中邀请或编辑按钮点击
- (void)listButtonClick:(UIButton *)sender{
    
    //IOS7获取点击cell，cell上面还多了一个UITableViewWrapperView，所以需UITableViewCell.superview.superview获取UITableView
    personalCell *cell;
    
    if (IOS_VERSION_7) {
        cell = (personalCell*)[[[sender superview] superview]superview];
        
    }else{
        cell = (personalCell*)[[sender superview] superview];
    }
    
    NSString *indexPaths = [NSString stringWithFormat:@"%d",sender.tag];
    
    if (indexPaths.length >= 1000) {
        indexPaths = [NSString stringWithFormat:@"0%d",sender.tag - 1000];
    }
    
    if ([checkIndexArr indexOfObject:indexPaths] == NSNotFound) {
        
        // 点击标记的数组
        [checkIndexArr addObject:indexPaths];
        
        [cell setButtonTitleType:self.listType isInvite:1];
    
    }

    NSString *section;
    NSString *row;
    // 超过10个section以上的判断
    switch (indexPaths.length) {
        case 3:
        {
            section = [indexPaths substringToIndex:2];
            row = [indexPaths substringFromIndex:2];
        }
            break;
        case 4:
        {
            section = [indexPaths substringToIndex:3];
            row = [indexPaths substringFromIndex:3];
        }
            break;
        default:
        {
            section = [indexPaths substringToIndex:1];
            row = [indexPaths substringFromIndex:1];
        }
            break;
    }
    
    switch (self.listType) {
        // 邀请
        case MemberlistTypeOrg:
        {
            [self accessInviteService];
            
        }
            break;
        // 编辑
        case MemberlistTypeCircle:
        {
            NSLog(@"编辑%d",sender.tag);
            CircleCellEditButton * editButton = (CircleCellEditButton *)sender;
            
            CircleEditActionSheet *edtiSheet = [[CircleEditActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置头衔" otherButtonTitles:@"从圈子中删除", nil];
            [edtiSheet showInView:self.view];
            edtiSheet.tag = [indexPaths intValue];
            edtiSheet.cellIndexPath = editButton.cellIndexPath;
            
            RELEASE_SAFE(edtiSheet);

        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}
#pragma mark - IBActionSheet/UIActionSheet Delegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSIndexPath * selectIndexPath = nil;
    
    if ([actionSheet isKindOfClass:[CircleEditActionSheet class]]) {
        CircleEditActionSheet * currentSheet = (CircleEditActionSheet *)actionSheet;
        selectIndexPath = currentSheet.cellIndexPath;
    }
    
    NSLog(@"actionSheet==%d",actionSheet.tag);
    
    
    // 之前峰哥写的拿index的方法  好坑  引以为戒!!!!!
//    NSString *indexPaths = [NSString stringWithFormat:@"%d",actionSheet.tag];
//    
//    NSString *section;
//    NSString *row;
  
//    if (actionSheet.tag >= 1000 ) {
//        // 如果是第0个section特殊处理
//        section = @"0";
//        row = [NSString stringWithFormat:@"%d",actionSheet.tag - 10000];
//       
//    }else{
//        
//        // 超过10个section以上的判断
//        switch (indexPaths.length) {
//            case 3:
//            {
//                section = [indexPaths substringToIndex:2];
//                row = [indexPaths substringFromIndex:2];
//            }
//                break;
//            case 4:
//            {
//                section = [indexPaths substringToIndex:3];
//                row = [indexPaths substringFromIndex:3];
//            }
//                break;
//            default:
//            {
//                section = [indexPaths substringToIndex:1];
//                row = [indexPaths substringFromIndex:1];
//            }
//                break;
//        }
//    }

    NSArray *orgArr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:selectIndexPath.section]];
    
    switch (buttonIndex) {
        case 0://设置头衔
        {
            UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, 300.f, 100.f)];
            mainView.backgroundColor = [UIColor whiteColor];
            mainView.tag = actionSheet.tag;
            
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(25.f, 20.f, 45.f, 45.f)];
            img.backgroundColor = [UIColor grayColor];
            img.layer.cornerRadius = 22;
            img.clipsToBounds = YES;
            
            NSURL *imgUrl = [NSURL URLWithString:[[orgArr objectAtIndex:selectIndexPath.row]objectForKey:@"portrait"]];
            
            [img setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
            [mainView addSubview:img];
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(25.f, 65.f, 60.f, 30.f)];
            title.text = [[orgArr objectAtIndex:selectIndexPath.row]objectForKey:@"realname"];
            title.font = KQLSystemFont(14);
            [mainView addSubview:title];
            
            UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(115.f, 30.f, 140.f, 40.f)];
            field.backgroundColor = [UIColor whiteColor];
            field.placeholder = @" 输入头衔";
            [field becomeFirstResponder];
            self.msgTextField = field;
            [mainView addSubview:field];
            
            // 分割线
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(115.f, 70.f, 150.f, 1.f)];
            line.backgroundColor = RGBACOLOR(220, 220, 220, 1);
            [mainView addSubview:line];
            RELEASE_SAFE(line);
            
            RELEASE_SAFE(field);
            RELEASE_SAFE(img);
            RELEASE_SAFE(title);
     
            [PXAlertView showAlertWithTitle:@"设置头衔" message:@"" cancelTitle:@"确定" otherTitle:@"" contentView:mainView alertDelegate:self completion:^(BOOL cancelled) {}];
        }
            break;
        case 1://从圈子中删除
        {
            
            int talk_type = [[self.circleDic objectForKey:@"talk_type"]intValue];
            NSDictionary * userInfoDic = [orgArr objectAtIndex:selectIndexPath.row];
            NSNumber * circleIDNum = [NSNumber numberWithLongLong:[[self.circleDic objectForKey:@"circle_id"]longLongValue]];
            NSNumber * deleteMemberID = [userInfoDic objectForKey:@"user_id"];
            
            //不能删除创建者
            if ([[self.circleDic objectForKey:@"creater_id"] intValue] == [deleteMemberID intValue]) {
                [Common checkProgressHUD:@"不能删除创建者哦~" andImage:nil showInView:self.view];
                return;
            }
            
            //判断成员的删除类型 分为固定圈子删除 和临时圈子删除成员
            if (talk_type == MessageListTypeTempCircle) {
                TemporaryCircleManager *tcManager = [TemporaryCircleManager new];
                tcManager.fatherDelegate = self;
                tcManager.removeIndexPath = selectIndexPath;
                [tcManager removeTemporaryMemberWithTempCircleID:circleIDNum.longLongValue AndMemebrID:deleteMemberID.longLongValue];
            } else {
                CircleManager *cManager = [CircleManager new];
                cManager.fatherDelegate = self;
                cManager.removeIndexPath = selectIndexPath;
                [cManager removeMemberFromCircle:circleIDNum.longLongValue andUserID:deleteMemberID.longLongValue];
            }
        }
            break;
    
        default:
            break;
    }
}

#pragma mark - PXAlertDelegate
- (void)alertViews:(PXAlertView *)alertView clickedButtonAtIndex:(UIButton *)buttonIndexs{
  
    NSLog(@"buttonIndexs===%d",buttonIndexs.tag);
    NSString *indexPaths = [NSString stringWithFormat:@"%d",buttonIndexs.tag];
    
    NSString *section;
    NSString *row;
    
    if (buttonIndexs.tag >= 1000 ) {
        // 如果是第0个section特殊处理
        section = @"0";
        row = [NSString stringWithFormat:@"%d",buttonIndexs.tag - 10000];
        
    }else{
        // 超过10个section以上的判断
        switch (indexPaths.length) {
            case 3:
            {
                section = [indexPaths substringToIndex:2];
                row = [indexPaths substringFromIndex:2];
            }
                break;
            case 4:
            {
                section = [indexPaths substringToIndex:3];
                row = [indexPaths substringFromIndex:3];
            }
                break;
            default:
            {
                section = [indexPaths substringToIndex:1];
                row = [indexPaths substringFromIndex:1];
            }
                break;
        }
    }
    
    NSArray *orgArr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:[section intValue]]];
    
    UIButton *editBtns = (UIButton *)[_groupTableView viewWithTag:[indexPaths intValue]];
    
    personalCell *cell;
    
    if (IOS_VERSION_7) {
        cell = (personalCell*)[[[editBtns superview] superview]superview];
        
    }else{
        
        cell = (personalCell*)[[editBtns superview] superview];
    
    }
    
    //设置头衔接口
    [self accessUpdateCircleJobService:[[[orgArr objectAtIndex:[row intValue]]objectForKey:@"user_id"] intValue]];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.searchCtl.searchResultsTableView)
    {
        return 1;
    }else{
        return self.keyArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchCtl.searchResultsTableView)
    {
        return _searchResults.count;
    }else{
        NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:section]];
        return  arr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //搜索结果列表
    if (tableView == self.searchCtl.searchResultsTableView) {
        
        static NSString *searchCell = @"searchCell";
        
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        personalCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
        
        if (nil == cell) {
            cell = [[[personalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCell]autorelease];
            
            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell.userName.text = [_searchResults[indexPath.row]objectForKey:@"realname"];
        cell.companyLabel.text = [_searchResults[indexPath.row] objectForKey:@"company_name"];
        
        cell.userName.frame = CGRectMake(66.f, 10.f, 100, 30);
        cell.companyLabel.frame = CGRectMake(66.f,30, 200, 30);
        
        [cell inviteButtonIsHidden:YES];
        
        NSURL *imgUrl = [NSURL URLWithString:[[_searchResults objectAtIndex:indexPath.row]objectForKey:@"portrait"]];
        
        if ([[_searchResults[indexPath.row]objectForKey:@"sex"] intValue] == 1) {
            
            [cell.headView setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME)];
        }else{
            [cell.headView setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
        }
        
        return cell;
        
    }else{
        
        static NSString *GroupCell = @"GroupCell";
        
        personalCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupCell];
    
        if (cell == nil) {
            cell = [[[personalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupCell]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        
        NSArray *orgArr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:indexPath.section]];
        
        NSString *conpanyName;
        
        //组织列表数据
        if (self.listType == MemberlistTypeOrg) {
            
            int isMsg = [[[orgArr objectAtIndex:indexPath.row]objectForKey:@"is_supply"]intValue];
            conpanyName = [[orgArr objectAtIndex:indexPath.row]objectForKey:@"company_name"];
//            NSString *honor = [[orgArr objectAtIndex:indexPath.row]objectForKey:@"honor"];
            NSString *honor = [NSString stringWithFormat:@"%d",[[[orgArr objectAtIndex:indexPath.row]objectForKey:@"honor"] intValue]];
            int inviteStatus = [[[orgArr objectAtIndex:indexPath.row]objectForKey:@"status"]intValue];
            
            [cell setCellStyleShowMsg:isMsg company:conpanyName tips:honor];
            [cell inviteButtonIsHidden:inviteStatus];
            
        }//圈子列表数据
        else if (self.listType == MemberlistTypeCircle){
            
            if (isHidden) {
                
                [cell inviteButtonIsHidden:YES];
                
            }else{
                [cell inviteButtonIsHidden:NO];
            }
            NSString *roles = [[orgArr objectAtIndex:indexPath.row]objectForKey:@"role"];
            conpanyName = [[[self.allContactArr objectAtIndex:indexPath.row] lastObject] objectForKey:@"company_name"];
            
            [cell setCellStyleShowMsg:1 company:conpanyName tips:roles];
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
            
            [cell.headView setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
        }else{
            [cell.headView setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME)];
        }
        
        NSString *indexPaths;
        //如果是第0个section特殊处理
        if (indexPath.section == 0) {
            
            indexPaths = [NSString stringWithFormat:@"%d%d",indexPath.section + 1000,indexPath.row];
            
        }else{
            
            indexPaths = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];
            
        }
        
    
        [cell.inviteBtn setTag:indexPaths.intValue];
        cell.inviteBtn.cellIndexPath = indexPath;
        
        // 标记的数组中查找
        if ([checkIndexArr indexOfObject:indexPaths] != NSNotFound) {
            
            [cell setButtonTitleType:self.listType isInvite:1];
            
        } else {
            
            [cell setButtonTitleType:self.listType isInvite:0];
        }
        
        
        [cell.inviteBtn addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //搜索结果列表
    if (tableView == self.searchCtl.searchResultsTableView) {
        
        [self.searchCtl.searchBar resignFirstResponder];
        
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
//        [self.navigationController pushViewController:memberMainView animated:YES];
//        [self presentViewController:memberMainView animated:YES completion:nil];
        CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberMainView];
        [self.navigationController presentModalViewController:nav animated:YES];
        RELEASE_SAFE(nav);
        RELEASE_SAFE(memberMainView);
    }else{
        
        NSArray *orgArr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:indexPath.section]];
   
        MemberMainViewController* memberVC = [[MemberMainViewController alloc] init];
        memberVC.lookId = [[[orgArr objectAtIndex:indexPath.row] objectForKey:@"user_id"]intValue];
//        memberVC.accessType = AccessTypeLookOther;
        memberVC.pushType = PushTypesButtom;
        
        if (memberVC.lookId == [[Global sharedGlobal].user_id longLongValue] ) {
            memberVC.accessType = AccessTypeSelf;
        }else{
            memberVC.accessType = AccessTypeLookOther;
        }
        CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberVC];
        [self.navigationController presentModalViewController:nav animated:YES];
        
        RELEASE_SAFE(nav);
        RELEASE_SAFE(memberVC);
    }
}

// 返回header视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 40.f)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, -5.f,KUIScreenWidth, 30.f)];
    label.backgroundColor = [UIColor clearColor];
    
    
    label.font = [UIFont systemFontOfSize:14];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    [arr addObjectsFromArray:self.keyArr];
    
    if ([self.searchBar.text length] <= 0) {
        
        for (int i =0; i<arr.count; i++) {
            
            label.text = [NSString stringWithFormat:@"%@",[arr objectAtIndex:section]];
            
        }
    }else{
        label.text = @"搜索结果";
    }
    [view addSubview:label];
//    view.backgroundColor = RGBACOLOR(38, 41, 45, 1);
    view.backgroundColor = [UIColor colorWithPatternImage:[[ThemeManager shareInstance] getThemeImage:@"under_bar.png"]];
    
    if (tableView == self.searchCtl.searchResultsTableView) {
        label.textColor = [UIColor darkGrayColor];
    }else{
        label.textColor = [UIColor darkGrayColor];
        
    }
    
    [label release], label = nil;
    
    return [view autorelease];
}

// 返回索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([self.searchBar.text length] <= 0) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        
        [arr addObjectsFromArray:self.keyArr];
        
        return arr;
    }else{
        return nil;
    }
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
    _searchResults = [[NSMutableArray alloc]init];
    
    NSMutableArray* allContactAndCompanyArr = [NSMutableArray arrayWithCapacity:_memberArray.count];
    
    for (NSDictionary* dic in _memberArray) {
        NSString* str = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"realname"],[dic objectForKey:@"company_name"]];
        [allContactAndCompanyArr addObject:str];
        NSLog(@"--dic:%@--",dic);
    }
    
    if (self.searchBar.text.length > 0 && ![Common isIncludeChineseInString:self.searchBar.text]) {
        
        if (self.listType == MemberlistTypeOrg) {
            
        }else if(self.listType == MemberlistTypeCircle){
            
        }
        
        for (int i=0; i<_memberArray.count; i++) {
            
            // 判断NSString中的字符是否为中文
            if ([Common isIncludeChineseInString:allContactAndCompanyArr[i]]) {
                
                // 转换为拼音
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:allContactAndCompanyArr[i]];
                
                // 搜索是否在转换后拼音中
                NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    
                    [_searchResults addObject:_memberArray[i]];
                    
                }else{
                    // 转换为拼音的首字母
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:allContactAndCompanyArr[i]];
                    
                    // 搜索是否在范围中
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    
                    if (titleHeadResult.length>0) {
                        [_searchResults addObject:_memberArray[i]];
                    }
                }
                
            }
            else {
                
                NSRange titleResult=[allContactAndCompanyArr[i] rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    [_searchResults addObject:_memberArray[i]];
                }
            }
        }
    } else if (self.searchBar.text.length>0 && [Common isIncludeChineseInString:self.searchBar.text]) {
        
        for (int i=0; i<_memberArray.count; i++) {
            NSString *tempStr = allContactAndCompanyArr[i];
            
            NSRange titleResult=[tempStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            
            if (titleResult.length>0) {
                [_searchResults addObject:[_memberArray objectAtIndex:i]];
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


#pragma mark - CircleManagerDelegate 

//删除成语回调 删除成员列表对应的cell
- (void)removeMemberSucess:(CircleManager *)sender
{
    NSIndexPath * selectIndex = sender.removeIndexPath;
    NSArray * indexPathArr = [NSArray arrayWithObjects:selectIndex, nil];
    
    //删除表数据源
    NSMutableArray * selectSectionArr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:selectIndex.section]];
    NSDictionary * selectDic = [selectSectionArr objectAtIndex:selectIndex.row];
    [selectSectionArr removeObject:selectDic];
    
    //从table中删除该数据
    [_groupTableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
    RELEASE_SAFE(sender);
}

#pragma mark - accessService

//邀请开通加入
- (void)accessInviteService{
    
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                        [NSNumber numberWithInt:4],@"invitee_id",
                                        [Global sharedGlobal].org_id,@"org_id",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:INVITE_OTHER_COMMAND_ID accessAdress:@"inviteactivation.do?param=" delegate:self withParam:nil];
}

//组织列表
- (void)accessOrgListService{
    
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                        [NSNumber numberWithInt:self.orgId],@"org_id",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:ORG_MEMBER_LIST_COMMAND_ID accessAdress:@"organizationdetail.do?param=" delegate:self withParam:nil];
}

//圈子成员列表
- (void)accessCircleListService{
    
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                        [NSNumber numberWithInt:self.circleId],@"circle_id",
                                        [NSNumber numberWithInt:0],@"ver",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:GROUP_MEMBER_LIST_COMMAND_ID accessAdress:@"circle/detail.do?param=" delegate:self withParam:nil];
}

//圈子成员头衔修改
- (void)accessUpdateCircleJobService:(int)userId{
    
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:userId],@"user_id",
                                        [NSNumber numberWithInt:[[self.circleDic objectForKey:@"circle_id"] intValue]],@"circle_id",
                                        self.msgTextField.text,@"role",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:CIRCLE_MEMBER_DUTY_COMMAND_ID accessAdress:@"circle/updateusertitle.do?param=" delegate:self withParam:nil];
}

#pragma mark- HttpRequestDelegate

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    
    if (_darkCircleDot) {
        [_darkCircleDot removeFromSuperview];
    }
    
    ParseMethod safeParseMethod = ^(){
        switch (commandid) {
            case INVITE_OTHER_COMMAND_ID:
            {
                
                int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
                NSLog(@"resultInt=%d",resultInt);
                
                if (resultInt == 0) {
                    [self performSelectorOnMainThread:@selector(inviteError) withObject:nil waitUntilDone:NO];
                    
                }
                else if(resultInt == 1){
                    
                    [self performSelectorOnMainThread:@selector(inviteSuccess) withObject:nil waitUntilDone:NO];
                }
                else if(resultInt == 2){
                    
                    [self performSelectorOnMainThread:@selector(notInvite) withObject:nil waitUntilDone:NO];
                }
                
            }break;
            case ORG_MEMBER_LIST_COMMAND_ID:
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    // 根据数据首字母排列数据
                    self.dataDict = [YLDataObj accordingFirstLetterGetTips:[[resultArray lastObject] objectForKey:@"members"]];
                    
                    self.keyArr = [[[self.dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
                    
                    // 获取所有名字
                    for (int i =0; i<self.keyArr.count; i++) {
                        [_memberArray addObjectsFromArray:[self.dataDict objectForKey:[self.keyArr objectAtIndex:i]]];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_groupTableView reloadData];
                        
                    });
                    
                    NSLog(@"keyArr====%@====%@----%@",self.keyArr,_memberArray,self.dataDict);
                    
                });
            }break;
            case GROUP_MEMBER_LIST_COMMAND_ID:
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *resultDic = [resultArray lastObject];
                    
                    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
                    
                    //创建模型
                    circle_member_list_model *circlelistMod = [[circle_member_list_model alloc] init];
                    
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
                                              [NSNumber numberWithInt:self.circleId],@"circle_id",
                                              nil];
                        
                        circlelistMod.where = [NSString stringWithFormat:@"user_id = %d and circle_id = %d",[[orgDic objectForKey:@"user_id"] intValue], self.circleId];
                        
                        NSMutableArray *dbArray = [circlelistMod getList];
                        
                        if ([dbArray count] > 0) {
                            [circlelistMod updateDB:dict];
                        } else {
                            [circlelistMod insertDB:dict];
                        }
                    }
                    
                    [circlelistMod release];
                    [pool release];
                    
                    // 根据数据首字母排列数据
                    self.dataDict = [YLDataObj accordingFirstLetterGetTips:[[resultArray lastObject] objectForKey:@"members"]];
                    
                    
                    self.keyArr = [[[self.dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
                    
                    // 获取所有名字
                    for (int i =0; i<self.keyArr.count; i++) {
                        [_memberArray addObjectsFromArray:[self.dataDict objectForKey:[self.keyArr objectAtIndex:i]]];
                    }
                    
                    //获取联系人的公司和职务信息
                    circle_contacts_model *contactMod = [[circle_contacts_model alloc]init];
                    
                    for (int i =0; i<_memberArray.count; i++) {
                        contactMod.where = [NSString stringWithFormat:@"user_id = %@",[[_memberArray objectAtIndex:i]objectForKey:@"user_id"]];
                        NSArray *myCircleArr = [contactMod getList];
                        [_allContactArr addObject:myCircleArr];
                    }
                    
                    RELEASE_SAFE(contactMod);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_groupTableView reloadData];
                        
                    });
                    
                    NSLog(@"keyArr323====%@====%@----%@",self.keyArr,_memberArray,self.dataDict);
                    
                });
            }break;
                
            case CIRCLE_MEMBER_DUTY_COMMAND_ID:
            {
                int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
                
                if (resultInt == 0) {
                    [self performSelectorOnMainThread:@selector(setTitleError) withObject:nil waitUntilDone:NO];
                    
                }
                else if(resultInt == 1){
                    
                    [self performSelectorOnMainThread:@selector(setTitleSuccess) withObject:nil waitUntilDone:NO];
                }
                
            }break;
                
            case CIRCLE_MEMBER_DELETE_COMMAND_ID:
            {
                // 删除成员操作回调 进行界面数据跟新和数据库修改操作
                if ([[[resultArray firstObject]objectForKey:@"ret"]intValue]==1)
                {
//                    NSDictionary * param = [resultArray lastObject];
//                    NSIndexPath * selectIndex = [param objectForKey:@"indexPath"];
//                    long long circle_id = [[param objectForKey:@"circle_id"]longLongValue];
//                    
//                    NSArray * indexPathArr = [NSArray arrayWithObjects:selectIndex, nil];
//                    
//                    //删除表数据源
//                    NSMutableArray * selectSectionArr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:selectIndex.section]];
//                    NSDictionary * selectDic = [selectSectionArr objectAtIndex:selectIndex.row];
//                    [selectSectionArr removeObject:selectDic];
//                    
//                    //从table中删除该数据
//                    [_groupTableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
//                    
//                    if ([circle_member_list_model deleteCircleMemberWithCircleID:self.circleId andMemberID:circle_id]) {
//                        [Common checkProgressHUD:@"删除成员成功" andImage:nil showInView:APPKEYWINDOW];
//                    } else {
//                        [Common checkProgressHUD:@"删除数据库数据有误" andImage:nil showInView:APPKEYWINDOW];
//                    };
//                } else {
//                    [Common checkProgressHUD:@"删除成员失败" andImage:nil showInView:APPKEYWINDOW];
                }
            }
                break;
            default:
                break;
        }
    };
    [Common securelyparseHttpResultArr:resultArray andMethod:safeParseMethod];
}

- (void)inviteError{
//    [Common checkProgressHUD:@"邀请失败" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"邀请失败" andImage:KAccessFailedIMG];
}


- (void)inviteSuccess{
//    [Common checkProgressHUD:@"已发送邀请" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"已发送邀请" andImage:KAccessSuccessIMG];
}

- (void)notInvite{
//    [Common checkProgressHUD:@"已经邀请过了" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"已经邀请过了" andImage:KAccessFailedIMG];
}

- (void)setTitleError{
//    [Common checkProgressHUD:@"修改失败" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"修改失败" andImage:KAccessFailedIMG];
}
- (void)setTitleSuccess{
//    [Common checkProgressHUD:@"修改成功" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"修改成功" andImage:KAccessSuccessIMG];
}

@end
