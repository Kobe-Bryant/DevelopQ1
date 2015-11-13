//
//  circle_contacts_model.m
//  ql
//
//  Created by yunlai on 14-5-8.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "circle_contacts_model.h"

@implementation circle_contacts_model

+ (BOOL)deleteAllListData
{
    circle_contacts_model * geter = [circle_contacts_model new];
   return [circle_contacts_model deleteAllDataWithModel:geter];
}

+ (BOOL)insertOrUpdateContactList:(NSDictionary *)contactDic
{
    circle_contacts_model * geter = [circle_contacts_model new];
    NSNumber * userIDNum = [contactDic objectForKey:@"user_id"];
    
    geter.where = [NSString stringWithFormat:@"user_id = %lld",userIDNum.longLongValue];
    return [circle_contacts_model updateDataWithModel:geter withDic:contactDic];
}

@end
