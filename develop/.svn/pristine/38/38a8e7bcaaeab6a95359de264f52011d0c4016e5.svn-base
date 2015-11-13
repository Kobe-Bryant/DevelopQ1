//
//  org_member_list_model.m
//  ql
//
//  Created by yunlai on 14-4-21.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "org_member_list_model.h"

@implementation org_member_list_model

+ (BOOL)deleteAllListData
{
    org_member_list_model * geter = [org_member_list_model new];
    return [org_member_list_model deleteAllDataWithModel:geter];
}

+ (BOOL)insertOrUpdateOrgMemberListWithDic:(NSDictionary *)dic
{
    org_member_list_model * geter = [org_member_list_model new];
    NSNumber * orgID = [dic objectForKey:@"org_id"];
    NSNumber* user_id = [dic objectForKey:@"user_id"];
    geter.where = [NSString stringWithFormat:@"org_id = %lld and user_id = %lld",orgID.longLongValue,user_id.longLongValue];
    return [org_member_list_model updateDataWithModel:geter withDic:dic];
}

//如果orgId为0，则读取所有的
+(NSMutableArray*) getHaveHonorMember:(long long) orgId{
    org_member_list_model* orgMemMod = [[org_member_list_model alloc] init];
    if (orgId == 0) {
        orgMemMod.where = @"honor_sort != 0";
    }else{
        orgMemMod.where = [NSString stringWithFormat:@"org_id = %lld and honor_sort != 0",orgId];
    }
    
    orgMemMod.orderBy = @"honor_sort";
    orgMemMod.orderType = @"desc";
    NSMutableArray* haveHonorMembersArr = [orgMemMod getList];
    
    [orgMemMod release];
    
    return haveHonorMembersArr;
}

+(NSMutableArray*) getNoHonorMember:(long long) orgId{
    org_member_list_model* orgMemMod = [[org_member_list_model alloc] init];
    if (orgId == 0) {
        orgMemMod.where = @"honor_sort = 0";
    }else{
        orgMemMod.where = [NSString stringWithFormat:@"org_id = %lld and honor_sort = 0",orgId];
    }
    
    NSMutableArray* haveHonorMembersArr = [orgMemMod getList];
    
    [orgMemMod release];
    
    return haveHonorMembersArr;
}

+(NSDictionary*) getUserInfoWith:(long long) userId{
    org_member_list_model* orgMemMod = [[org_member_list_model alloc] init];
    orgMemMod.where = [NSString stringWithFormat:@"user_id = %lld",userId];
    NSArray* arr = [orgMemMod getList];
    return [arr firstObject];
}

@end
