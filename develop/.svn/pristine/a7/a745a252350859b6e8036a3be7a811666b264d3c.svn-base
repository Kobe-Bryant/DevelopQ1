//
//  TcpInviteJionPackage.m
//  ql
//
//  Created by yunlai on 14-5-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpInviteJionPackage.h"
#import "headParseClass.h"

@implementation TcpInviteJionPackage
@synthesize inviteInfoDic;
@synthesize receiveId;

- (NSData*)data{
    
    NSMutableData *allData = [[NSMutableData alloc]init];

    NSString *messageJsonStr = [headParseClass TransFormNSDictionary:self.inviteInfoDic];
    
    NSData *bodyData = [messageJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger length = bodyData.length;
    
    [allData appendData:[headParseClass sendIMPortPackaging:length wCmd:CMD_INVITE_JOIN srcUid:[[Global sharedGlobal].user_id intValue] destUid:self.receiveId]];
    
    [allData appendData:bodyData];
    
    NSDictionary * headDic =  [headParseClass getHeaderInfo:allData];
    NSString * bodyjson = [headParseClass parseIMPortPackaging:allData];
    NSLog(@"%@",headDic);
    NSLog(@"%@",bodyjson);
    
    return allData;
}

@end
