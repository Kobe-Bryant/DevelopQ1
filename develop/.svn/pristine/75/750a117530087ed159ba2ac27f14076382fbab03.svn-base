//
//  OrganizationMemberList.m
//  ql
//
//  Created by yunlai on 14-7-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "OrganizationMemberList.h"
#import "personalCell.h"

#import "YLDataObj.h"
#import "PinYinForObjc.h"
#import "UIImageView+WebCache.h"

#import "MemberMainViewController.h"
#import "CRNavigationController.h"

#import "org_member_list_model.h"

#import "CircleCellEditButton.h"
@interface OrganizationMemberList (){
    NSIndexPath* _selectIndexPath;
    #import "CircleCellEditButton.h"
    CircleCellEditButton *editButton;
//    区分改变邀请按钮状态时是否是搜索列表
    BOOL isSearch;
}

@end

@implementation OrganizationMemberList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _memberArr = [[NSMutableArray alloc] init];
        _haveHonorArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = _orgName;
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
	// Do any additional setup after loading the view.
//    获取组织成员数据
    [self getOrgMemberListData];
//    加载主页面
    [self mainViewList];
//    加载搜索框
    [self searchBarInit];
    
    if (![_keysArr count]) {
        UILabel *lable = [[UILabel alloc]init];
        lable.text = [NSString stringWithFormat:@"“%@”暂无成员",_orgName];
        CGSize lableSize = [lable.text sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(MAXFLOAT,30)];
        lable.frame = CGRectMake((KUIScreenWidth - lableSize.width)/2, self.view.frame.size.height/2 - 50, lableSize.width + 5, 30);
        lable.backgroundColor = [UIColor clearColor];
        [self.view addSubview:lable];
        [lable release];
    } else {
        NSLog(@"------");
    }
    
}

//获取组织列表数据
-(void) getOrgMemberListData{
    [_haveHonorArr removeAllObjects];
    [_memberArr removeAllObjects];
    
    //取出有头衔的成员
    NSArray* haveHonorMemberArr = [org_member_list_model getHaveHonorMember:_orgId];
    [_haveHonorArr addObjectsFromArray:haveHonorMemberArr];
    
    //取出没有头衔的成员
    NSArray* noHonorMemberArr = [org_member_list_model getNoHonorMember:_orgId];
    
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
        
        NSString *conpanyName;
        
        //组织列表数据
        int isMsg = [[_searchResultArr[indexPath.row]objectForKey:@"is_supply"]intValue];
        conpanyName = [_searchResultArr[indexPath.row]objectForKey:@"company_name"];
        NSString *honor = [_searchResultArr[indexPath.row]objectForKey:@"honor"];
        //激活状态
        int activateStatus = [[_searchResultArr[indexPath.row]objectForKey:@"status"]intValue];
        //邀请状态
        int inviteStatus = [[_searchResultArr[indexPath.row] objectForKey:@"invite_status"] intValue];
        
        [cell setCellStyleShowMsg:isMsg company:conpanyName tips:honor];
        
        [cell inviteButtonIsHidden:activateStatus];
        if (activateStatus) {
            
        }else{
            [cell setButtonTitleType:MemberlistTypeOrg isInvite:inviteStatus];
        }
        
        cell.companyLabel.text = conpanyName;
        
        //        公司名字的字体的颜色的变化 add vincent
        if ([conpanyName rangeOfString:_searchBar.text].location != NSNotFound) {
            NSRange rang1 = [conpanyName rangeOfString:_searchBar.text];
            NSMutableAttributedString  *numStr = [[NSMutableAttributedString alloc] initWithString:conpanyName];
            [numStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:rang1];
            cell.companyLabel.attributedText = numStr;
        }
        
        NSString *nameStr = [_searchResultArr[indexPath.row]objectForKey:@"realname"];
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
        
        //姓名字体的变化 add vincent
        if ([nameStr rangeOfString:_searchBar.text].location != NSNotFound) {
            NSRange rang1 = [nameStr rangeOfString:_searchBar.text];
            NSMutableAttributedString  *numStr = [[NSMutableAttributedString alloc] initWithString:nameStr];
            [numStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:rang1];
            cell.userName.attributedText = numStr;
        }
        
        NSURL *imgUrl = [NSURL URLWithString:[_searchResultArr[indexPath.row]objectForKey:@"portrait"]];
        
        if ([[_searchResultArr[indexPath.row]objectForKey:@"sex"] intValue] == 1) {
            
            [cell.headView setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME)];
        }else{
            [cell.headView setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
        }
        
        [cell.inviteBtn setTag:[[_searchResultArr[indexPath.row]objectForKey:@"user_id"] intValue]];
        cell.inviteBtn.cellIndexPath = indexPath;
        
        [cell.inviteBtn addTarget:self action:@selector(inviteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }else{
        
        static NSString *GroupCell = @"GroupCell";
        
        personalCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupCell];
        
        if (cell == nil) {
            cell = [[[personalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupCell]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
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
        
        NSLog(@"[orgArr[indexPath.row]objectForKey intValue] %d",[[orgArr[indexPath.row]objectForKey:@"sex"] intValue]);
        
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
}

#pragma mark - inviteButtonClick
-(void) inviteButtonClick:(CircleCellEditButton*) sender{
    editButton = sender;
    _selectIndexPath = sender.cellIndexPath;
    
    NSString *nameString = nil;
    //booky 9.5 分开搜索，分别取数据呀
    if (isSearch) {
        nameString = [[_searchResultArr objectAtIndex:_selectIndexPath.row] objectForKey:@"realname"];
    }else{
        NSArray *orgArr = [_dataDict objectForKey:[_keysArr objectAtIndex:_selectIndexPath.section]];
        nameString = [[orgArr objectAtIndex:_selectIndexPath.row]objectForKey:@"realname"];
    }
    
//    add vincent
//    NSArray *orgArr = [_dataDict objectForKey:[_keysArr objectAtIndex:_selectIndexPath.section]];
//    NSString *nameString = [[orgArr objectAtIndex:_selectIndexPath.row]objectForKey:@"realname"];
    
    //    @"系统将发送一条短信邀请xx加入云圈，请确认是否发送"
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"邀请加入云圈" message:[NSString stringWithFormat:@"系统将发送一条短信邀请%@加入云圈，请确认是否发送。",nameString] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 10000;
    [alertView show];
    [alertView release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //搜索结果列表
    if (tableView == _searchCtl.searchResultsTableView) {
        
        [_searchCtl.searchBar resignFirstResponder];
        
        MemberMainViewController *memberMainView = [[MemberMainViewController  alloc] init];
        memberMainView.pushType = PushTypesButtom;
        memberMainView.accessType = AccessTypeSearchLook;
        memberMainView.userInfoDic = [_searchResultArr objectAtIndex:indexPath.row];
        memberMainView.lookId = [[[_searchResultArr objectAtIndex:indexPath.row] objectForKey:@"user_id"] intValue];
        
        CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberMainView];
        [self.navigationController presentModalViewController:nav animated:YES];
        RELEASE_SAFE(nav);
        RELEASE_SAFE(memberMainView);
    }else{
        
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
    
    if ([title isEqualToString:@""]) {
        return index;
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
    isSearch = NO;
//    刷新成员列表  同步邀请状态
    [self getOrgMemberListData];
    [_tableview reloadData];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    isSearch = YES;
    
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

//搜索出名字和公司名里面保存关键字的成员
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

//邀请开通加入
- (void)accessInviteService:(int) inviteeId{
    
    OrgManager* orgM = [[OrgManager alloc] init];
    orgM.delegate = self;
    [orgM inviteOrgMemberWithMemberID:(long long)inviteeId orgId:self.orgId];
}

#pragma mark - orgManagerDelegate
//邀请成功回调
-(void) inviteOrgMemberSuccess:(OrgManager *)sender
{
    [self inviteSuccess];
    RELEASE_SAFE(sender);
}

//网络请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
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
            
            default:
                break;
        }
    };
    [Common securelyparseHttpResultArr:resultArray andMethod:safeParseMethod];
}

//邀请失败
- (void)inviteError{
//    [Common checkProgressHUD:@"邀请失败" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"邀请失败" andImage:KAccessFailedIMG];
}

//邀请成功 改变按钮状态
- (void)inviteSuccess{
    personalCell* cell = nil;
    
    //改变按钮状态
    if (isSearch) {
        cell = (personalCell*)[_searchCtl.searchResultsTableView cellForRowAtIndexPath:_selectIndexPath];
    }else{
        cell = (personalCell*)[_tableview cellForRowAtIndexPath:_selectIndexPath];
    }
    
    [cell setButtonTitleType:MemberlistTypeOrg isInvite:1];
    
//    [Common checkProgressHUD:@"已发送邀请" andImage:IMGREADFILE(@"btn_feed_smiley.png") showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"已发送邀请" andImage:KAccessSuccessIMG];
}

//已邀请
- (void)notInvite{
    personalCell* cell = nil;
    
    //改变按钮状态
    if (isSearch) {
        cell = (personalCell*)[_searchCtl.searchResultsTableView cellForRowAtIndexPath:_selectIndexPath];
    }else{
        cell = (personalCell*)[_tableview cellForRowAtIndexPath:_selectIndexPath];
    }
    
    //改变按钮状态
//    personalCell* cell = (personalCell*)[_tableview cellForRowAtIndexPath:_selectIndexPath];
    [cell setButtonTitleType:MemberlistTypeOrg isInvite:1];
    
//    [Common checkProgressHUD:@"已经邀请过了" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"已经邀请过了" andImage:KAccessFailedIMG];
}

#pragma mark - alertviewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10000) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self accessInviteService:editButton.tag];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [_keysArr release];
    [_haveHonorArr release];
    [_dataDict release];
    [_tableview release];
    [_searchBar release];
    [_searchCtl release];
    [_memberArr release];
    [_searchResultArr release];
    [super dealloc];
}

@end
