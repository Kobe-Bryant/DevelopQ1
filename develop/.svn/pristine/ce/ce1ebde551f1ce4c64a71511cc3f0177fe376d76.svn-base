//
//  temporary_circle_member_list_model.h
//  ql
//
//  Created by LazySnail on 14-5-21.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "db_model.h"

@interface temporary_circle_member_list_model : db_model

//查询指定id成员
+ (NSDictionary *)getTempCircleMemberDicWith:(long long)circleID andUserID:(long long)userID;

//查询自定临时圈子id的所有成员
+ (NSArray *)getAllMemberFormTempCircle:(long long)tempCircleID; 

// 插入单个成员字典到临时圈子成员列表数据库中
+ (BOOL)insertOrUpdateTempDictionaryIntoCirlceMemberList:(NSDictionary *)dic;

// 删除所有临时圈子成员
+ (BOOL)deleteAllTempCircleMmbersWithCircleID:(long long)TempCircleID;

//删除指定圈子中的指定成员
+ (BOOL)deleteTempCircleMemberWithCircleID:(long long)circleID andMemberID:(long long)memberID;

@end
