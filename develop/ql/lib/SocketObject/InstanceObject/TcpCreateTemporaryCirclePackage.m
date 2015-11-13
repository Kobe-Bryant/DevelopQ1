//
//  TcpCreateTemporaryCirclePackage.m
//  ql
//
//  Created by LazySnail on 14-5-21.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpCreateTemporaryCirclePackage.h"
#import "headParseClass.h"
#import "SBJson.h"

@implementation TcpCreateTemporaryCirclePackage

- (NSData *)data{
    NSMutableData * wholeData = [[[NSMutableData alloc]init]autorelease];
    
    NSMutableArray * uidList = [[NSMutableArray alloc]init];
    
    for (NSNumber * uid in self.uidList) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:[uid longLongValue]],@"uid", nil];
        [uidList addObject:dic];
    }
    
    NSDictionary * uiDic = [NSDictionary dictionaryWithObjectsAndKeys:uidList,@"uidlist",nil];
    
    NSString * sendBodyStr = [uiDic JSONRepresentation];
    NSData * sendData = [sendBodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger length = sendData.length;
    
    [wholeData appendData:[headParseClass sendIMPortPackaging:length wCmd:CMD_TEMCIRCLE_ADDMEMBER srcUid:[[Global sharedGlobal]user_id].intValue destUid:0]];
    
    [wholeData appendData:sendData];
    RELEASE_SAFE(uidList);
    
    return wholeData;
    
}

@end
