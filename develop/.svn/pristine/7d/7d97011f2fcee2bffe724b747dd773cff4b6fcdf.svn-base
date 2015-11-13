//
//  circle_member_list_model.h
//  ql
//
//  Created by yunlai on 14-4-21.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "db_model.h"

@interface circle_member_list_model : db_model

//删除所有列表成员
+ (BOOL)deleteAllListData;

//删除指定圈子中的指定成员
+ (BOOL)deleteCircleMemberWithCircleID:(long long)circleID andMemberID:(long long)memberID;

//删除指定圈子中的全部成员
+ (BOOL)deleteAllCircleMmbersWithCircleID:(long long)circleID;

//查询指定id成员
+ (NSDictionary *)getCircleMemberDicWith:(long long)circleID andUserID:(long long)userID;

//查询指定圈子id的所有成员
+ (NSMutableArray *)getAllMemberWithCircle:(long long)circleID;

//将所给的字典数据插入到圈子成员列表
+ (BOOL)insertOrUpdateDictionaryIntoCirlceMemberList:(NSDictionary *)dic;

@end
