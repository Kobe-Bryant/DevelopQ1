//
//  MessageData.m
//  ql
//
//  Created by LazySnail on 14-5-6.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "MessageData.h"

@implementation MessageData

@synthesize locmsgid = _locmsgid;
@synthesize msgData = _msgData;

+ (MessageData *)generateMessageDataWithMessageRetrieveDic:(NSDictionary *)msgDic
{
    NSDictionary * speakerinfo = [msgDic objectForKey:@"speakerinfo"];
    long long sender_id = [[speakerinfo objectForKey:@"uid"]longLongValue];
    long long receiver_id = [[[Global sharedGlobal]user_id]longLongValue];
    NSNumber * sendTime = [msgDic objectForKey:@"sendtime"];
    if (sendTime == nil) {
        sendTime = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
    }
    
    MessageData * retrieveMsg = [MessageData new];
    retrieveMsg.msg = [msgDic objectForKey:@"msg"];
    retrieveMsg.sendCommandType = CMD_PERSONAL_MSGSEND;
    retrieveMsg.senderID = sender_id;
    retrieveMsg.receiverID = receiver_id;
    retrieveMsg.msgtype = kMessageTypeNormal;
    retrieveMsg.sendtime = sendTime.intValue;
    retrieveMsg.talkType = MessageListTypePerson;
    retrieveMsg.title = [speakerinfo objectForKey:@"nickname"];
    retrieveMsg.speakerinfo = speakerinfo;
    
    return retrieveMsg;
}


- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _msg = [[NSMutableArray alloc]init];
        _speakerinfo = [[NSDictionary alloc]init];
        _title = @"";
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [self init];
    if (self != nil) {
        _senderID = [[dic objectForKey:@"sender_id"]longLongValue];
        _receiverID = [[dic objectForKey:@"receiver_id"]longLongValue];
        NSMutableArray * msgArr = [[dic objectForKey:@"msg"]retain];
        if (msgArr == nil || ![msgArr isKindOfClass:[NSMutableArray class]]) {
            _msg = nil;
        } else {
            _msg = msgArr;
            _msgData = [OriginData generateInstantDataWithDic:[_msg firstObject]];
        }
        _msgtype = [[dic objectForKey:@"msgtype"]intValue];
        _msgid = [[dic objectForKey:@"msgid"]longLongValue];
        
        NSDictionary * speckerInfo = [[dic objectForKey:@"speakerinfo"] retain];
        if (speckerInfo == nil || ![speckerInfo isKindOfClass:[NSDictionary class]]) {
            _speakerinfo = nil;
        } else {
            _speakerinfo = speckerInfo;
        }

        _sendtime = [[dic objectForKey:@"sendtime"]intValue];
        NSString * title =[[dic objectForKey:@"title"]retain];
        if (title == nil || ![title isKindOfClass:[NSString class]]) {
            title = nil;
        } else {
            _title = title;
        }
    }
    return self;
}

- (NSDictionary *)getSendDic
{
    NSDictionary * retDic = nil;
    //移除发送数据的失败标识
    NSMutableDictionary * removeStatusDic = nil;
    for (int i = 0;i<self.msg.count;i++) {
        NSDictionary *msgDic = [self.msg objectAtIndex:i];
        if ([msgDic objectForKey:@"msgDataStatus"]!= nil) {
            removeStatusDic = [NSMutableDictionary dictionaryWithDictionary:msgDic];
            [removeStatusDic removeObjectForKey:@"msgDataStatus"];
        }
        if (removeStatusDic != nil) {
            [self.msg replaceObjectAtIndex:i withObject:removeStatusDic];
        }
    }
    
    if (self.flag != MessageListTypeCircle) {
        
        NSNumber * secretoryNum = [[[Global sharedGlobal]secretInfo]objectForKey:@"user_id"];
        NSNumber * orgNum = [[[Global sharedGlobal]organizationInfo]objectForKey:@"user_id"];
        
        if (self.receiverID == secretoryNum.longLongValue || self.receiverID == orgNum.longLongValue) {
            self.flag = 1;
        } else {
            self.flag = 0;
        }
        
        retDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  [NSNumber numberWithInt:self.msgtype] ,@"msgtype",
                  [NSNumber numberWithLongLong:self.locmsgid],@"locmsgid",
                  [NSNumber numberWithShort:self.flag],@"flag",
                  self.msg,@"msg",
                  nil];
    } else {
        retDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  [NSNumber numberWithInt:self.msgtype] ,@"msgtype",
                  [NSNumber numberWithLongLong:self.locmsgid],@"locmsgid",
                  self.msg,@"msg",
                  nil];
    }
    return retDic;
}

- (NSMutableArray *)msg
{
    if (_msg.count == 0 || _msg == nil)  {
        if (_msg != nil) {
            RELEASE_SAFE(_msg);
        }
        if (_msgData != nil) {
            _msg = [NSMutableArray new];
            [_msg addObject:[_msgData getDic]];
        }
    }
    return _msg;
}

- (OriginData *)msgData
{
    if (_msgData == nil) {
        if (_msg.count > 0) {
            _msgData =[OriginData generateInstantDataWithDic:[_msg firstObject]];
        }
    }
    return _msgData;
}

- (void)setMsgData:(OriginData *)msgData
{
    //赋值成员变量并自增引用计数
    _msgData = [msgData retain];
    if (_msgData != nil) {
        NSMutableArray * msgNewArr = [[NSMutableArray alloc]initWithCapacity:1];
        [msgNewArr addObject:[_msgData getDic]];
        self.msg = msgNewArr;
        RELEASE_SAFE(msgNewArr);
    }
}

- (void)addMessageDataToMsg:(OriginData *)msgdata
{
    [_msg addObject:[msgdata getDic]];
}

- (void)removeMessageDataFromMsg:(OriginData *)msgdata
{
    [_msg removeObject:[msgdata getDic]];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    MessageData * theCopy = [MessageData new];
    theCopy.senderID = self.senderID;
    theCopy.receiverID = self.receiverID;
    theCopy.msgData = [self.msgData copy];
    theCopy.msgtype = self.sendCommandType;
    theCopy.sendCommandType = self.sendCommandType;
    theCopy.locmsgid = self.locmsgid;
    theCopy.flag = self.flag;
    theCopy.msg = [self.msg copy];
    theCopy.msgid = self.msgid;
    theCopy.sendtime = self.sendtime;
    theCopy.speakerinfo = [self.speakerinfo copy];
    theCopy.talkType = self.talkType;
    theCopy.title = [self.title copy];
    theCopy.showTimeSign = self.showTimeSign;
    return theCopy;
}

- (void)dealloc {
    self.msgData = nil;
    self.msg = nil;
    self.speakerinfo = nil;
    self.title = nil;
    LOG_RELESE_SELF;
    [super dealloc];

}

@end
