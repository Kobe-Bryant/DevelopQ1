//
//  headParseClass.m
//  ql
//
//  Created by yunlai on 14-4-29.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "headParseClass.h"
#import "SBJsonWriter.h"
#import "JSONKit.h"

#define lhtonll(x) __DARWIN_OSSwapInt64(x)

@implementation headParseClass

// 包头数据封装
+ (NSData *)sendIMPortPackaging:(int)packLength{
    
    UInt8 buffer[32];
    UInt32 *dwVer = (UInt32 *)&buffer[0];
    UInt32 ver = 0x1001;
    *dwVer = htonl(ver);
    
    UInt32 *dwLen =(UInt32 *) &buffer[4];
    *dwLen = htonl(32 + packLength);
    
    UInt16 *wSeq = (UInt16 *)&buffer[8];
    *wSeq = htons(0);
    
    UInt16 *wCmd = (UInt16 *)&buffer[10];
    UInt16 cmd = 0x0000;
    *wCmd = htons(cmd);
    
    UInt64 *llSrcUid = (UInt64 *)&buffer[12];
    *llSrcUid = lhtonll(1);
    
    UInt64 *llDestUid =(UInt64 *) &buffer[20];
    *llDestUid = lhtonll(10000);
    NSLog(@"sizeof==%lu",sizeof(UInt64));
    
    UInt32 *Reserve = (UInt32 *)&buffer[28];
    *Reserve = htonl(0);
    
    NSData *aData = [NSData dataWithBytes:buffer length:32];
    
    return aData;
}

// 包头数据封装
+ (NSData *)sendIMPortPackaging:(int)packBodyLength wCmd:(int)wcmds srcUid:(int)SrcUid destUid:(int)DestUid{
    
    UInt8 buffer[32];
    UInt32 *dwVer = (UInt32 *)&buffer[0];
    UInt32 ver = 0x1001;
    *dwVer = htonl(ver);
    
    UInt32 *dwLen =(UInt32 *) &buffer[4];
    *dwLen = htonl(32 + packBodyLength);
    
    UInt16 *wSeq = (UInt16 *)&buffer[8];
    *wSeq = htons(0);
    
    UInt16 *wCmd = (UInt16 *)&buffer[10];
    UInt16 cmd = wcmds;
    *wCmd = htons(cmd);
    
    UInt64 *llSrcUid = (UInt64 *)&buffer[12];
    *llSrcUid = lhtonll(SrcUid);
    
    UInt64 *llDestUid =(UInt64 *) &buffer[20];
    *llDestUid = lhtonll(DestUid);
    
    UInt32 *Reserve = (UInt32 *)&buffer[28];
    *Reserve = htonl(0);
    
    NSData *aData = [NSData dataWithBytes:buffer length:32];
    
    return aData;
}

// 解析返回数据
+ (NSString *)receiveIMPortPackaging:(NSData *)packData{
    
    Byte *testByte = (Byte *)[packData bytes];
    
    UInt32 *dwVer = (UInt32 *)&testByte[0];
    *dwVer = ntohl(*dwVer);
    int v = *dwVer;
    
    UInt32 *dwLen = (UInt32 *)&testByte[4];
    *dwLen = ntohl(*dwLen);
    int len = *dwLen;
    
    UInt16 *wSeq = (UInt16 *)&testByte[8];
    *wSeq = ntohs(*wSeq);
    short seq = *wSeq;
    
    UInt16 *wCmd = (UInt16 *)&testByte[10];
    *wCmd = ntohs(*wCmd);
    short cmd = *wCmd;
    
    UInt64 *llSrcUid = (UInt64 *)&testByte[12];
    *llSrcUid = ntohl(*llSrcUid);
    long long srcUid = *llSrcUid;
    
    UInt64 *llDestUid = (UInt64 *)&testByte[20];
    *llDestUid = ntohl(*llDestUid);
    long long destUid = *llDestUid;
    
    UInt32 *Reserve = (UInt32 *)&testByte[28];
    *Reserve = ntohl(*Reserve);
    int reserve = *Reserve;

    NSLog(@"ver==%d=len=%d=seq=%d=cmd=%d=srcUid=%lld=destUid=%lld=reserve=%d",v,len,seq,cmd,srcUid,destUid,reserve);
    
    //取包体解析
    char *byte = (char *)&testByte[32];
    
    NSData *strData = [[NSData alloc] initWithBytes:byte length:len - 32];
    NSString *strjson = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    
    return strjson;
}

// 登录IM接口
+ (NSString *) TransformJson:(NSArray*)msgArry withLinkclient:(NSNumber*)client clienttype:(NSString *)typeKey msgList:(NSString *)msgKey{
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:client,typeKey,msgArry,msgKey, nil];
	NSString *jsonConvertedObj = [writer stringWithObject:dic];
    
	NSLog(@"jsonConvertedObj:%@",jsonConvertedObj);
    
    [writer release];
	NSString *reqStr = [NSString stringWithFormat:@"%@\n",jsonConvertedObj];
//	NSLog(@"req_string:%@",reqStr);
	return reqStr;
    
}

// 心跳包
+ (NSString *)TransformJsonStr:(NSNumber *)rcodeValue withLinkStep:(NSNumber*)stepValue rcode:(NSString *)keyr andStep:(NSString *)keys{
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:rcodeValue,keyr,stepValue,keys, nil];
	NSString *jsonConvertedObj = [writer stringWithObject:dic];
	NSLog(@"jsonConvertedObj:%@",jsonConvertedObj);
    
    [writer release];
	NSString *reqStr = [NSString stringWithFormat:@"%@\n",jsonConvertedObj];
	
	return reqStr;
}

@end
