//
//  AddressListViewController.m
//  ql
//
//  Created by yunlai on 14-3-8.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "AddressListViewController.h"
#import "SidebarViewController.h"
#import "RecentContactsViewController.h"
#import "CircleMainViewController.h"
#import "OrganizeViewController.h"
#import "CreateCircleViewController.h"
#import "CircleMainViewController.h"
#import "AllContactsViewController.h"
#import "addresslistCell.h"
#import "PinYinForObjc.h"
#import "Common.h"

@interface AddressListViewController ()
{
    UITableView *_listTableView;
    
    UISearchBar *_searchBar;
    
    UISearchDisplayController *_searchDisplayController;
    
    CGFloat CtlHeight;
    
    NSMutableArray *_dataArray; //所有联系人数据
    NSMutableArray *_searchResults;// 搜索出的数据
}
@property (nonatomic , retain) UISearchBar *searchBar;
@property (nonatomic , retain) UISearchDisplayController *searchDisplayController;
@end

@implementation AddressListViewController
@synthesize searchBar = _searchBar;
@synthesize searchDisplayController = _searchDisplayController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
        self.title = @"通讯录";
        CtlHeight = 0.f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航栏按钮添加
    [self initNavigationBarBtn];
    
    //主视图表格
    [self mainLoadView];
    
    //搜索框实例化
    [self searchBarInit];
    
    _dataArray = [@[@"百度",@"六六",@"谷歌",@"苹果",@"and",@"table",@"view",@"and",@"and",@"苹果IOS",@"谷歌android",@"微软",@"微软WP",@"table",@"table",@"table",@"六六",@"六六",@"六六",@"table",@"table",@"table"]mutableCopy];
}

/**
 *  搜索框
 */
- (void)searchBarInit {
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.frame = CGRectMake(0.0f, 0.f, KUIScreenWidth, 48.0f);
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
    _searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.active = NO;
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
    _searchDisplayController.delegate = self;
    _searchDisplayController.searchResultsTableView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
}

/**
 *  // 主视图
 */
- (void)mainLoadView{
    
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, CtlHeight, KUIScreenWidth, KUIScreenHeight) style:UITableViewStylePlain];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_listTableView];
}


/**
 *  实例化导航栏按钮
 */
- (void)initNavigationBarBtn{
    
    //返回按钮
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundColor:[UIColor clearColor]];
    
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[UIImage alloc ]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QRPositionRound" ofType:@"png"]];
    
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(20 , 30, 30.f, 30.f)];
    
    RELEASE_SAFE(image);
    
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

- (void)dealloc
{
    RELEASE_SAFE(_listTableView);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _searchResults.count;
    }
    else {
        return 4;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 50.f;
    }else{
        return 70.f;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //搜索结果列表
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        static NSString *searchCell = @"searchCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
        
        if (nil == cell) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCell]autorelease];
           
            cell.backgroundColor = [UIColor clearColor];
        }

        cell.textLabel.text = _searchResults[indexPath.row];
        
        return cell;
        
    }else{
    //主界面列表
        static NSString *listCell = @"listCell";
        
        addresslistCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
        
        if (nil == cell) {
            cell = [[[addresslistCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listCell]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.iconView.image = [UIImage imageNamed:@"googleplus@2x"];
        switch (indexPath.row) {
            case 0:
            {
                [cell.listName setText:@"最近联系人"];
            }
                break;
                
            case 1:
            {
                [cell.listName setText:@"全部联系人"];
            }
                break;
            case 2:
            {
                [cell.listName setText:@"长江商学院"];
            }
                break;
            case 3:
            {
                [cell.listName setText:@"圈子"];
            }
                break;
                
            default:
                break;
        }
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:// 最近联系人
        {
            RecentContactsViewController *recentCtl = [[RecentContactsViewController alloc]init];
            [self.navigationController pushViewController:recentCtl animated:YES];
            RELEASE_SAFE(recentCtl);
        }
            break;
            
        case 1:// 全部联系人
        {
            AllContactsViewController *contactsCtl = [[AllContactsViewController alloc]init];
            [self.navigationController pushViewController:contactsCtl animated:YES];
            RELEASE_SAFE(contactsCtl);
            
        }
            break;
        case 2:// 长江商学院
        {
            OrganizeViewController *circleCtl = [[OrganizeViewController alloc]init];
            [self.navigationController pushViewController:circleCtl animated:YES];
            RELEASE_SAFE(circleCtl);
        }
            break;
        case 3:// 圈子
        {
            CircleMainViewController *circle = [[CircleMainViewController alloc]init];
            [self.navigationController pushViewController:circle animated:YES];
            RELEASE_SAFE(circle);
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UISearchBarDelegate

-(void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
//    if (IOS_VERSION_7) {
//        controller.searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    }
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    UISearchBar *searchBar = self.searchDisplayController.searchBar;
    
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
    
    if (self.searchBar.text.length > 0 && ![Common isIncludeChineseInString:self.searchBar.text]) {
        
        for (int i=0; i<_dataArray.count; i++) {
            
            if ([Common isIncludeChineseInString:_dataArray[i]]) {
                
                // 判断NSString中的字符是否为中文
                if ([Common isIncludeChineseInString:_dataArray[i]]) {
                    
                    // 转换为拼音
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:_dataArray[i]];
                    
                    // 搜索是否在转换后拼音中
                    NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    
                    if (titleResult.length>0) {
                        
                        [_searchResults addObject:_dataArray[i]];
                        
                    }
                    
                    // 转换为拼音的首字母
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:_dataArray[i]];
                    
                    // 搜索是否在范围中
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    
                    if (titleHeadResult.length>0) {
                        [_searchResults addObject:_dataArray[i]];
                    }
                
            }
            else {
                
                NSRange titleResult=[_dataArray[i] rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    [_searchResults addObject:_dataArray[i]];
                }
            }
            }
        }
    } else if (self.searchBar.text.length>0&&[Common isIncludeChineseInString:self.searchBar.text]) {
        
        for (NSString *tempStr in _dataArray) {
            
            NSRange titleResult=[tempStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            
            if (titleResult.length>0) {
                [_searchResults addObject:tempStr];
            }
            
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
//    [self filterContentForSearchText:searchString];
    
    if ([_searchResults count] == 0) {
        
        UITableView *tableView1 = self.searchDisplayController.searchResultsTableView;
        
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
