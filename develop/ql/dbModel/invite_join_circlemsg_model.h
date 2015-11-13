//
//  invite_join_circlemsg_model.h
//  ql
//
//  Created by yunlai on 14-5-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "db_model.h"

@interface invite_join_circlemsg_model : db_model

+ (NSMutableArray *)getInviteJoinMessageWithCircleID:(long long)circleID;

+ (BOOL)deleteInviteDataWithCircleID:(long long)circleID;

@end
