//
//  MessageDataManager.h
//  ql
//
//  Created by LazySnail on 14-5-6.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageData.h"
#import "TcpRequestHelper.h"

@interface MessageDataManager : NSObject 

@property (nonatomic, retain) NSMutableArray * dataQueue;
//重新发送队列 用于当socket 从新连接的时候从新将未发送消息发送出去
@property (nonatomic, retain) NSMutableArray * waitToResendQueue;

+ (MessageDataManager *)shareMessageDataManager;

//存储消息数据到数据库 用于圈子消息 和单聊
- (void)restoreData:(MessageData *)msgdata;

//刷新数据库消息数据
- (BOOL)updateData:(MessageData *)msgData;

//通过字典生成对应的MessageData
+ (MessageData *)getMessageDataFromDBDic:(NSDictionary *)dataDic;

//根据消息类型talk_type和聊天双方id来删除对应的聊天数据
+ (BOOL)deleteChatDBdataWithTalkType:(MessageListType) talkType andSenderID:(long long)senderID andReceiverID:(long long)receiverID;

@end
