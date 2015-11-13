//
//  MessageListViewController.h
//  ql
//
//  Created by yunlai on 14-2-26.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "HttpRequest.h"
#import "choicelinkmanViewController.h"
#import "TemporaryCircleManager.h"
@interface MessageListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HttpRequestDelegate,choiceLMDelegate,TemporaryCircleManagerDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
{
    UITableView *_mainTableView;
    MessageListType msgType;
    NSMutableArray * _messageList;
    NSMutableArray * _organizeList;
    
    UISearchDisplayController *_searchCtl;
    
    NSMutableArray *_searchResults;     // 搜索出的数据
}
@property(nonatomic, assign) MessageListType msgType;
@property(nonatomic, retain) NSMutableArray * messageList;
@property(nonatomic, assign) BOOL isTouchCell;
@property (nonatomic , retain) UISearchBar *searchBar;
@property (nonatomic , retain) UISearchDisplayController *searchCtl;

@end
