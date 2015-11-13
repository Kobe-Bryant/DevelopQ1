//
//  EmoticonItemData.m
//  ql
//
//  Created by LazySnail on 14-8-28.
//  Copyright (c) 2014年 Snail. All rights reserved.
//

#import "EmoticonItemData.h"
#import "CustomEmotionData.h"
#import "emoticon_list_model.h"

@implementation EmoticonItemData

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.itemID = [[dic objectForKey:@"id"]intValue];
        self.title = [dic objectForKey:@"title"];
        self.code = [dic objectForKey:@"code"];
        self.emotionID = [[dic objectForKey:@"emoticon_id"]intValue];
        self.previewIcon = [dic objectForKey:@"preview_icon"];
        self.emoticonPath = [dic objectForKey:@"emoticon_path"];
        self.createTime = [[dic objectForKey:@"create_time"]longLongValue];
        self.updateTime = [[dic objectForKey:@"update_time"]longLongValue];
    }
    return self;
}

- (CustomEmotionData *)generateCustomEmotionData
{
    CustomEmotionData * customEmotion = [[CustomEmotionData alloc]init];
    customEmotion.title = self.title;
    customEmotion.emoticonItemID = self.itemID;
    customEmotion.emotionUrl = self.emoticonPath;
    customEmotion.thumbUrl = self.previewIcon;
    NSDictionary * emoticonDic = [emoticon_list_model getEmoticonDicWithEmoticonID:self.emotionID];
    customEmotion.filePath = [emoticonDic objectForKey:@"packet_name"];
    return customEmotion;
}

@end
