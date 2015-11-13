//
//  login_info_model.m
//  ql
//
//  Created by yunlai on 14-2-26.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "login_info_model.h"

@implementation login_info_model

+ (BOOL)insertOrUpdataLoginInfoWithDic:(NSDictionary *)loginDic
{
    login_info_model * geter = [login_info_model new];
    //保证只有当前user信息 因此删除所有数据并插入最新
    [geter deleteDBdata];
    NSNumber * userIDNum = [loginDic objectForKey:@"id"];
    geter.where = [NSString stringWithFormat:@"id = %lld",userIDNum.longLongValue];
    
   return [login_info_model updateDataWithModel:geter withDic:loginDic];
}

+ (NSDictionary *)getUserInfo
{
    login_info_model * geter = [login_info_model new];
    NSArray * userArr = [geter getList];
    NSDictionary * userDic = [userArr firstObject];
    RELEASE_SAFE(geter);
    return userDic;
}

@end
