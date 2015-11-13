//
//  invite_join_circlemsg_model.m
//  ql
//
//  Created by yunlai on 14-5-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "invite_join_circlemsg_model.h"

@implementation invite_join_circlemsg_model

+ (NSMutableArray *)getInviteJoinMessageWithCircleID:(long long)circleID
{
    invite_join_circlemsg_model * geter = [invite_join_circlemsg_model new];
    geter.where = [NSString stringWithFormat:@"circle_id = %lld",circleID];
    NSMutableArray * inviteMsgArr = [geter getList];
    RELEASE_SAFE(geter);
    return inviteMsgArr;
}

+ (BOOL)deleteInviteDataWithCircleID:(long long)circleID
{
    BOOL successJuger = NO;
    invite_join_circlemsg_model * geter = [invite_join_circlemsg_model new];
    geter.where = [NSString stringWithFormat:@"circle_id = %lld",circleID];
    successJuger = [geter deleteDBdata];
    return successJuger;
}

@end
