//
//  TcpSendPackage.m
//  ql
//
//  Created by yunlai on 14-5-3.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpSendPackage.h"
#import "headParseClass.h"
#import "TcpSendLoginPackage.h"
#import "TcpSendXintiaoPackage.h"
#import "TcpSendTextMessagePackage.h"
#import "TcpSendLogoutPackage.h"
#import "TcpInviteJionPackage.h"
#import "TcpInviteJoinComfirmPackage.h"
#import "TcpCircleMemberDeletePackage.h"
#import "TcpCreateTemporaryCirclePackage.h"
#import "SBJson.h"

@implementation TcpSendPackage

// 创建心跳包对象
+ (id)createXintiaoPackage {
    
    TcpSendXintiaoPackage *xintiaoBao = [[TcpSendXintiaoPackage alloc]init];
    
    return xintiaoBao;
}

// 创建登录对象
+ (id)createLoginPackage{
    
    TcpSendLoginPackage *loginBao = [[TcpSendLoginPackage alloc]init];
    
    return loginBao;
}

// 创建注销包对象
+(id) createLogoutPackage{
    TcpSendLogoutPackage* logouyBao = [[TcpSendLogoutPackage alloc] init];
    return logouyBao;
}
// 创建消息对象
+ (id)createMessagePackageWith:(MessageData *)msgData
{
    TcpSendTextMessagePackage *textMessage = [[TcpSendTextMessagePackage alloc]init];
    textMessage.messageData = msgData;
    return textMessage;
}
// 创建邀请加入圈子对象
+ (id)createInviteJoinPackage:(int)reciveId bodyJson:(NSDictionary *)bodyDic{
    TcpInviteJionPackage *invite = [[TcpInviteJionPackage alloc]init];
    invite.receiveId = reciveId;
    invite.inviteInfoDic = bodyDic;
    
    return invite;
}
// 创建确认加入圈子对象
+ (id)createInviteJoinConfirmPackage:(long long )inviteId bodyJson:(NSDictionary *)bodyDic{
    TcpInviteJoinComfirmPackage *invite = [[TcpInviteJoinComfirmPackage alloc]init];
    invite.inviteId = inviteId;
    invite.inviteInfoDic = bodyDic;
    
    return invite;
}

// 圈子成员变更提醒
+ (id)createCircleMemberUpdatePackage:(int)userId bodyJson:(NSDictionary *)bodyDic{
    TcpCircleMemberDeletePackage *edit = [[TcpCircleMemberDeletePackage alloc]init];
    edit.deleteUserId = userId;
    edit.inviteInfoDic = bodyDic;
    
    return edit;
}

+ (id)generateCreateTemporaryCirclePackageWithUserList:(NSArray *)uList
{
    TcpCreateTemporaryCirclePackage * tPack = [[TcpCreateTemporaryCirclePackage alloc]init];
    tPack.uidList = uList;
    return tPack;
}

+ (NSData *)generateAddTemporaryCircleDataWithUserList:(NSArray *)uList andTempCircleID:(long long)tempCircleID
{
    NSMutableData * wholeData = [[[NSMutableData alloc]init]autorelease];
    NSMutableArray * uidList = [[NSMutableArray alloc]init];
    
    for (NSNumber * uid in uList) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:[uid longLongValue]],@"uid", nil];
        [uidList addObject:dic];
    }
    
    NSDictionary * uiDic = [NSDictionary dictionaryWithObjectsAndKeys:uidList,@"uidlist",nil];
    
//    NSString * sendBodyStr = [uiDic JSONRepresentation];
//    NSData * sendData = [sendBodyStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSInteger length = sendData.length;
//    
//    [wholeData appendData:[headParseClass sendIMPortPackaging:length wCmd:CMD_TEMCIRCLE_ADDMEMBER srcUid:[[Global sharedGlobal]user_id].intValue destUid:tempCircleID]];
//    
//    [wholeData appendData:sendData];
//    RELEASE_SAFE(uidList);

    wholeData = [headParseClass generateSendDataWithCommand:CMD_TEMCIRCLE_ADDMEMBER version:IM_PACKAGE_NO_ENCRYPTION serialNumber:0 senderID:[[Global sharedGlobal]user_id].longLongValue  receiverID:tempCircleID andValue:uiDic];
    
    return wholeData;
}

//发送包的二进制数据
- (NSData *)data{
    return nil;
}

@end
