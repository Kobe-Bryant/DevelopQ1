//
//  RecentContactsViewController.m
//  ql
//
//  Created by yunlai on 14-3-8.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "RecentContactsViewController.h"
#import "guestCell.h"
#import "PinYinForObjc.h"
#import "Common.h"

@interface RecentContactsViewController ()

@end

@implementation RecentContactsViewController

@synthesize searchBar = _searchBar;
@synthesize searchDisplayCtl = _searchDisplayCtl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
        self.title = @"最近联系人";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self mainLoadView];
    
    [self searchBarInit];
    
     _dataArray = [@[@"百度",@"六六",@"谷歌",@"苹果",@"and",@"table",@"view",@"and",@"and",@"苹果IOS",@"谷歌android",@"微软",@"微软WP",@"table",@"table",@"table",@"六六",@"六六",@"六六",@"table",@"table",@"table"]mutableCopy];
    
}

/**
 *  搜索框
 */
- (void)searchBarInit {
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.frame = CGRectMake(0.0f, 0.f, KUIScreenWidth, 44.0f);
	_searchBar.keyboardType = UIKeyboardTypeDefault;
	_searchBar.backgroundColor=[UIColor clearColor];
	_searchBar.translucent=YES;
	_searchBar.placeholder=@"搜索";
	_searchBar.delegate = self;

//    if (IOS_VERSION_7) {
//        _searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    }
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KUIScreenWidth, 44.f)];
    _listTableView.tableHeaderView = headView;
    [headView addSubview:_searchBar];
    RELEASE_SAFE(headView);
    
    //搜索控制器
    _searchDisplayCtl = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayCtl.active = NO;
    _searchDisplayCtl.searchResultsDataSource = self;
    _searchDisplayCtl.searchResultsDelegate = self;
    _searchDisplayCtl.delegate = self;
    _searchDisplayCtl.searchResultsTableView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
}

/**
 *  // 主视图列表
 */
- (void)mainLoadView{
    
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight) style:UITableViewStylePlain];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    _listTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_listTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayCtl.searchResultsTableView) {
        return _searchResults.count;
    }
    else {
        return _dataArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //搜索结果列表
    if (tableView == self.searchDisplayCtl.searchResultsTableView) {
        
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
        
        guestCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
        
        if (nil == cell) {
            cell = [[[guestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listCell]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell.headView.image = [UIImage imageNamed:@"14.jpg"];
        cell.userName.text = [_dataArray objectAtIndex:indexPath.row];
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - UISearchBarDelegate

-(void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
//    if (IOS_VERSION_7) {
//        controller.searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    }
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    UISearchBar *searchBar = self.searchDisplayCtl.searchBar;
    
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
    
    if ([_searchResults count] == 0) {
        
        UITableView *tableView1 = self.searchDisplayCtl.searchResultsTableView;
        
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
