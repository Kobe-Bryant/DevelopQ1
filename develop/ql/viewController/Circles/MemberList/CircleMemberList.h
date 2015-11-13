//
//  CircleMemberList.h
//  ql
//
//  Created by yunlai on 14-7-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "CircleEditActionSheet.h"
#import "PXAlertView.h"

typedef enum{
    StableCircle,
    TemporaryCircle
}CirCleType;

@interface CircleMemberList : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,UIActionSheetDelegate,PXAlertDelegate>{
    UITableView* _tableview;
    UISearchBar* _searchBar;
    UISearchDisplayController* _searchCtl;
//    成员组
    NSMutableArray* _memberArr;
    //keys
    NSMutableArray* _keysArr;
    //data
    NSMutableDictionary* _dataDict;
//    搜索结果组
    NSMutableArray* _searchResultArr;
}
//圈子ID
@property(nonatomic,assign) long long circleId;
//圈子名称
@property(nonatomic,retain) NSString* circleName;

//如果是从圈子详情进来的，则不显示详情按钮
@property(nonatomic,assign) BOOL enterFromDetail;

//是固定圈子还是临时圈子
@property(nonatomic,assign) CirCleType circleType;

@end
