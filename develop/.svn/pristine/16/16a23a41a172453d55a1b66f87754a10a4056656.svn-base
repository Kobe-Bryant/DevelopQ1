//
//  RecentContactsViewController.h
//  ql
//
//  Created by yunlai on 14-3-8.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentContactsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

{
    UITableView *_listTableView;
    
    UISearchBar *_searchBar;
    
    UISearchDisplayController *_searchDisplayCtl;
    
    CGFloat CtlHeight;
    
    NSMutableArray *_dataArray; //所有联系人数据
    NSMutableArray *_searchResults;// 搜索出的数据
}
@property (nonatomic , retain) UISearchBar *searchBar;
@property (nonatomic , retain) UISearchDisplayController *searchDisplayCtl;
@end
