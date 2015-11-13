//
//  TcpSendLoginPackage.m
//  ql
//
//  Created by yunlai on 14-5-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpSendLoginPackage.h"
#import "headParseClass.h"
#import "login_info_model.h"
#import "circle_list_model.h"
#import "temporary_circle_list_model.h"
#import "circle_chat_msg_model.h"
#import "temporary_circle_chat_msg_model.h"
#import "SBJson.h"

#define keyMsgCircle 1
#define KeyMsgTemporaryCircle 2

@implementation TcpSendLoginPackage

// 封装登录请求包，包头+包体,转二进制
- (NSData *)data{
    
    NSMutableData *allData = [[NSMutableData alloc]init];
//    NSMutableArray *_loginArray = [self getLatestCircleMessageArr];
    NSMutableArray* _loginArray = [self getLastestCircleHisMsgArr];
    //转换包体成二进制
    
    int orgId = [[Global sharedGlobal].org_id intValue];

    
//    NSString * bodyJson =[headParseClass TransformJson:_loginArray
//                                         withLinkclient:[NSNumber numberWithInt:1]
//                                             clienttype:@"clienttype" //客户端设备类型
//                                                msgList:@"oldmsglist" //消息列表
//                                                  orgId:[NSNumber numberWithInt:orgId] //组织ID
//                                                orgKey:@"organizationid"];
    
    NSDictionary * sendDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:1],@"clienttype",
                              _loginArray,@"oldmsglist",
                              [NSNumber numberWithInt:orgId],@"organizationid",nil];
    
    NSString * bodyJson = [sendDic JSONRepresentation];
    
    NSData *bodyData = [bodyJson dataUsingEncoding:NSUTF8StringEncoding];
    
    //获取包体长度
    NSUInteger lengh = bodyData.length;
    
    [allData appendData:[headParseClass sendIMPortPackaging:lengh wCmd:CMD_USER_LOGIN srcUid:[[Global sharedGlobal].user_id intValue] destUid:10000]];
    [allData appendData:bodyData];
    
    return allData;
}

//获取圈子中最近的一条消息的信息数组
- (NSMutableArray *)getLatestCircleMessageArr
{
    //取出所有圈子的最新一条收到的消息并插入一个可变数组中
    circle_chat_msg_model * ccmGeter = [circle_chat_msg_model new];
    //该数组释放在转换为json字符之后
    NSMutableArray * circleArrs = [NSMutableArray new];
    NSArray * allCircleArr = [circle_list_model getInstanceList];
    
    if (allCircleArr.count > 0) {
        for (NSDictionary * circleDic in allCircleArr)
        {
            NSNumber * circleId = [NSNumber numberWithLongLong:[[circleDic objectForKey:@"sender_id"]longLongValue]];
            NSString * whereStr = [NSString stringWithFormat:@"sender_id = %lld or receiver_id = %lld order by msgid desc",circleId.longLongValue,circleId.longLongValue];
            ccmGeter.where = whereStr;
            NSArray * ccmList = [ccmGeter getList];
            if (ccmList.count > 0)
            {
                NSDictionary * latestMsg = [ccmList firstObject];
                NSNumber * latestMsgMid = [NSNumber numberWithLongLong:[[latestMsg objectForKey:@"msgid"]longLongValue]];
                NSDictionary * insertDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                            circleId,@"circleid",
                                            [NSNumber numberWithInt:keyMsgCircle],@"circletype",
                                            latestMsgMid,@"oldmsgid",nil];
                [circleArrs addObject:insertDic];
            }
        }
    }
    RELEASE_SAFE(ccmGeter);
    
    //取出临时圈子中最新收到的消息并插入一个可变数组中
    temporary_circle_chat_msg_model * tccmListGeter = [temporary_circle_chat_msg_model new];
    NSArray * allTempCircleList = [temporary_circle_list_model getInstanceList];
    if (allTempCircleList.count > 0) {
        for (NSDictionary * tempCircleDic in allTempCircleList)
        {
            NSNumber * tempCircleID = [NSNumber numberWithLongLong:[[tempCircleDic objectForKey:@"temp_circle_id"]longLongValue]];
            NSString * whereStr = [NSString stringWithFormat:@"sender_id = %lld or receiver_id = %lld order by msgid desc",tempCircleID.longLongValue,tempCircleID.longLongValue];
            tccmListGeter.where = whereStr;
            
            NSArray * allTempMsgList = [tccmListGeter getList];
            if (allTempMsgList.count > 0) {
                NSDictionary * latestMsgDic = [allTempMsgList firstObject];
                NSNumber * latestMsgid = [NSNumber numberWithLongLong:[[latestMsgDic objectForKey:@"msgid"]longLongValue]];
                
                NSDictionary * insertDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                            tempCircleID,@"circleid",
                                            [NSNumber numberWithInt:KeyMsgTemporaryCircle],@"circletype",
                                            latestMsgid,@"oldmsgid",
                                            nil];
                [circleArrs addObject:insertDic];
            }
        }
    }
    RELEASE_SAFE(tccmListGeter);
    return [circleArrs autorelease];
}

//获取圈子历史消息纪录
-(NSMutableArray*) getLastestCircleHisMsgArr{
    NSMutableArray* lastestCircleHisMsgArr = [NSMutableArray arrayWithCapacity:0];
    
    circle_list_model* circleMod = [[circle_list_model alloc] init];
    NSArray* circleArr = [circleMod getList];
    
    temporary_circle_list_model* tempCircleMod = [[temporary_circle_list_model alloc] init];
    NSArray* tempCircleArr = [tempCircleMod getList];
    
    for (NSDictionary* dic in circleArr) {
        NSNumber * circleid = [NSNumber numberWithLongLong:[[dic objectForKey:@"circle_id"] longLongValue]];
        
        NSDictionary* insertDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   circleid,@"circleid",
                                   [NSNumber numberWithInt:keyMsgCircle],@"circletype",
                                   [NSNumber numberWithLongLong:[[dic objectForKey:@"msgid"]longLongValue]],@"oldmsgid",
                                   nil];
        [lastestCircleHisMsgArr addObject:insertDic];
    }
    
    for (NSDictionary* dic in tempCircleArr) {
        NSNumber * tempCircleID = [NSNumber numberWithLongLong:[[dic objectForKey:@"temp_circle_id"] longLongValue]];
        
        NSDictionary* insertDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   tempCircleID,@"circleid",
                                   [NSNumber numberWithInt:KeyMsgTemporaryCircle],@"circletype",
                                   [NSNumber numberWithLongLong:[[dic objectForKey:@"msgid"]longLongValue]],@"oldmsgid",
                                   nil];
        [lastestCircleHisMsgArr addObject:insertDic];
    }
    
    [circleMod release];
    [tempCircleMod release];
    
    return lastestCircleHisMsgArr;
}

@end
