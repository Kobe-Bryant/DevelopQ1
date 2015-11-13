//
//  TcpReceiveOfflineMsgFeedbackPackage.m
//  ql
//
//  Created by LazySnail on 14-6-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpReceiveOfflineMsgFeedbackPackage.h"
#import "headParseClass.h"
#import "SBJson.h"
@implementation TcpReceiveOfflineMsgFeedbackPackage

+ (NSData *)generateDataWithMsgDic:(NSDictionary *)msgDic
{
    return [headParseClass generateSendDataWithCommand:CMD_PERSONAL_PUSHREC_ACK
                                                             version:IM_PACKAGE_NO_ENCRYPTION
                                                        serialNumber:0
                                                            senderID:[[[Global sharedGlobal]user_id]longLongValue]
                                                          receiverID:0
                                              andValue:msgDic];
}

@end
