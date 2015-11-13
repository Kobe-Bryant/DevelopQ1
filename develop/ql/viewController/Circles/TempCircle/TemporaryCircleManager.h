//
//  TemporaryCircleManager.h
//  ql
//
//  Created by LazySnail on 14-5-21.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FatherCircleManager.h"

@protocol TemporaryCircleManagerDelegate <NSObject>

//创建临时圈子成功回调
@optional
- (void)createTemporaryCircleSuccessWithSender:(id)sender CircleDic:(NSDictionary *)circleDic;
- (void)addMemberSuccessWithSender:(id)sender CircleID:(long long)circleID;

@end

@interface TemporaryCircleManager : FatherCircleManager

@property (nonatomic, assign) id <TemporaryCircleManagerDelegate> tempdelegate;
@property (nonatomic, retain) NSArray * memberArr;
@property (nonatomic, assign) long long tempCircleID;

/*临时圈子数据库操作处理 */
//删除全部临时圈子信息
+ (BOOL)deleteAllTempCircleDataInfoWithTempCircleID:(long long)TempCircleID;

//创建临时圈子
- (void)createTemporaryCielre;
//解散临时圈子接口
- (void)dismissTempCircleWithUserID:(long long)userID andTempCircleID:(long long)tempCircleID;
//添加临时圈子成员
- (void)addMemberFromMemberArr;
//临时圈子删除成员
- (void)removeTemporaryMemberWithTempCircleID:(long long)tempCircleID AndMemebrID:(long long)memberID;
//退出临时圈子
- (void)quitTempCircleWithCircleID:(long long)tempCircleID;

@end
