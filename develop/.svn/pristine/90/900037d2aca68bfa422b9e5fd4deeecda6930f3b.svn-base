//
//  userInfo_setting_model.m
//  ql
//
//  Created by yunlai on 14-5-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "userInfo_setting_model.h"

@implementation userInfo_setting_model

+ (BOOL)insertOrUpdateInfoWithDic:(NSDictionary *)userSettingDic
{
    userInfo_setting_model * geter = [[userInfo_setting_model alloc]init];
    NSNumber * userIDNum = [userSettingDic objectForKey:@"id"];
    
    geter.where = [NSString stringWithFormat:@"id = %lld",userIDNum.longLongValue];
    return [userInfo_setting_model updateDataWithModel:geter withDic:userSettingDic];
}

+ (NSDictionary *)getUserSettingInfo
{
    userInfo_setting_model * geter = [[userInfo_setting_model alloc]init];
    NSArray * list = [geter getList];
    NSDictionary * userInfoDic = [list firstObject];
    RELEASE_SAFE(geter);
    return userInfoDic;
}

@end
