//
//  circle_member_list_model.m
//  ql
//
//  Created by yunlai on 14-4-21.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "circle_member_list_model.h"

@implementation circle_member_list_model

+ (BOOL)deleteAllListData
{
    circle_member_list_model * geter = [circle_member_list_model new];
    return [circle_member_list_model deleteAllDataWithModel:geter];
}

+ (BOOL)deleteCircleMemberWithCircleID:(long long)circleID andMemberID:(long long)memberID
{
    BOOL successJudge = NO;
    circle_member_list_model * cmlGter = [circle_member_list_model new];
    NSString * whereStr = [NSString stringWithFormat:@"circle_id = %lld and user_id = %lld",circleID,memberID];
    cmlGter.where = whereStr;
    successJudge = [cmlGter deleteDBdata];
    RELEASE_SAFE(cmlGter);
    return successJudge;
}

+ (BOOL)deleteAllCircleMmbersWithCircleID:(long long)circleID
{
    BOOL successJudge = NO;
    circle_member_list_model * cmlGeter = [circle_member_list_model new];
    cmlGeter.where = [NSString stringWithFormat:@"circle_id = %lld",circleID];
    successJudge = [cmlGeter deleteDBdata];
    RELEASE_SAFE(cmlGeter);
    return successJudge;
}

+ (NSDictionary *)getCircleMemberDicWith:(long long)circleID andUserID:(long long)userID
{
    circle_member_list_model * cmlGeter = [circle_member_list_model new];
    cmlGeter.where = [NSString stringWithFormat:@"circle_id = %lld and user_id = %lld",circleID,userID];
    
    NSArray * theArr = [cmlGeter getList];
    NSDictionary * resultDic = nil;
    if (theArr.count > 0) {
        resultDic = [theArr firstObject];
    }
    
    RELEASE_SAFE(cmlGeter);
    return resultDic;
}

+ (NSMutableArray *)getAllMemberWithCircle:(long long)circleID
{
    circle_member_list_model * cmlGeter = [circle_member_list_model new];
    cmlGeter.where = [NSString stringWithFormat:@"circle_id = %lld",circleID];
    NSArray * allMember = [cmlGeter getList];
    if (allMember.count > 0) {
        return  [NSMutableArray arrayWithArray:allMember];
    } else {
        return nil;
    }
}

+ (BOOL)insertOrUpdateDictionaryIntoCirlceMemberList:(NSDictionary *)dic
{
    BOOL successJudger = NO;
    circle_member_list_model * clGeter = [circle_member_list_model new];
    NSNumber * circleID = [dic objectForKey:@"circle_id"];
    NSNumber * user_id = [dic objectForKey:@"user_id"];
    clGeter.where = [NSString stringWithFormat:@"circle_id = %lld and user_id = %lld",circleID.longLongValue,user_id.longLongValue];
    NSArray * cList = [clGeter getList];
    
    if (cList.count == 0) {
        if ([clGeter insertDB:dic] == 0) {
            successJudger = YES;
        }
    } else {
        successJudger = [clGeter updateDB:dic];
    }
    
    RELEASE_SAFE(clGeter);
    return successJudger;

}

@end
