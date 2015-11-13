//
//  TcpCircleMemberDeletePackage.m
//  ql
//
//  Created by yunlai on 14-5-13.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpCircleMemberDeletePackage.h"
#import "headParseClass.h"

@implementation TcpCircleMemberDeletePackage

@synthesize inviteInfoDic;
@synthesize deleteUserId;

- (NSData*)data{
    
    NSMutableData *allData = [[NSMutableData alloc]init];
    
    NSString *messageJsonStr = [headParseClass TransFormNSDictionary:self.inviteInfoDic];
    
    NSUInteger length = messageJsonStr.length;
    NSData *bodyData = [messageJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [allData appendData:[headParseClass sendIMPortPackaging:length wCmd:CMD_CIRCLEMEMBER_CHG_NTF srcUid:[[Global sharedGlobal].user_id intValue] destUid:self.deleteUserId]];
    
    DLog("%d",self.deleteUserId);
    
    [allData appendData:bodyData];
    
    return allData;
}

@end
