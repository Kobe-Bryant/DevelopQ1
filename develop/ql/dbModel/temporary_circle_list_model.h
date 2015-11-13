//
//  temporary_circles_list_model.h
//  ql
//
//  Created by LazySnail on 14-5-21.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "db_model.h"

@interface temporary_circle_list_model : db_model

//获取单个临时圈子信息
+ (NSDictionary *)getTemporaryCircleListWithTempCircleID:(long long)tCircleID;

//获取所有圈子的信息数组
+ (NSArray *)getInstanceList;

//删除指定id的圈子
+ (BOOL)deleteTemporaryCircleInfoWithCircleID:(long long)tCircleID;

//将所给的字典数据插入到临时圈子信息列表
+ (BOOL)insertOrUpdateDictionaryIntoTempCirlceList:(NSDictionary *)dic;

@end
