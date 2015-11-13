//
//  MessageData.h
//  ql
//
//  Created by LazySnail on 14-5-6.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OriginData.h"


typedef enum{
    //一般聊天消息
    kMessageTypeNormal = 1,
    //推送消息
    kMessageTypePush = 12,
    //我有我要消息
    kMessageTypeWant = 2,//booky add5.9
    kMessageTypeHave = 3,
    //评论消息
    kMessageTypeComment = 14,
    //我有我要回复消息
    kMessageTypeReplyWant = 16,
    kMessageTypeReplayHave = 15,
    //动态消息
    kMessageTypeDynamic = 17,
    //开放时间消息
    kMessageTypeOpenTime = 13,// booky add
    //状态消息
    kMessageTypeStatus = 11,
    //聚聚消息
    kMessageTypeTogether = 19,
}kMessageType;

@interface MessageData : NSObject <NSCopying>

//发送方id
@property (nonatomic, assign) long long  senderID;
//接收方id
@property (nonatomic, assign) long long  receiverID;
//消息类型 1 为普通消息 2为我有我要消息 11 为输入状态通知 12 组织方推送消息 13 开放时间
@property (nonatomic, assign) kMessageType msgtype;
//消息发送方式类型
@property (nonatomic, assign) int sendCommandType;
//Location ID
@property (nonatomic, assign) long long locmsgid;
//存储类型标识 1为服务器保存 2 为不保存
@property (nonatomic, assign) short flag;
//消息数组体
@property (nonatomic, retain) NSMutableArray *msg;
//接收消息时受到的消息id 服务器生成
@property (nonatomic, assign) long long msgid;
//发送消息时间
@property (nonatomic, assign) int sendtime;
//发送用户信息
@property (nonatomic, retain) NSDictionary * speakerinfo;
//聊天类型 1为组织方 2 为小秘书 3 为个人单聊
@property (nonatomic, assign) int talkType;
//聊天标题 占时定为名字
@property (nonatomic, retain) NSString * title;
//聊天消息数据
@property (nonatomic, retain) OriginData * msgData;
//是否显示时间
@property (nonatomic, assign) BOOL showTimeSign;


//通过服务端得到的消息数据字典生成对应的消息消息类
+ (MessageData *)generateMessageDataWithMessageRetrieveDic:(NSDictionary *)msgDic;

- (void)addMessageDataToMsg:(OriginData *)msgdata;
- (void)removeMessageDataFromMsg:(OriginData *)msgdata;

- (instancetype)initWithDic:(NSDictionary *)dic;
- (NSDictionary *)getSendDic;


@end
