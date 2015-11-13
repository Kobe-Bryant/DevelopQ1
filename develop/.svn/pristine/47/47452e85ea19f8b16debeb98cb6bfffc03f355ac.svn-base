//
//  org_member_list_model.h
//  ql
//
//  Created by yunlai on 14-4-21.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "db_model.h"

@interface org_member_list_model : db_model

+ (BOOL)deleteAllListData;

+ (BOOL)insertOrUpdateOrgMemberListWithDic:(NSDictionary *)dic;

//获取有头衔的成员
+(NSMutableArray*) getHaveHonorMember:(long long) orgId;

//获取没有头衔的成员
+(NSMutableArray*) getNoHonorMember:(long long) orgId;

//获取单个用户信息
+(NSDictionary*) getUserInfoWith:(long long) userId;

@end
