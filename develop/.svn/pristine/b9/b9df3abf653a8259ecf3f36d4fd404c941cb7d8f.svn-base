//
//  headParseClass.h
//  ql
//
//  Created by yunlai on 14-4-29.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface headParseClass : NSObject

// 发送IM服务器接口
+ (NSData *)sendIMPortPackaging:(int)packLength;
+ (NSData *)sendIMPortPackaging:(int)packBodyLength wCmd:(int)wcmds srcUid:(int)SrcUid destUid:(int)DestUid;

// IM服务器返回数据解析
+ (NSString *)receiveIMPortPackaging:(NSData *)packData;

// 登录IM接口
+ (NSString*)TransformJson:(NSArray*)msgArry withLinkclient:(NSNumber*)client clienttype:(NSString *)typeKey msgList:(NSString *)msgKey;

// 心跳包
+ (NSString*)TransformJsonStr:(NSNumber *)rcodeValue withLinkStep:(NSNumber*)stepValue rcode:(NSString *)keyr andStep:(NSString *)keys;

@end
