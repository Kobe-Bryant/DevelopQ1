//
//  wantHaveData.h
//  ql
//
//  Created by yunlai on 14-6-18.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "OriginData.h"

typedef enum {
    PersonMessageWant = 16,
    PersonMessageHave = 15,
} PersonMessageType;

@interface wantHaveData : OriginData

//缩略图名
@property(nonatomic,retain) NSString* tbdesc;
@property(nonatomic,retain) NSString* tburl;
@property(nonatomic,assign) int ID;
@property(nonatomic,retain) NSString* txt;
@property(nonatomic,retain) NSString* msgdesc;

//消息类型
@property(nonatomic,assign) PersonMessageType type;

@end
