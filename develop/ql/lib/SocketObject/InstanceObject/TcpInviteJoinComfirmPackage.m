//
//  TcpInviteJoinComfirmPackage.m
//  ql
//
//  Created by yunlai on 14-5-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpInviteJoinComfirmPackage.h"
#import "headParseClass.h"

@implementation TcpInviteJoinComfirmPackage
@synthesize inviteInfoDic;
@synthesize inviteId;

- (NSData*)data{
    
    NSMutableData *allData = [[NSMutableData alloc]init];
    
    NSString *messageJsonStr = [headParseClass TransFormNSDictionary:self.inviteInfoDic];
    DLog(@"%@=%d",messageJsonStr,self.inviteId);
    
    NSUInteger length = messageJsonStr.length;
    NSData *bodyData = [messageJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [allData appendData:[headParseClass sendIMPortPackaging:length wCmd:CMD_INVITE_JOIN_CONFIRM srcUid:[[Global sharedGlobal].user_id intValue] destUid:self.inviteId]];
    
    [allData appendData:bodyData];
    
    return allData;
}

@end
