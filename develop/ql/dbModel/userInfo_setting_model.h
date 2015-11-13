//
//  userInfo_setting_model.h
//  ql
//
//  Created by yunlai on 14-5-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "db_model.h"

@interface userInfo_setting_model : db_model

+ (BOOL)insertOrUpdateInfoWithDic:(NSDictionary *)userSettingDic;

+ (NSDictionary *)getUserSettingInfo;

@end
