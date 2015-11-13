//
//  OriginData.h
//  ql
//
//  Created by LazySnail on 14-5-9.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>


// 实际上是 objtype 用于判断消息类型
#define dataTypeText            1
#define dataTypePicture         2
#define dataTypeVoice           6
#define dataTypeWantHave        7
#define dataTypeTogether        8
#define dataTypeCustomEmotion   9

@interface OriginData : NSObject <NSCopying>
{
    NSNumber * _status;
}

//对象类型 2为图片 6 为语音 7 为我有我要
@property (nonatomic, readonly) int objtype;
//发送状态 1为发送中 2为发送成功 3为发送失败 4为未读取
@property (nonatomic, retain) NSNumber * status;

//生成实例消息数据
+ (OriginData *)generateInstantDataWithDic:(NSDictionary *)dic;

- (NSDictionary *)getDic;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
