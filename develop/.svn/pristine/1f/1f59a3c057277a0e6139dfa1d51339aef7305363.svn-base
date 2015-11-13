//
//  TcpSendFeedbackTipsPackage.m
//  ql
//
//  Created by yunlai on 14-5-7.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpSendFeedbackTipsPackage.h"
#import "headParseClass.h"

@implementation TcpSendFeedbackTipsPackage

-(NSData*) data{
    NSMutableData *allData = [[NSMutableData alloc]init];
    
    //转换包体成二进制
    NSData *bodyData = [[headParseClass TransformJson:nil withLinkclient:[NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]] clienttype:@"srcuid" msgList:nil]dataUsingEncoding:NSUTF8StringEncoding];
    
    //获取包体长度
    NSUInteger lengh = [headParseClass TransformJson:nil withLinkclient:[NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]] clienttype:@"srcuid" msgList:nil].length;
    
    [allData appendData:[headParseClass sendIMPortPackaging:lengh wCmd:0x0015 srcUid:[[Global sharedGlobal].user_id intValue] destUid:[[[Global sharedGlobal].secretInfo objectForKey:@"id"] intValue]]];
    [allData appendData:bodyData];
    
    return allData;
}

@end
