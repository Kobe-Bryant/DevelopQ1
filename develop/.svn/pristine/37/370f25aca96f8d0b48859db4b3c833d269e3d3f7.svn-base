//
//  iMMessageDataManager.h
//  ql
//
//  Created by LazySnail on 14-6-5.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"
#import "NetManager.h"
#import "MessageDataManager.h"

#define kMessageUserInfo    @"MessageUserInfo"
#define kMessageData        @"MessageData"
#define kMessageObjct       @"MessageObjct"

#define IM_DATA_MANAGER [iMMessageDataManager shareiMMessageDataManager]

@class CustomEmotionData;

@interface iMMessageDataManager : NSObject <HttpRequestDelegate>

@property (nonatomic, retain) MessageDataManager * dataManager;
@property (nonatomic, assign) float imageSize;

//生成一个消息发送器的单例
+ (iMMessageDataManager *)shareiMMessageDataManager;
//向服务器传输所选图片并且生成对应的图片类型消息发送给iM服务器
- (MessageData *)sendImageData:(NSDictionary *)imgPickerInfoDic;
//发送文本聊天消息
- (MessageData *)sendTextData:(NSDictionary *)textInfoDic;
//发送语音消息
- (MessageData *)sendVoiceDataWithDic:(NSDictionary *)voiceInfoDic;
//发送自定义表情消息
- (MessageData *)sendCustomEmoticonWithEmoticonData:(CustomEmotionData *)emoticonData andInfoDic:(NSDictionary *)emoticonInfoDic;

//重置发送消息状态
- (void)resetiMMessageSendStatus;

@end
