//
//  TcpSendXintiaoPackage.m
//  ql
//
//  Created by yunlai on 14-5-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpSendXintiaoPackage.h"
#import "headParseClass.h"
#import "login_info_model.h"
@implementation TcpSendXintiaoPackage

- (NSData *)data{
    
    NSMutableData *allData = [[NSMutableData alloc]init];
    
    login_info_model *infoGeter = [[login_info_model alloc]init];
    NSArray *infoList = [infoGeter getList];
    NSDictionary * userDic = [infoList lastObject];
    
    
    [allData appendData:[headParseClass sendIMPortPackaging:0 wCmd:0x0004 srcUid:[[userDic objectForKey:@"id"]intValue] destUid:10000]];

    return allData;
}

@end
