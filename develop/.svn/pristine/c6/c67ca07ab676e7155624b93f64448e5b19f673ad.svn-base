//
//  CircleMainViewController.h
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizeViewController.h"
#import "GroupViewController.h"
#import "circleMainPageCell.h"
#import "CreateCircleViewController.h"

typedef enum{
    kBackStyleNormal,
    kBackStyleMessage,
}kBackStyle;

@interface CircleMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,createCircleDelegate>

{
    UITableView *_listTableView;
    
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchCtl;
    
    CGFloat CtlHeight;
    
    NSArray *_orgArray;    // 组织
    NSArray *_circleArry;  // 圈子
    NSMutableArray *_searchResults;     // 搜索出的数据
}

@property (nonatomic , retain) UISearchBar *searchBar;
@property (nonatomic , retain) UISearchDisplayController *searchCtl;
@property (nonatomic , retain) NSArray *orgArray;
@property (nonatomic , retain) NSArray *circleArry;
@property (nonatomic , assign) kBackStyle backStyle;

@end
