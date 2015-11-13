//
//  TcpSendPackage.h
//  ql
//
//  Created by yunlai on 14-5-3.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageData.h"

//发送的包的基类
@interface TcpSendPackage : NSObject

@property (nonatomic, retain) id head;

//发送的二进制数据
- (NSData *)data;

//发送的心跳包
+ (id)createXintiaoPackage;

//登录包
+ (id)createLoginPackage;

//注销包
+ (id)createLogoutPackage;

//消息包
+ (id)createMessagePackageWith:(MessageData *)msgData;

//邀请加入圈子包
+ (id)createInviteJoinPackage:(int)reciveId bodyJson:(NSDictionary *)bodyDic;

//确认加入圈子包
+ (id)createInviteJoinConfirmPackage:(long long)inviteId bodyJson:(NSDictionary *)bodyDic;

//圈子成员变更提醒包
+ (id)createCircleMemberUpdatePackage:(int)userId bodyJson:(NSDictionary *)bodyDic;

//生成创建临时圈子请求包
+ (id)generateCreateTemporaryCirclePackageWithUserList:(NSArray *)uList;

//生成添加临时圈子成员DATA
+ (NSData *)generateAddTemporaryCircleDataWithUserList:(NSArray *)uList andTempCircleID:(long long)tempCircleID;

@end
