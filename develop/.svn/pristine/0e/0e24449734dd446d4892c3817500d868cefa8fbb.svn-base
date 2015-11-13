//
//  CircleMemberList.m
//  ql
//
//  Created by yunlai on 14-7-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "CircleMemberList.h"
#import "personalCell.h"

#import "YLDataObj.h"
#import "PinYinForObjc.h"
#import "UIImageView+WebCache.h"

#import "MemberMainViewController.h"
#import "CRNavigationController.h"

#import "circle_member_list_model.h"
#import "circle_list_model.h"

#import "temporary_circle_list_model.h"
#import "temporary_circle_member_list_model.h"

#import "CircleDetailSelfViewController.h"
#import "CircleDetailOtherViewController.h"
#import "CircleDetailOnlySelfViewController.h"

#import "TempCircleDetailSelfViewController.h"
#import "TempCircleDetailOtherViewController.h"

#import "CircleManager.h"
#import "TemporaryCircleManager.h"

#define CircleTag       100
#define TempCircleTag   101

@interface CircleMemberList ()<TemporaryCircleManagerDelegate,FatherCircleManagerDelegate,TempCircleDetailDelegate>{
    UIButton *editBtn;          //上bar编辑按钮
    UIButton *detailBtn;        //上bar详情按钮
    BOOL isHidden;              //是否隐藏cell编辑按钮
    
    NSDictionary* _circleDic;//圈子数据
//    选中的indexPath
    NSIndexPath* _selectIndexPath;
}

@property (nonatomic ,retain) UITextField *msgTextField;//头衔输入框
@property (nonatomic ,retain) NSMutableArray *allContactArr;//所有联系人中圈子的成员数据

@end

@implementation CircleMemberList

@synthesize msgTextField = _msgTextField;
@synthesize allContactArr = _allContactArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _memberArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    add vincent
//    self.title = _circleName;
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
	// Do any additional setup after loading the view.
//    获取圈子成员数据
    [self getCircleMemberListData];
//    加载主视图
    [self mainViewList];
//    初始化导航条
    [self initNavBar];
//    初始化搜索框
    [self searchBarInit];
}

//获取列表数据 区分开临时圈子和固定圈子
-(void) getCircleMemberListData{
    [_memberArr removeAllObjects];
    NSArray* circleMembersArr = nil;
    switch (self.circleType) {
        case TemporaryCircle:
        {
            circleMembersArr = [temporary_circle_member_list_model getAllMemberFormTempCircle:self.circleId];
            _circleDic = [[temporary_circle_list_model getTemporaryCircleListWithTempCircleID:self.circleId]retain];
        }
            break;
        case StableCircle:
        {
            //从数据库中读取组织成员信息
            circleMembersArr = [circle_member_list_model getAllMemberWithCircle:self.circleId];
            //获取圈子数据
            _circleDic = [[circle_list_model getCircleListWithCircleID:self.circleId]retain];
        }
        default:
            break;
    }
    // 根据数据首字母排列数据
    _dataDict = [[YLDataObj accordingFirstLetterGetTips:circleMembersArr] mutableCopy];
    _keysArr = [[[_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
    // 获取所有名字
    for (int i =0; i<_keysArr.count; i++) {
        [_memberArr addObjectsFromArray:[_dataDict objectForKey:[_keysArr objectAtIndex:i]]];
    }
    self.title = [NSString stringWithFormat:@"成员(%d)",[_memberArr count]];
}

// 主界面
- (void)mainViewList{
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, KUIScreenWidth, KUIScreenHeight - 50) style:UITableViewStylePlain];
    
    _tableview.dataSource = self;
    
    _tableview.delegate = self;
    
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableview.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:_tableview];
    
    if (IOS_VERSION_7) {
        // ios7的UITableVIew按字母排序的索引怎么改成背景是透明
        if ([_tableview respondsToSelector:@selector(setSectionIndexColor:)]) {
            
            _tableview.sectionIndexBackgroundColor = [UIColor clearColor];
            
            _tableview.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
            
            // 索引字体颜色
            _tableview.sectionIndexColor = COLOR_GRAY2;
        }
    }
}

// 搜索框
- (void)searchBarInit {
    
    //添加字母显示
    UIView *letterView = [[UIView alloc] initWithFrame:CGRectMake( (self.view.frame.size.width / 2) - 40 , ([UIScreen mainScreen].bounds.size.height / 2) - 80.0f , 80.0f , 80.0f)];
    
    UIImageView *letterBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , 80.0f , 80.0f)];
    UIImage *backImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"eatShow_selectCity_icon" ofType:@"png"]];
    letterBackImageView.image = backImage;
    [backImage release];
    [letterView addSubview:letterBackImageView];
    [letterBackImageView release];
    
    UILabel *letterLabel = [[UILabel alloc] initWithFrame: CGRectMake( 20.0f , 20.0f  , 40.0f , 40.0f)];
	letterLabel.textColor = [UIColor whiteColor];
	letterLabel.backgroundColor = [UIColor clearColor];
	letterLabel.font = [UIFont systemFontOfSize: 38];
	letterLabel.textAlignment = NSTextAlignmentCenter;
    letterLabel.tag = 1001;
	[letterView addSubview: letterLabel];
    [letterLabel release];
    
    letterView.tag = 1000;
    letterView.alpha = 0.0;
    [self.view addSubview:letterView];
    [letterView release];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.frame = CGRectMake(0.0f, 0.f, KUIScreenWidth, 40.0f);
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_searchBar.backgroundColor=[UIColor clearColor];
	_searchBar.translucent=YES;
	_searchBar.placeholder=@"搜索";
	_searchBar.delegate = self;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KUIScreenWidth, 44.f)];
    _tableview.tableHeaderView = headView;
    [headView addSubview:_searchBar];
    RELEASE_SAFE(headView);
    
    //搜索控制器
    _searchCtl = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchCtl.active = NO;
    _searchCtl.searchResultsDataSource = self;
    _searchCtl.searchResultsDelegate = self;
    _searchCtl.delegate = self;
    _searchCtl.searchResultsTableView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    _searchCtl.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

//上Bar按钮
- (void)initNavBar{
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIImage* image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    [cancelButton setImage:image forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0, 30, image.size.width, image.size.height);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    if (IOS_VERSION_7) {
        cancelButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    RELEASE_SAFE(leftItem);
    
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
    
    if ([[_circleDic objectForKey:@"creater_id"] intValue] != [[Global sharedGlobal].user_id intValue]) {
        editBtn.hidden = YES;
    }
    
    if (self.enterFromDetail) {
        editBtn.hidden = YES;
        detailBtn.hidden = YES;
    }
    
    if (_memberArr.count < 2) {
        editBtn.hidden = YES;
    }
    isHidden = YES;
}

//返回 处于编辑状态时不可点
-(void) cancelBtnClick{
    if (!isHidden) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// 编辑
- (void)editClick{
    isHidden =  NO;
    [editBtn setHidden:YES];
    
    [detailBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    [_tableview reloadData];
    
    _searchBar.userInteractionEnabled = NO;
}

// 详情
- (void)detailClick{
    if (isHidden) {
        BOOL isSelf = [[_circleDic objectForKey:@"creater_id"] intValue] == [[Global sharedGlobal].user_id intValue];
        
        //是否改变详情按钮标题
        UIViewController * detailController = nil;
        switch (self.circleType) {
            case TemporaryCircle:
            {
                if (isSelf) {
                    TempCircleDetailSelfViewController * tempSelfDetail = [TempCircleDetailSelfViewController new];
                    tempSelfDetail.circleId = self.circleId;
                    tempSelfDetail.delegate = self;
                    detailController = tempSelfDetail;
                } else {
                    TempCircleDetailOtherViewController * tempOtherDetail = [TempCircleDetailOtherViewController new];
                    tempOtherDetail.circleId = self.circleId;
                    tempOtherDetail.delegate = self;
                    detailController = tempOtherDetail;
                }
            }
                break;
            case StableCircle:
            {
                if (isSelf) {
                    if (_memberArr.count < 2) {
                        CircleDetailOnlySelfViewController* onlyDetailCtl = [[CircleDetailOnlySelfViewController alloc] init];
                        onlyDetailCtl.circleId = self.circleId;
                        detailController = onlyDetailCtl;
                    } else{
                        CircleDetailSelfViewController* detailCtl = [[CircleDetailSelfViewController alloc] init];
                        detailCtl.circleId = self.circleId;
                        detailController = detailCtl;
                    }
                } else {
                    CircleDetailOtherViewController* otherDetailCtl = [[CircleDetailOtherViewController alloc] init];
                    otherDetailCtl.circleId = [[_circleDic objectForKey:@"circle_id"] longLongValue];
                    detailController = otherDetailCtl;
                }
            }
                break;
            default:
                break;
        }
        
        if (detailController != nil) {
            [self.navigationController pushViewController:detailController animated:YES];
            RELEASE_SAFE(detailController);
        }
    }else{
        isHidden =  YES;
        [editBtn setHidden:NO];
        [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
        
        [self getCircleMemberListData];
        [_tableview reloadData];
        
        _searchBar.userInteractionEnabled = YES;
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _searchCtl.searchResultsTableView)
    {
        return 1;
    }else{
        return _keysArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _searchCtl.searchResultsTableView)
    {
        return _searchResultArr.count;
    }else{
        NSArray *arr = [_dataDict objectForKey:[_keysArr objectAtIndex:section]];
        return  arr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //搜索结果列表
    if (tableView == _searchCtl.searchResultsTableView) {
        
        static NSString *searchCell = @"searchCell";
        
        personalCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
        
        if (nil == cell) {
            cell = [[[personalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCell]autorelease];
            
            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell.userName.text = [_searchResultArr[indexPath.row]objectForKey:@"realname"];
        cell.companyLabel.text = [_searchResultArr[indexPath.row] objectForKey:@"company_name"];
        
        cell.userName.frame = CGRectMake(66.f, 10.f, 100, 30);
        cell.companyLabel.frame = CGRectMake(66.f,30, 200, 30);
        
        [cell inviteButtonIsHidden:YES];
        
        NSURL *imgUrl = [NSURL URLWithString:[[_searchResultArr objectAtIndex:indexPath.row]objectForKey:@"portrait"]];
        
        if ([[_searchResultArr[indexPath.row]objectForKey:@"sex"] intValue] == 1) {
            
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
        
        NSArray *circleArr = [_dataDict objectForKey:[_keysArr objectAtIndex:indexPath.section]];
        
        NSString *conpanyName = [[circleArr objectAtIndex:indexPath.row]objectForKey:@"company_name"];
        
        if (isHidden) {
            
            [cell inviteButtonIsHidden:YES];
            
        }else{
            [cell inviteButtonIsHidden:NO];
        }
        
        NSString *roles = [[circleArr objectAtIndex:indexPath.row]objectForKey:@"role"];
        conpanyName = [[[self.allContactArr objectAtIndex:indexPath.row] lastObject] objectForKey:@"company_name"];
        
        [cell setCellStyleShowMsg:1 company:conpanyName tips:roles];
        cell.companyLabel.text = conpanyName;
        
        NSString *nameStr = [[circleArr objectAtIndex:indexPath.row]objectForKey:@"realname"];
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
        
        NSURL *imgUrl = [NSURL URLWithString:[[circleArr objectAtIndex:indexPath.row]objectForKey:@"portrait"]];
        
        if ([[circleArr[indexPath.row]objectForKey:@"sex"] intValue] == 1) {
            
            [cell.headView setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME)];
        }else{
            [cell.headView setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
        }
        
        [cell setButtonTitleType:MemberlistTypeCircle isInvite:0];
        
        [cell.inviteBtn setTag:[[[circleArr objectAtIndex:indexPath.row]objectForKey:@"user_id"] intValue]];
        cell.inviteBtn.cellIndexPath = indexPath;
        
        [cell.inviteBtn addTarget:self action:@selector(inviteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

#pragma mark - 编辑
-(void) inviteButtonClick:(CircleCellEditButton*) sender{
    NSLog(@"编辑%d",sender.tag);
    CircleCellEditButton * editButton = (CircleCellEditButton *)sender;
    
    if (self.circleType == StableCircle) {
        CircleEditActionSheet *edtiSheet = [[CircleEditActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置头衔" otherButtonTitles:@"从圈子中删除", nil];
        [edtiSheet showInView:self.view];
        edtiSheet.cellIndexPath = editButton.cellIndexPath;
        edtiSheet.tag = CircleTag;
        
        RELEASE_SAFE(edtiSheet);
    }else{
        CircleEditActionSheet *edtiSheet = [[CircleEditActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从会话中删除", nil];
        [edtiSheet showInView:self.view];
        edtiSheet.cellIndexPath = editButton.cellIndexPath;
        edtiSheet.tag = TempCircleTag;
        
        RELEASE_SAFE(edtiSheet);
    }
}

#pragma mark - actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSIndexPath * selectIndexPath = nil;
    
    if ([actionSheet isKindOfClass:[CircleEditActionSheet class]]) {
        CircleEditActionSheet * currentSheet = (CircleEditActionSheet *)actionSheet;
        selectIndexPath = currentSheet.cellIndexPath;
        
        _selectIndexPath = [selectIndexPath copy];
    }
    
    NSLog(@"actionSheet==%d",actionSheet.tag);
    
    NSArray *orgArr = [_dataDict objectForKey:[_keysArr objectAtIndex:selectIndexPath.section]];
    
    if (actionSheet.tag == CircleTag) {
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
                
                NSDictionary * userInfoDic = [orgArr objectAtIndex:selectIndexPath.row];
                NSNumber * circleIDNum = [NSNumber numberWithLongLong:[[_circleDic objectForKey:@"circle_id"]longLongValue]];
                NSNumber * deleteMemberID = [userInfoDic objectForKey:@"user_id"];
                
                //不能删除创建者
                if ([[_circleDic objectForKey:@"creater_id"] intValue] == [deleteMemberID intValue]) {
                    [Common checkProgressHUD:@"不能删除创建者哦~" andImage:nil showInView:self.view];
                    return;
                }
                
                CircleManager *cManager = [CircleManager new];
                cManager.fatherDelegate = self;
                cManager.removeIndexPath = selectIndexPath;
                [cManager removeMemberFromCircle:circleIDNum.longLongValue andUserID:deleteMemberID.longLongValue];
            }
                break;
                
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:
            {
                //删除成员
                NSDictionary * userInfoDic = [orgArr objectAtIndex:selectIndexPath.row];
                NSNumber * circleIDNum = [NSNumber numberWithLongLong:[[_circleDic objectForKey:@"temp_circle_id"]longLongValue]];
                NSNumber * deleteMemberID = [userInfoDic objectForKey:@"user_id"];
                
                //不能删除创建者
                if ([[_circleDic objectForKey:@"creater_id"] intValue] == [deleteMemberID intValue]) {
                    [Common checkProgressHUD:@"不能删除创建者哦~" andImage:nil showInView:self.view];
                    return;
                }
                
                TemporaryCircleManager *tcManager = [TemporaryCircleManager new];
                tcManager.fatherDelegate = self;
                tcManager.removeIndexPath = selectIndexPath;
                [tcManager removeTemporaryMemberWithTempCircleID:circleIDNum.longLongValue AndMemebrID:deleteMemberID.longLongValue];
                
            }
                break;
            
            default:
                break;
        }
    }
}

#pragma mark - PXAlertDelegate
- (void)alertViews:(PXAlertView *)alertView clickedButtonAtIndex:(UIButton *)buttonIndexs{
    
    NSArray *orgArr = [_dataDict objectForKey:[_keysArr objectAtIndex:_selectIndexPath.section]];
    
    //设置头衔接口
    [self accessUpdateCircleJobService:[[[orgArr objectAtIndex:_selectIndexPath.row]objectForKey:@"user_id"] intValue]];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isHidden) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //搜索结果列表
    if (tableView == _searchCtl.searchResultsTableView) {
        
        [_searchCtl.searchBar resignFirstResponder];
        
        MemberMainViewController *memberMainView = [[MemberMainViewController  alloc] init];
        memberMainView.pushType = PushTypesButtom;
        memberMainView.userInfoDic = [_searchResultArr objectAtIndex:indexPath.row];
        memberMainView.lookId = [[[_searchResultArr objectAtIndex:indexPath.row] objectForKey:@"user_id"] intValue];
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
        
        NSArray *orgArr = [_dataDict objectForKey:[_keysArr objectAtIndex:indexPath.section]];
        
        MemberMainViewController* memberVC = [[MemberMainViewController alloc] init];
        memberVC.lookId = [[[orgArr objectAtIndex:indexPath.row] objectForKey:@"user_id"]intValue];
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

// 返回header视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 40.f)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, -5.f,KUIScreenWidth, 30.f)];
    label.backgroundColor = [UIColor clearColor];
    
    
    label.font = [UIFont systemFontOfSize:14];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    [arr addObjectsFromArray:_keysArr];
    
    if ([_searchBar.text length] <= 0) {
        
        for (int i =0; i<arr.count; i++) {
            
            label.text = [NSString stringWithFormat:@"%@",[arr objectAtIndex:section]];
            
        }
    }else{
        label.text = @"搜索结果";
    }
    [view addSubview:label];
    view.backgroundColor = [UIColor colorWithPatternImage:[[ThemeManager shareInstance] getThemeImage:@"under_bar.png"]];
    
    if (tableView == _searchCtl.searchResultsTableView) {
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
//    if ([_searchBar.text length] <= 0) {
//        
//        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
//        
//        [arr addObjectsFromArray:_keysArr];
//        
//        return arr;
//    }else{
//        return nil;
//    }
    
    //booky
    if (tableView == _searchCtl.searchResultsTableView) {
        return nil;
    }else{
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        
        [arr addObjectsFromArray:_keysArr];
        
        return arr;
        
    }
}

-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (tableView == _searchCtl.searchResultsTableView) {
        return 0;
    }
    
    UIView *letterView = [self.view viewWithTag:1000];
    UILabel *letterLabel = (UILabel *)[letterView viewWithTag:1001];
	letterView.alpha = 1.0;
	letterLabel.text = title;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	letterView.alpha = 0.0;
	[UIView commitAnimations];
    
    return index;
}

#pragma mark - UISearchBarDelegate

-(void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    UISearchBar *searchBar = _searchCtl.searchBar;
    
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _searchResultArr = [[NSMutableArray alloc]init];
    
    NSMutableArray* allContactAndCompanyArr = [NSMutableArray arrayWithCapacity:_searchResultArr.count];
    
    for (NSDictionary* dic in _memberArr) {
        NSString* str = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"realname"],[dic objectForKey:@"company_name"]];
        [allContactAndCompanyArr addObject:str];
        NSLog(@"--dic:%@--",dic);
    }
    
    if (_searchBar.text.length > 0 && ![Common isIncludeChineseInString:_searchBar.text]) {
        
        for (int i=0; i<_memberArr.count; i++) {
            
            // 判断NSString中的字符是否为中文
            if ([Common isIncludeChineseInString:allContactAndCompanyArr[i]]) {
                
                // 转换为拼音
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:allContactAndCompanyArr[i]];
                
                // 搜索是否在转换后拼音中
                NSRange titleResult=[tempPinYinStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    
                    [_searchResultArr addObject:_memberArr[i]];
                    
                }else{
                    // 转换为拼音的首字母
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:allContactAndCompanyArr[i]];
                    
                    // 搜索是否在范围中
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                    
                    if (titleHeadResult.length>0) {
                        [_searchResultArr addObject:_memberArr[i]];
                    }
                }
                
            }
            else {
                
                NSRange titleResult=[allContactAndCompanyArr[i] rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    [_searchResultArr addObject:_memberArr[i]];
                }
            }
        }
    } else if (_searchBar.text.length>0 && [Common isIncludeChineseInString:_searchBar.text]) {
        
        for (int i=0; i<_memberArr.count; i++) {
            NSString *tempStr = allContactAndCompanyArr[i];
            
            NSRange titleResult=[tempStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
            
            if (titleResult.length>0) {
                [_searchResultArr addObject:[_memberArr objectAtIndex:i]];
            }
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    if ([_searchResultArr count] == 0) {
        
        UITableView *tableView1 = _searchCtl.searchResultsTableView;
        
        for( UIView *subview in tableView1.subviews ) {
            
            if([subview isKindOfClass:[UILabel class]]) {
                
                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                
                lbl.text = [NSString stringWithFormat:@"没有找到\"%@\"相关的联系人",_searchBar.text];
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
    //做整体刷新  booky   删除单行可能会使得key还保留
//    [self getCircleMemberListData];
//    [_tableview reloadData];
    
    int section = _selectIndexPath.section;
    
    NSArray* arr = [_dataDict objectForKey:_keysArr[section]];
  
    if (arr.count == 1) {
        [_dataDict removeObjectForKey:_keysArr[section]];
        [_keysArr removeObjectAtIndex:section];
        [_tableview deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        //删除数据源
        NSMutableArray * members = [[_dataDict objectForKey:_keysArr[section]] mutableCopy];
        [members removeObjectAtIndex:_selectIndexPath.row];
        [_dataDict removeObjectForKey:_keysArr[section]];
        [_dataDict setObject:members forKey:_keysArr[section]];
        
        [_tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:_selectIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    RELEASE_SAFE(sender);

    //刷新列表，重置indexPath，否则会出现混乱
    [_tableview reloadData];

}

-(void) addMemberSuccessWithSender:(id)sender CircleID:(long long)circleID{
    
}

#pragma mark - tempCircleDetailDelegate
-(void) addMemberReload{
    [_memberArr removeAllObjects];
    
    NSArray* circleMembersArr = [temporary_circle_member_list_model getAllMemberFormTempCircle:self.circleId];
    _circleDic = [[temporary_circle_list_model getTemporaryCircleListWithTempCircleID:self.circleId]retain];
    
    // 根据数据首字母排列数据
    _dataDict = [[YLDataObj accordingFirstLetterGetTips:circleMembersArr] mutableCopy];
    _keysArr = [[[_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
    // 获取所有名字
    for (int i =0; i<_keysArr.count; i++) {
        [_memberArr addObjectsFromArray:[_dataDict objectForKey:[_keysArr objectAtIndex:i]]];
    }
    
    [_tableview reloadData];
}

#pragma mark - access
//圈子成员头衔修改
- (void)accessUpdateCircleJobService:(int)userId{
    
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:userId],@"user_id",
                                        [NSNumber numberWithInt:[[_circleDic objectForKey:@"circle_id"] intValue]],@"circle_id",
                                        self.msgTextField.text,@"role",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:CIRCLE_MEMBER_DUTY_COMMAND_ID accessAdress:@"circle/updateusertitle.do?param=" delegate:self withParam:nil];
}

//网络请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    ParseMethod safeParseMethod = ^(){
        switch (commandid) {
            case CIRCLE_MEMBER_DUTY_COMMAND_ID:
            {
                int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
                
                if (resultInt == 0) {
                    [self performSelectorOnMainThread:@selector(setTitleError) withObject:nil waitUntilDone:NO];
                    
                }
                else if(resultInt == 1){
                    
                    [self performSelectorOnMainThread:@selector(setTitleSuccess) withObject:nil waitUntilDone:NO];
                }
                
            }
                break;
            default:
                break;
        }
    };
    [Common securelyparseHttpResultArr:resultArray andMethod:safeParseMethod];
}

//设置头衔失败
- (void)setTitleError{
//    [Common checkProgressHUD:@"修改失败" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"修改失败" andImage:KAccessFailedIMG];
}

//设置头衔成功
- (void)setTitleSuccess{
    NSArray *orgArr = [_dataDict objectForKey:[_keysArr objectAtIndex:_selectIndexPath.section]];
    
    //设置头衔接口
    NSNumber* user_id = [[orgArr objectAtIndex:_selectIndexPath.row]objectForKey:@"user_id"];
    //修改数据库
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         user_id,@"user_id",
                         [NSNumber numberWithInt:[[_circleDic objectForKey:@"circle_id"] intValue]],@"circle_id",
                         self.msgTextField.text,@"role", nil];
    [circle_member_list_model insertOrUpdateDictionaryIntoCirlceMemberList:dic];
    
    personalCell* cell = (personalCell*)[_tableview cellForRowAtIndexPath:_selectIndexPath];
    cell.positionLabel.text = self.msgTextField.text;
    
//    [Common checkProgressHUD:@"修改成功" andImage:IMGREADFILE(@"btn_feed_smiley.png") showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"修改成功" andImage:KAccessSuccessIMG];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    LOG_RELESE_SELF;
    [_msgTextField release];
    RELEASE_SAFE(_circleDic);
    
    [_dataDict release];
    [_keysArr release];
    [_tableview release];
    [_searchBar release];
    [_searchCtl release];
    [_memberArr release];
    [_searchResultArr release];
    [super dealloc];
}

@end
