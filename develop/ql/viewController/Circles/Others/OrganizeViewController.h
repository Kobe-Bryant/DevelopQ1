//
//  OrganizeViewController.h
//  ql
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgMainCell.h"

@class CircleMainViewController;

@interface OrganizeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,OrgMainCellDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UITableView *_mainTableView;
    NSMutableArray *_officialArray;     // 官方组织
    NSMutableArray *_orgArray;          // 哪一届组织
    UISearchDisplayController *_searchCtl;
    NSMutableArray *_searchResults;     // 搜索出的数据
}
@property (nonatomic, retain) UITableView *mainTableView;
@property (nonatomic , retain) UISearchBar *searchBar;
@property (nonatomic , retain) UISearchDisplayController *searchCtl;

@end
