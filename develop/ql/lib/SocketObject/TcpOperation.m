//
//  TcpOperation.m
//  ql
//
//  Created by yunlai on 14-5-3.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpOperation.h"
#import "TcpRequestHelper.h"
#import "headParseClass.h"

TcpOperation *TcpOperationSINGLE;

@implementation TcpOperation

+ (TcpOperation *)shareTcpOperation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (TcpOperationSINGLE == nil) {
            TcpOperationSINGLE = [[TcpOperation alloc] init];
        }
    });
    
    return TcpOperationSINGLE;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _serialQueue = dispatch_queue_create("ss", NULL);
    }
    return self;
}

- (void)addAPackage:(TcpReadPackage *)package commandType:(int)type packageData:(NSData *)data{
    [self beginNewParser:type packageData:data];
}

- (void)beginNewParser:(int)type packageData:(NSData *)data{

    //------booky 5.8------//
    NSData* judgeData = [[NSData alloc]initWithBytes:data.bytes length:data.length];
    
    NSDictionary * dataHeadInfo = [headParseClass getPackageHeaderInfo:judgeData];
    int commandID = [[dataHeadInfo objectForKey:@"wCmd"]intValue];
    
    RELEASE_SAFE(judgeData);
    
    NSLog(@"请求命令字commandID=%@",[dataHeadInfo objectForKey:@"wCmd"]);
    
        switch (commandID) {
            case CMD_USER_LOGIN_ACK:
            {   //是登陆成功的包
                NSLog(@"++login++");
                 [[TcpRequestHelper shareTcpRequestHelperHelper] receiveLoginResponse:data];
            }
                break;
            case CMD_USER_HEARTBEAT_ACK:
            {   //心跳包
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveXintiaoPackage:data];
            }
                break;
            case CMD_USER_LOGOUT_ACK:
            {
                //退出登陆成功
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveLogoutResponse:data];
            }
                break;
            case CMD_PERSONAL_MSGSEND_ACK:
            {   // 发送个人消息 成功与否回馈
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveMessageSended:data];
            }
                break;
            case CMD_PERSONAL_MSGRECV:
            {
                //接收个人消息
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveChatMessage:data];
            }
                break;
            case CMD_CIRCLE_MSG_SEND_ACK:
            {
                //发送圈子消息 成功与否回馈
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveCircleMessageSended:data];
            }
                break;
            case CMD_CIRCLE_MSG_RECEIVE:
                //接收圈子消息
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveCircleChatMessage:data];
                break;
            case CMD_INVITE_JOIN_ACK:
            {
                //邀请成员加入圈子发送回馈
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveInviteJoinResponse:data];
            }
                break;
            case CMD_INVITE_JOIN:
            {
                //收到邀请加入圈子信息
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveInviteMessage:data];
            }
                break;
            case CMD_INVITE_JOIN_CONFIRM_ACK:
            {
                //确认加入圈子信息
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveConfirmInviteCircleResponse:data];
            }
                break;
            case CMD_CIRCLEMEMBER_CHG_NTF:
            {
                //圈子成员变更信息
                [[TcpRequestHelper shareTcpRequestHelperHelper] receiveCircleMemberUpdateResponse:data];
            }
                break;
            case CMD_TEMP_CIRCLEMEMBER_CHG_NTF:
            {
                //临时圈子成员变更信息
                [[TcpRequestHelper shareTcpRequestHelperHelper]receiveTempCircleMemberUpdateResponse:data];
            }
                break;
            case CMD_TEMCIRCLE_ADDMEMBER_ACK:
            {
                //创建临时圈子回馈
                [[TcpRequestHelper shareTcpRequestHelperHelper]receiveCreateTemporaryCircleFeedback:data];
            }
                break;
            case CMD_FORCEDOWN_NTF:
            {
                //被迫下线消息通知接收
                [[TcpRequestHelper shareTcpRequestHelperHelper]receiveCompelQuitMessage:data];
            }
                break;
            case CMD_TEMP_CIRCLE_MSGSEND_ACK:
                //临时圈子发送消息回执
                [[TcpRequestHelper shareTcpRequestHelperHelper]receiveTempCircleMessageFeedback:data];
                break;
            case CMD_TEMP_CIRCLE_MSGRECV:
                //临时圈子消息接收
                [[TcpRequestHelper shareTcpRequestHelperHelper]receiveTempCircleChatMessage:data];
                break;
            case CMD_PERSONAL_PUSHREC:
                //单聊离线消息接收
                [[TcpRequestHelper shareTcpRequestHelperHelper]receiveOfflineMessage:data];
                break;
            case CMD_DISCUSS_PUSHREC:
                //固定圈子批量接收离线聊天消息
                [[TcpRequestHelper shareTcpRequestHelperHelper]receiveOfflineCircleMessage:data];
                break;
            case  CMD_TEMP_CIRCLE_PUSHREC:
                //临时圈子批量接收离线聊天消息
                [[TcpRequestHelper shareTcpRequestHelperHelper]receiveOfflineTempCircleMessage:data];
                break;
            case CMD_CIRCLE_CHG_NTF:
                //固定圈子信息变更通知
                [[TcpRequestHelper shareTcpRequestHelperHelper] recieveCircleInfoChangeNotify:data];
                break;
            case CMD_TEMP_CIRCLE_CHG_NTF:
                //临时圈子信息变更通知
                [[TcpRequestHelper shareTcpRequestHelperHelper] recieveTempCircleInfoChangeNotify:data];
            case CMD_QUIT_CIRCLR_ACK:
                //退出固定圈子响应
                [[TcpRequestHelper shareTcpRequestHelperHelper] recieveQuitCircleMessage:data];
                break;
            case CMD_QUIT_TEMP_CIRCLE_ACK:
                //退出临时圈子响应
                [[TcpRequestHelper shareTcpRequestHelperHelper] recieveQuitTempCircleMessage:data];
                break;
            default:
                break;
        }
    
}

@end
