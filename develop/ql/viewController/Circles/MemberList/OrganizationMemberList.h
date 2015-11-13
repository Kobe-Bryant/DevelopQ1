//
//  OrganizationMemberList.h
//  ql
//
//  Created by yunlai on 14-7-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "OrgManager.h"

@interface OrganizationMemberList : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,OrgManagerDelegate>{
    UITableView* _tableview;
    UISearchBar* _searchBar;
    UISearchDisplayController* _searchCtl;
    
    NSMutableArray* _memberArr;
    //keys
    NSMutableArray* _keysArr;
    //data
    NSMutableDictionary* _dataDict;
    
//    搜索结果
    NSMutableArray* _searchResultArr;
//    有头衔成员
    NSMutableArray* _haveHonorArr;
}
//组织ID
@property(nonatomic,assign) long long orgId;
//组织名称
@property(nonatomic,retain) NSString* orgName;

@end
