//
//  DataChecker.h
//  ql
//
//  Created by LazySnail on 14-5-26.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"
/*
 **该类用于圈子数据跟新和检查
 */
@class DataChecker;

@protocol DataCheckerDelegate <NSObject>

@optional
- (void)dataCheckerFinishedUpdata:(DataChecker *)sender andTempCircleId:(NSNumber *)tempCircleId;
- (void)dataCheckerUpdateCircleInfoSuccessWithSender:(DataChecker *)sender andCircleContects:(NSMutableArray *)contacts;

- (void)dataCheckerUpdateOrganizationInfoSuccessWithSender:(DataChecker *)sender;

@end

@interface DataChecker : NSObject <HttpRequestDelegate>

@property (nonatomic, assign) id <DataCheckerDelegate> delegate;

//是否修改聊天列表 初始化默认为Yes
@property (nonatomic, assign) BOOL ifModifyChatList;

/*
 **临时圈子操作
 */
// 临时圈子查询该账号是否已经存在
- (BOOL)checkTempCirleExistWithID:(NSNumber *)tempCircleId;
// 临时圈子更新指定id的信息
- (void)updateTempCircleInfoWithID:(NSNumber *)tempCirleId;



/*
 **固定圈子操作
 */
// 固定圈子跟新信息 包括圈子信息和圈子成员信息
- (void)updateCircleInfoWithID:(long long)circleID;

/*
 **组织操作
 */
// 跟新组织成员信息
- (void)updateOrgInfoWithOrgID:(long long)orgID;


@end
