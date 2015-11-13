//
//  LikesMainPageViewController.h
//  ql
//
//  Created by yunlai on 14-2-27.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequest.h"
#import "LoadMoreTableFooterView.h"
#import "commentView.h"

@interface LikesMainPageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,HttpRequestDelegate,LoadMoreTableFooterDelegate,UIScrollViewDelegate,commentDelegate>
{
//    赞列表
    UITableView *_likeTableView;
//    加载更多
    LoadMoreTableFooterView *_footMoreLoadView;
}
//？
@property (nonatomic , assign) BOOL isClick;

@end
