//
//  org_list_model
//  ql
//
//  Created by yunlai on 14-3-22.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "org_list_model.h"

@implementation org_list_model

+ (BOOL)deleteAllListData
{
    org_list_model * geter = [org_list_model new];
    return [org_list_model deleteAllDataWithModel:geter];
}

+(NSMutableArray*) getAllOrgWithMemberIsnotNone{
    org_list_model* orgListMod = [[org_list_model alloc] init];
    orgListMod.where = @"parent_id != 0 and member_count != 0";
    NSMutableArray* orgArr = [orgListMod getList];
    [orgListMod release];
    
    return orgArr;
}
+(NSMutableArray*) oneOrgMember{
    org_list_model* orgListMod = [[org_list_model alloc] init];
    orgListMod.where = @"parent_id = 0";
    NSMutableArray* orgArr = [orgListMod getList];
    [orgListMod release];
    
    return orgArr;
}


+ (NSMutableArray *)getAllOrg
{
    org_list_model * geter = [org_list_model new];
    NSMutableArray * allOrgArr = [geter getList];
    RELEASE_SAFE(geter);
    return allOrgArr;
}

+ (NSMutableArray *)getChildOrg
{
    org_list_model * geter = [org_list_model new];
    geter.where = [NSString stringWithFormat:@"parent_id != %d",0];
    NSMutableArray * childArr = [geter getList];
    RELEASE_SAFE(geter);
    return childArr;
}


+ (BOOL)insertOrUpdateOrgListWithDic:(NSDictionary *)dic
{
    org_list_model * geter = [org_list_model new];
    NSNumber * orgIDNum = [dic objectForKey:@"id"];
    
    geter.where = [NSString stringWithFormat:@"id = %d",orgIDNum.intValue];
    return [org_list_model updateDataWithModel:geter withDic:dic];
}

+(BOOL) isOnlyOneOrg{
    org_list_model* orgListMod = [[org_list_model alloc] init];
    orgListMod.where = @"parent_id != 0";
    NSMutableArray* orgArr = [orgListMod getList];
    [orgListMod release];
    
    BOOL res = NO;
    if (orgArr.count == 0) {
        res = YES;
    }
    
    return res;
}

@end
