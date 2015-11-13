//
//  cicles_list_model.m
//  ql
//
//  Created by yunlai on 14-4-18.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "circle_list_model.h"

@implementation circle_list_model

- (id)init
{
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}

+ (BOOL)deleteAllListData
{
    circle_list_model * geter = [circle_list_model new];
    return [circle_list_model deleteAllDataWithModel:geter];
}

+ (NSMutableArray *)getInstanceList
{
    circle_list_model * clGeter = [circle_list_model new];
    NSMutableArray * resultArr = [clGeter getList];
    RELEASE_SAFE(clGeter);
    return resultArr;
}

+ (NSDictionary *)getCircleListWithCircleID:(long long )circleID
{
    circle_list_model * cListGeter = [circle_list_model new];
    cListGeter.where = [NSString stringWithFormat:@"circle_id = %lld",circleID];
    
    NSArray * clist = [cListGeter getList];
    NSDictionary * resultDic = nil;
    if (clist.count > 0) {
        resultDic = [clist firstObject];
    }
    
    RELEASE_SAFE(cListGeter);
    return resultDic;
}

+ (BOOL)deleteCircleInfoWithCircleID:(long long)circleID
{
    circle_list_model * cListGeter = [circle_list_model new];
    cListGeter.where = [NSString stringWithFormat:@"circle_id = %lld",circleID];
    
    BOOL resultJudger = NO;
    resultJudger = [cListGeter deleteDBdata];
    RELEASE_SAFE(cListGeter);
    
    return resultJudger;
}

+ (BOOL)insertOrUpdateDictionaryIntoCirlceList:(NSDictionary *)dic
{
    BOOL successJudger = NO;
    NSNumber * tCircleID = [dic objectForKey:@"circle_id"];

    circle_list_model * clGeter = [circle_list_model new];
    clGeter.where = [NSString stringWithFormat:@"circle_id = %lld",tCircleID.longLongValue];
    NSMutableDictionary * updateDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [updateDic removeObjectForKey:@"circle_id"];
    
    NSDictionary * circleDic = [circle_list_model getCircleListWithCircleID:tCircleID.longLongValue];
    if (circleDic == nil) {
        if ([clGeter insertDB:dic] == 0) {
            successJudger = YES;
        }
    } else {
        successJudger = [clGeter updateDB:updateDic];
    }
    
    RELEASE_SAFE(clGeter);
    return successJudger;
}

@end
