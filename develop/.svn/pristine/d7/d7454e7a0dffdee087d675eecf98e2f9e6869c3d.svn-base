//
//  CircleManager.h
//  ql
//
//  Created by LazySnail on 14-6-10.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FatherCircleManager.h"


@interface CircleManager : FatherCircleManager

/*固定圈子数据库操作处理 */
//删除指定圈子成员
+ (BOOL)deleteCircleMemberWithCircleID:(long long)circleID andMemberID:(long long)memberID;
//删除全部固定圈子数据信息
+ (BOOL)deleteAllCircleDataInfoWithCircleID:(long long)circleID;
//插入指定圈子成员
+ (BOOL)insertCircleMemberWithMemberDic:(NSDictionary *)dic;
//被提出圈子删除圈子列表和成员列表
+ (BOOL)deleteCircleListAndMemberListWithCircleID:(long long)circleID;

/*
 **固定圈子流程操作方法
 */
//创建圈子接口
- (void)createCircleWithCircleName:(NSString *)circleName andCircleContent:(NSString *)circleContent;
//解散固定圈子接口
- (void)dismissCircleWithUserID:(long long)userID andCircleID:(long long)circleID;
//向一队人发送邀请消息
+ (void)inviteOtherJoinCircleWithCircleDic:(NSDictionary *)circleDic andOthers:(NSArray *)otherMembers;
//将成员踢出圈子
- (void)removeMemberFromCircle:(long long)circleID andUserID:(long long)userID;
//主动退出圈子
- (void)quitCircleWithCircleID:(long long)circleID;

/*
 **固定圈子信息修改操作
 */


@end
