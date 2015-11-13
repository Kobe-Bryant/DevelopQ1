//
//  OrganizeViewController.m
//  ql
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "OrganizeViewController.h"
#import "GroupViewController.h"
#import "OrgMainTopCell.h"
#import "OrgMainCell.h"
#import "Common.h"
#import "PinYinForObjc.h"

@interface OrganizeViewController ()
{
    NSMutableArray *_dataList;
}

@end

@implementation OrganizeViewController

@synthesize mainTableView = _mainTableView;
@synthesize searchBar = _searchBar;
@synthesize searchCtl = _searchCtl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"成员";
    
    [self readPlistData];
    
    [self mainViewList];
    
    _officialArray = [[NSMutableArray alloc]initWithObjects:@"校委会", nil];
    
    _orgArray = [[NSMutableArray alloc]initWithObjects:@"总裁一班",@"总裁二班", nil];
    
}


/**
 *  主界面
 */

- (void)mainViewList{
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, KUIScreenWidth, KUIScreenHeight) style:UITableViewStylePlain];
    
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainTableView];
 
    // 返回按钮
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [[UIImage alloc ]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return" ofType:@"png"]];
    [backButton setImage:image forState:UIControlStateNormal];
    
    backButton.frame = CGRectMake(20 , 30, 30.f, 30.f);
    RELEASE_SAFE(image);
    
    [self.view addSubview:backButton];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

/**
 *  返回按钮
 */
- (void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)readPlistData{
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"ExpansionTableTestData" ofType:@"plist"];
    _dataList = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSLog(@"%@",path);
    
}

/**
 *  组织图标点击事件
 *
 *  @param sender 点击的按钮
 */
- (void)selectButtonIndex:(UIButton *)sender{
    
    NSLog(@"sender====%d",sender.tag);
    GroupViewController *groupCtl = [[GroupViewController alloc]init];
    groupCtl.listType = MemberlistTypeOrg;
    [self.navigationController pushViewController:groupCtl animated:YES];
    RELEASE_SAFE(groupCtl);
    
}

- (void)dealloc
{
    RELEASE_SAFE(_mainTableView);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.searchBar resignFirstResponder];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 200.f;
        }
            break;
        case 1:
        {
            return 150 * ((int)(_officialArray.count / 2) + 1);
        }
            break;
        case 2:
        {
            return 150 * ((int)(_orgArray.count / 2) + 1);
        }
            break;
        default:
            break;
    }
    return 150.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 35.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    // 添加自定义section视图
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 30.f)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    // 分割线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 20.f, KUIScreenWidth, 1)];
    line.backgroundColor = RGBACOLOR(213, 216, 225, 1);
    [bgView addSubview:line];
    
    // 提示语
    UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(110.f, 10.f, 100.f, 20.f)];
//    tips.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY"];
    tips.textColor = COLOR_GRAY;
    tips.font = KQLSystemFont(13);
    tips.backgroundColor = [UIColor whiteColor];
    tips.textAlignment = NSTextAlignmentCenter;
    
    [bgView addSubview:line];
    [bgView addSubview:tips];
    
    if (section == 1) {
        tips.text = @"官方组织";
    }else if(section == 2){
        tips.text = @"2013届";
    }
    
    RELEASE_SAFE(line);
    RELEASE_SAFE(tips);
    
    return [bgView autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *topCell = @"topCell";
            
            OrgMainTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topCell];
            
            if (nil == cell) {
                
                cell = [[[OrgMainTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCell]autorelease];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.iconImage.image = [UIImage imageNamed:@"15.jpg"];
            cell.orgName.text = @"长江商学院";
            
            if (_searchBar == nil) {
                _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
                _searchBar.frame = CGRectMake(5.0f, CGRectGetMaxY(cell.orgName.frame) - 5, KUIScreenWidth - 10, 40.0f);
                _searchBar.backgroundColor = [UIColor clearColor];
                _searchBar.searchBarStyle = UISearchBarStyleMinimal;
                _searchBar.placeholder=@"搜索";
                _searchBar.delegate = self;
            }
            
            
            
            // 去除搜索框背景
            for (UIView *subview in _searchBar.subviews)
            {
                if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
                {
                    [subview removeFromSuperview];
                    break;  
                }
            }
            if ([_searchBar respondsToSelector: @selector (barTintColor)]) {
                
                [_searchBar setBarTintColor:[UIColor clearColor]];

            }
            
            [cell.contentView addSubview:_searchBar];
            
            return cell;
        }
            break;
        case 1:
        {
            static NSString *mainCell = @"mainCell";
            
            OrgMainCell *perCell = [tableView dequeueReusableCellWithIdentifier:mainCell];
            
            if (nil == perCell) {
                
                perCell = [[[OrgMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainCell]autorelease];
                perCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            perCell.backgroundColor = [UIColor clearColor];
            perCell.delegate = self;
            
            [perCell setOrgLayout:_officialArray];
            
            return perCell;
        }
            break;
        case 2:
        {
            static NSString *orgCell = @"orgCell";
            
            OrgMainCell *cell = [tableView dequeueReusableCellWithIdentifier:orgCell];
            
            if (nil == cell) {
                
                cell = [[[OrgMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orgCell]autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.backgroundColor = [UIColor clearColor];
            
            [cell setOrgLayout:_orgArray];
            
            cell.delegate = self;
            
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
}

-(void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    if (IOS_VERSION_7) {
        controller.searchBar.barTintColor = [UIColor clearColor];
    }
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    UISearchBar *searchBar = self.searchCtl.searchBar;
    
    if (IOS_VERSION_7) {
        searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"];
    }
    
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
    
    if (self.searchBar.text.length > 0 && ![Common isIncludeChineseInString:self.searchBar.text]) {
        
        for (int i=0; i<_dataList.count; i++) {
            
            // 判断NSString中的字符是否为中文
            if ([Common isIncludeChineseInString:_dataList[i]]) {
                
                // 转换为拼音
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:_dataList[i]];
                
                // 搜索是否在转换后拼音中
                NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    
                    [_searchResults addObject:_dataList[i]];
                    
                }
                
                // 转换为拼音的首字母
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:_dataList[i]];
                
                // 搜索是否在范围中
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleHeadResult.length>0) {
                    [_searchResults addObject:_dataList[i]];
                }
                
            }
            else {
                
                NSRange titleResult=[_dataList[i] rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    [_searchResults addObject:_dataList[i]];
                }
            }
        }
    } else if (self.searchBar.text.length>0&&[Common isIncludeChineseInString:self.searchBar.text]) {
        
        for (NSString *tempStr in _dataList) {
            
            NSRange titleResult=[tempStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            
            if (titleResult.length>0) {
                [_searchResults addObject:tempStr];
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
                
                lbl.text = @"没有你要搜索的结果";
                
            }
        }
    }
    // Return YES to cause the search result table view to be reloaded.
    return YES;
    
}
    
@end
