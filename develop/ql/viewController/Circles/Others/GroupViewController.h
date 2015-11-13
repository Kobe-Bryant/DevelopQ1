//
//  GroupViewController.h
//  ql
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "HttpRequest.h"
#import "PXAlertView.h"
#import "MBProgressHUD.h"
#import "CircleManager.h"

@interface GroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIActionSheetDelegate,PXAlertDelegate,FatherCircleManagerDelegate>
{
    UITableView *_groupTableView;
    
    NSMutableArray *_memberArray;
    
    NSMutableArray *_searchResults;     // 搜索出的数据
}
@property (nonatomic , retain) UISearchBar *searchBar;
@property (nonatomic , retain) UISearchDisplayController *searchCtl;
@property (nonatomic , retain) NSArray *keyArr;
@property (nonatomic , retain) NSMutableDictionary *dataDict;
@property (nonatomic , assign) MemberlistType listType;
@property (nonatomic , retain) NSString *orgName;
@property (nonatomic , retain) NSString *orgIntro;
@property (nonatomic , retain) NSString *createrName;
@property (nonatomic , retain) NSDictionary *circleDic;
@property (nonatomic , retain) NSArray *circleArr;
@property (nonatomic , assign) int orgId;
@property (nonatomic , assign) int circleId;
@property (nonatomic , assign) listEditType editType;

//如果时从圈子详情进来的，则不显示详情按钮
@property(nonatomic,assign) BOOL enterFromDetail;

@end
