//
//  EmotionStoreData.m
//  ql
//
//  Created by LazySnail on 14-8-22.
//  Copyright (c) 2014年 Snail. All rights reserved.
//

#import "EmotionStoreData.h"

@implementation EmotionStoreData

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.title = [dic objectForKey:@"title"];
        self.subtitle = [dic objectForKey:@"subtitle"];
        self.emoticonID = [[dic objectForKey:@"emoticon_id"]intValue];
        self.packetName = [dic objectForKey:@"packet_name"];
        self.packetPath = [dic objectForKey:@"packet_path"];
        self.iconUrl = [dic objectForKey:@"icon"];
        self.chatIcon = [dic objectForKey:@"chat_icon"];
        self.price = [[dic objectForKey:@"price"]floatValue];
        self.status = [[dic objectForKey:@"status"]intValue];
        self.createTime = [[dic objectForKey:@"create_time"]longLongValue];
        self.updateTime = [[dic objectForKey:@"update_time"]longLongValue];
    }
    return self;
}

@end
