//
//  circle_list_model
//  ql
//
//  Created by yunlai on 14-4-18.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "db_model.h"

@interface circle_list_model : db_model

//删除所以列表数据
+ (BOOL)deleteAllListData;

//获取所有圈子的信息数组
+ (NSMutableArray *)getInstanceList;

//获取指定id的圈子信息
+ (NSDictionary *)getCircleListWithCircleID:(long long)circleID;

//删除指定id的圈子
+ (BOOL)deleteCircleInfoWithCircleID:(long long)circleID;

//将所给的字典数据插入到临时圈子信息列表
+ (BOOL)insertOrUpdateDictionaryIntoCirlceList:(NSDictionary *)dic;

@end
