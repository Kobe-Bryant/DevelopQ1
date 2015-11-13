//
//  org_list_model.h
//  ql
//
//  Created by yunlai on 14-3-22.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "db_model.h"

@interface org_list_model : db_model

//删除列表
+ (BOOL)deleteAllListData;

//获取所有组织成员不为0的组织
+(NSMutableArray*) getAllOrgWithMemberIsnotNone;

//获取所有组织
+ (NSMutableArray *)getAllOrg;

//获取一级组织
+(NSMutableArray*) oneOrgMember;

//获取子组织
+ (NSMutableArray *)getChildOrg;

+ (BOOL)insertOrUpdateOrgListWithDic:(NSDictionary *)dic;

//是否只有一级组织
+(BOOL) isOnlyOneOrg;

@end
