//
//  YLNameCardViewController.h
//  CardHolderDemo
//
//  Created by yunlai on 14-1-15.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLNameCardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UITableView *_mainView;
    NSArray *keyArr;
    NSMutableDictionary *dataDict;
    UISearchBar *searchBar;
    UIView *coverView;
    BOOL isCheck;
    NSIndexPath *indexP;
    NSMutableArray *checkIndexArr;
    
    UIScrollView *_addScrollView;
    UIButton *_confirmBtn;
    UILabel *_numLabel;
    NSMutableArray *_checkDataArry;
    
    NSMutableArray *_searchResults;
    UISearchDisplayController *_searchCtl;
    
}
@property (nonatomic, assign) int listType; //1是名片夹，2是联系人选择列表
@property (nonatomic, retain) NSArray *keyArr;
@property (nonatomic, retain) NSMutableDictionary *dataDict;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *nameArray;
@property (nonatomic, retain) NSMutableDictionary *contactDic;
@property (nonatomic, retain) UITableView *mainView;
@property (nonatomic, retain) NSIndexPath *indexP;
@property (nonatomic, retain) UISearchDisplayController *searchCtl;

@end
