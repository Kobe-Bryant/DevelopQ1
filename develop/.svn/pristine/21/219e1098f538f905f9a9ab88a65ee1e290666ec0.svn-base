//
//  temporary_circles_list_model.m
//  ql
//
//  Created by LazySnail on 14-5-21.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "temporary_circle_list_model.h"

@implementation temporary_circle_list_model

+ (NSDictionary *)getTemporaryCircleListWithTempCircleID:(long long)tCircleID
{
    temporary_circle_list_model * tclGeter = [temporary_circle_list_model new];
    tclGeter.where = [NSString stringWithFormat:@"temp_circle_id = %lld",tCircleID];
    NSArray * tclist = [tclGeter getList];
    NSDictionary * resultDic = nil;
    if (tclist.count > 0) {
        resultDic = [tclist firstObject];
    }
    
    RELEASE_SAFE(tclGeter);
    return resultDic;
}

+ (NSArray *)getInstanceList
{
    temporary_circle_list_model * tclGeter = [temporary_circle_list_model new];
    NSArray * tclist = [tclGeter getList];
    RELEASE_SAFE(tclGeter);
    return tclist;
}

+ (BOOL)deleteTemporaryCircleInfoWithCircleID:(long long)tCircleID
{
    BOOL successJudger = NO;
    temporary_circle_list_model * tclGeter = [temporary_circle_list_model new];
    tclGeter.where = [NSString stringWithFormat:@"temp_circle_id = %lld",tCircleID];
    NSArray *tclist = [tclGeter getList];
    if (tclist.count == 0) {
        successJudger = YES;
        RELEASE_SAFE(tclGeter);
        return successJudger;
    }else {
        successJudger = [tclGeter deleteDBdata];
        RELEASE_SAFE(tclGeter);
        return successJudger;
    }
}

+ (BOOL)insertOrUpdateDictionaryIntoTempCirlceList:(NSDictionary *)dic
{
    NSNumber * tCircleID = [dic objectForKey:@"temp_circle_id"];
    
    temporary_circle_list_model * tclGeter = [temporary_circle_list_model new];
    tclGeter.where = [NSString stringWithFormat:@"temp_circle_id = %lld",tCircleID.longLongValue];
    return [db_model updateDataWithModel:tclGeter withDic:dic];
}

@end
