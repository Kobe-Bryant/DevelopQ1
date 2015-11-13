//
//  CircleManager.m
//  ql
//
//  Created by LazySnail on 14-6-10.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "CircleManager.h"
#import "NetManager.h"
#import "circle_list_model.h"
#import "temporary_circle_list_model.h"
#import "temporary_circle_member_list_model.h"
#import "circle_member_list_model.h"
#import "chatmsg_list_model.h"
#import "circle_chat_msg_model.h"
#import "TextData.h"
#import "TcpRequestHelper.h"

//typedef BOOL (^ dismissParseMethod) (void);
//typedef BOOL (^ dismissJudger) (dismissParseMethod theMethod,NSDictionary * firstDic,NSDictionary * lastDic);

@interface CircleManager ()
{
    
}

@property (nonatomic, assign) long long quitCircleID;

@end

@implementation CircleManager

+ (BOOL)deleteAllCircleDataInfoWithCircleID:(long long)circleID
{
    //booky 8.13 不删除消息列表中的圈子
    BOOL successJudger =
    [circle_list_model deleteCircleInfoWithCircleID:circleID] &&
    [circle_member_list_model deleteAllCircleMmbersWithCircleID:circleID] &&
    [chatmsg_list_model deleteChatMsgListWithTalkType:MessageListTypeCircle andID:circleID];
    long long userID = [[[Global sharedGlobal]user_id]longLongValue];
    [circle_chat_msg_model deleteAllChatDataWithSenderID:circleID andReceiverID:userID];
    return successJudger;
}

+ (BOOL)deleteCircleListAndMemberListWithCircleID:(long long)circleID
{
    BOOL successJudger = [circle_list_model deleteCircleInfoWithCircleID:circleID] &&
    [circle_member_list_model deleteAllCircleMmbersWithCircleID:circleID];
    
    return successJudger;
}


+ (BOOL)deleteCircleMemberWithCircleID:(long long)circleID andMemberID:(long long)memberID
{
    BOOL successJudger = NO;
    
    successJudger = [CircleManager updateCircleMemberSumWithCircleID:circleID andNum:-1]
    &&
    [circle_member_list_model deleteCircleMemberWithCircleID:circleID andMemberID:memberID];
    return successJudger;
    
}

+ (BOOL)insertCircleMemberWithMemberDic:(NSDictionary *)dic
{
    BOOL successJudger = NO;
    long long circleID = [[dic objectForKey:@"circle_id"]longLongValue];
    
    successJudger = [CircleManager updateCircleMemberSumWithCircleID:circleID andNum:1]
    &&
    [circle_member_list_model insertOrUpdateDictionaryIntoCirlceMemberList:dic];
    return successJudger;
}

+ (BOOL)updateCircleMemberSumWithCircleID:(long long)circleID andNum:(int)num
{
    NSDictionary * circleDic = [circle_list_model getCircleListWithCircleID:circleID];
    
    NSMutableDictionary * mutCircleDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[circleDic objectForKey:@"circle_id"],@"circle_id", nil];
    int  userNum = [[circleDic objectForKey:@"user_sum"]intValue];
    if (num > 0) {
        userNum += num;
    } else {
        if (userNum >= 1) {
            userNum += num;
        } else {
            userNum = 0;
        }
    }
    
    [mutCircleDic setObject:[NSNumber numberWithInt:userNum] forKey:@"user_sum"];
    return [circle_list_model insertOrUpdateDictionaryIntoCirlceList:mutCircleDic];
}

//主动退出圈子成功后清除圈子数据
- (BOOL)quitCircleSuccess:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KNotiQuitCircle object:nil];
    
    NSDictionary * quitFeedback = [notification object];
    if ([[quitFeedback objectForKey:@"rcode"]intValue] == 0) {
        return [CircleManager deleteAllCircleDataInfoWithCircleID:self.quitCircleID];
    } else {
        NSString * error = [quitFeedback objectForKey:@"other"];
        [Common checkProgressHUDShowInAppKeyWindow:error andImage:nil];
        return NO;
    }
}

- (void)dismissCircleWithUserID:(long long)userID andCircleID:(long long)circleID
{
    NSString * accessAdStr = @"circle/delete.do?param=";
    
    NSNumber * userIDNum = [NSNumber numberWithLongLong:userID];
    NSNumber * circleIDNum = [NSNumber numberWithLongLong:circleID];
    
    NSMutableDictionary * sendInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         userIDNum,@"user_id",
                                         circleIDNum,@"circle_id",
                                         nil];
    
    [[NetManager sharedManager]accessService:sendInfoDic data:nil command:CIRCLE_DISMISS_COMMAND_ID accessAdress:accessAdStr delegate:self withParam:sendInfoDic];
}

- (void)createCircleWithCircleName:(NSString *)circleName andCircleContent:(NSString *)circleContent
{
    
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                        circleName  ,@"name",
                                        circleContent,@"content",
                                        [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:GROUP_CREATE_COMMAND_ID accessAdress:@"circle/addcircle.do?param=" delegate:self withParam:nil];
}

#pragma mark - HttpRequestDelegate

+ (void)inviteOtherJoinCircleWithCircleDic:(NSDictionary *)circleDic andOthers:(NSArray *)otherMembers
{
    NSString * userName = [[[Global sharedGlobal]userInfo]objectForKey:@"realname"];
    NSString * userPortrait = [[[Global sharedGlobal]userInfo]objectForKey:@"portrait"];
    
    NSString * inviteText =  [NSString stringWithFormat:@"%@邀请你加入%@",
                              userName,
                              [circleDic objectForKey:@"name"]];
    TextData * inviteTextData = [[TextData alloc]init];
    inviteTextData.txt =  inviteText;
    
    NSArray * msgArr = [NSArray arrayWithObject:[inviteTextData getDic]];
    RELEASE_SAFE(inviteTextData);//add vincent
    
    int circle_id = [[circleDic objectForKey:@"circle_id"]intValue];
    
    NSDictionary *bodyJson = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:circle_id],@"circleid",   //圈子ID
                              [circleDic objectForKey:@"name"],@"circlename",   //圈子名
                              userPortrait,@"circleavator",                     //圈子头像信息
                              msgArr,@"msg",                                    //邀请信息
                              nil];
    
    for (int i =0; i<otherMembers.count; i++) {
        //邀请加入圈子
        [[TcpRequestHelper shareTcpRequestHelperHelper]sendInviteJoinCircleCommandId:TCP_INVITE_JOIN_COMMAND_ID receive:[[[otherMembers objectAtIndex:i] objectForKey:@"user_id"] intValue] bodyJson:bodyJson];
    }
}

- (void)removeMemberFromCircle:(long long)circleID andUserID:(long long)userID
{
    NSMutableDictionary * deleteInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithLongLong:userID],@"user_id",
                                           [NSNumber numberWithLongLong:circleID],@"circle_id",
                                           //圈子类型 0 为固定圈子 1 为临时圈子
                                           [NSNumber numberWithInt:0],@"circle_type",
                                           nil];
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionaryWithDictionary:deleteInfoDic];
    
    NSString * interfaceStr = @"circle/removecircle.do?param=";
    
    [[NetManager sharedManager]accessService:deleteInfoDic data:nil command:CIRCLE_MEMBER_DELETE_COMMAND_ID accessAdress:interfaceStr delegate:self withParam:paramDic];
}

- (void)quitCircleWithCircleID:(long long)circleID
{
    //赋值退出的圈子ID 为后面的数据清除作准备
    self.quitCircleID = circleID;
    
    NSDictionary * headDic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithLongLong:circleID],@"circle_id",
               [NSNumber numberWithLongLong:[[Global sharedGlobal].user_id longLongValue]],@"user_id",
               nil];
    
    [[TcpRequestHelper shareTcpRequestHelperHelper] sendQuitCircleMessage:headDic];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitCircleSuccess:) name:KNotiQuitCircle object:nil];
}

@end
