//
//  DataManager.m
//  ASIHttp
//
//  Created by yunlai on 13-5-29.
//  Copyright (c) 2013年 yunlai. All rights reserved.
//

#import "NetManager.h"
#import "CmdOperation.h"
#import "Common.h"
#import "Global.h"

@implementation NetManager

- (id)init
{
    self = [super init];
    
    if (self) {
        commandOperation = [[CmdOperation alloc]init];
        [commandOperation start];
    }
    return self;
}

// 单例模式创建实例
+ (NetManager *)sharedManager
{
    static NetManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[self alloc] init];
    });
    return dataManager;
}

// 执行请求
- (void)accessService:(NSMutableDictionary*)reqdic
                 data:(NSData *)data
              command:(int)commandID
         accessAdress:(NSString*)accAddr
             delegate:(id)theDelegate
            withParam:(NSMutableDictionary*)param
{
    //加密请求url
    NSString *reqstr = [Common TransformJson:reqdic withLinkStr: [ACCESS_SERVER_LINK stringByAppendingString:accAddr]];
    
    NSLog(@"加密请求的url连接地址---------------%@",reqstr);
    if ([[Global sharedGlobal].netWorkQueueArray indexOfObject:reqstr] == NSNotFound) {
        
        [[Global sharedGlobal].netWorkQueueArray addObject:reqstr];
        
        // 请求
        if (data == nil)
        {
            [commandOperation addOperationHTTPRequest:[NSURL URLWithString:reqstr] type:commandID delegate:theDelegate withParam:param];
        } else
        {
            [commandOperation addOperationPostRequest:[NSURL URLWithString:reqstr] data:data type:commandID delegate:theDelegate withParam:param];
        }
    }
}

- (void)accessService:(NSMutableDictionary*)reqdic
             dataList:(NSArray *)dataList
              command:(int)commandID
         accessAdress:(NSString*)accAddr
             delegate:(id)theDelegate
            withParam:(NSMutableDictionary*)param
{
    //加密请求url
    NSString *reqstr = [Common TransformJson:reqdic withLinkStr: [ACCESS_SERVER_LINK stringByAppendingString:accAddr]];
    
    NSLog(@" SendData request url = %@",reqstr);
    
    if ([[Global sharedGlobal].netWorkQueueArray indexOfObject:reqstr] == NSNotFound) {
        
        [[Global sharedGlobal].netWorkQueueArray addObject:reqstr];
        
        // 请求
        if (dataList == nil || dataList.count == 0)
        {
            [commandOperation addOperationHTTPRequest:[NSURL URLWithString:reqstr] type:commandID delegate:theDelegate withParam:param];
        }
        else
        {
            [commandOperation addOperationPostRequest:[NSURL URLWithString:reqstr] dataList:dataList type:commandID delegate:theDelegate withParam:param];
        }
    }
}

- (void)dealloc
{
    [commandOperation cancel];
    [commandOperation release], commandOperation = nil;
	[super dealloc];
}


@end
