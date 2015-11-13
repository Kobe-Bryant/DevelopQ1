//
//  temporary_circle_member_list_model.m
//  ql
//
//  Created by LazySnail on 14-5-21.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "temporary_circle_member_list_model.h"

@implementation temporary_circle_member_list_model

+ (NSDictionary *)getTempCircleMemberDicWith:(long long)circleID andUserID:(long long)userID
{
    temporary_circle_member_list_model * tcmlGeter = [temporary_circle_member_list_model new];
    tcmlGeter.where = [NSString stringWithFormat:@"circle_id = %lld and user_id = %lld",circleID,userID];
    
    NSArray * theArr = [tcmlGeter getList];
    NSDictionary * resultDic = nil;
    if (theArr.count > 0) {
        resultDic = [theArr firstObject];
    }
    
    RELEASE_SAFE(tcmlGeter);
    return resultDic;
}

+ (NSArray *)getAllMemberFormTempCircle:(long long)tempCircleID
{
    temporary_circle_member_list_model * tcmlGeter = [temporary_circle_member_list_model new];
    tcmlGeter.where = [NSString stringWithFormat:@"circle_id = %lld",tempCircleID];
    
    NSArray *memberArr = [tcmlGeter getList];
    if (memberArr.count != 0)
        return memberArr;
    else return nil;
}

+ (BOOL)insertOrUpdateTempDictionaryIntoCirlceMemberList:(NSDictionary *)dic
{
    BOOL successJudger = NO;
    NSNumber * circleID = [dic objectForKey:@"circle_id"];
    NSNumber * user_id = [dic objectForKey:@"user_id"];
    
    temporary_circle_member_list_model * tclGeter = [temporary_circle_member_list_model new];
    tclGeter.where = [NSString stringWithFormat:@"circle_id = %lld and user_id = %lld",circleID.longLongValue,user_id.longLongValue];
    
    NSArray * currentArr = [tclGeter getList];
    
    
    if (currentArr.count == 0) {
        if ([tclGeter insertDB:dic] != 0) {
            successJudger = YES;
        }
    } else {
        successJudger = [tclGeter updateDB:dic];
    }
    
    RELEASE_SAFE(tclGeter);
    return successJudger;
}

+ (BOOL)deleteTempCircleMemberWithCircleID:(long long)circleID andMemberID:(long long)memberID
{
    BOOL successJudge = NO;
    temporary_circle_member_list_model * tcmlGter = [temporary_circle_member_list_model new];
    NSString * whereStr = [NSString stringWithFormat:@"circle_id = %lld and user_id = %lld",circleID,memberID];
    tcmlGter.where = whereStr;
    successJudge = [tcmlGter deleteDBdata];
    RELEASE_SAFE(tcmlGter);
    return successJudge;
}

+ (BOOL)deleteAllTempCircleMmbersWithCircleID:(long long)TempCircleID
{
    temporary_circle_member_list_model * tcmListGeter = [temporary_circle_member_list_model new];
    tcmListGeter.where = [NSString stringWithFormat:@"circle_id = %lld",TempCircleID];
    BOOL successJudger = [tcmListGeter deleteDBdata];
    RELEASE_SAFE(tcmListGeter);
    return successJudger;
}

@end
