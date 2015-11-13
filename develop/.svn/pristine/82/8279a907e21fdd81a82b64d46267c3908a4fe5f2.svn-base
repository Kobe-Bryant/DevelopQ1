//
//  choicelinkmanViewController.h
//  ql
//
//  Created by yunlai on 14-4-3.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol choiceLMDelegate <NSObject>

@optional
//制定成员确定
-(void) sureLMClick:(NSArray*) selectLMs;
//取消
-(void) cancelLMClick;

//5.8chenfeng add   圈子添加成员
- (void)sureAddMember:(NSArray *)selectMember;

@end

@interface choicelinkmanViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    UITableView* _tableview;
    UISearchBar* _searchBar;
    UISearchDisplayController* _searchCtl;
    
    NSMutableArray* _memberArr;
    NSMutableArray* _searchResultArr;
    //搜索框中已选的indexPaths组
    NSMutableArray* _searchSelectIndexPaths;
}

@property (nonatomic,assign) id<choiceLMDelegate> delegate;
@property (nonatomic, assign) BOOL isStartChat;
//5.8chenfeng add 访问页面方式
@property(nonatomic,assign) AccessPageType accessType;

//已邀请的人员,添加成员时用到
@property(nonatomic,retain) NSArray* invitedArr;

@end
