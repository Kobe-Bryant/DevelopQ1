//
//  OriginData.m
//  ql
//
//  Created by LazySnail on 14-5-9.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "OriginData.h"
#import "TextData.h"
#import "PictureData.h"
#import "VoiceData.h"
#import "wantHaveData.h"
#import "CustomEmotionData.h"
#import "TogetherData.h"

@implementation OriginData

@synthesize status = _status;

+ (OriginData *)generateInstantDataWithDic:(NSDictionary *)dic
{
    int dataType = [[dic objectForKey:@"objtype"]intValue];
    
    switch (dataType) {
        case dataTypeText:
            return [[TextData alloc]initWithDic:dic];
            break;
        case dataTypePicture:
            return [[PictureData alloc]initWithDic:dic];
            break;
        case dataTypeVoice:
            return [[VoiceData alloc]initWithDic:dic];
            break;
        case dataTypeWantHave:
            return [[wantHaveData alloc]initWithDic:dic];
            break;
        case dataTypeCustomEmotion:
            return  [[CustomEmotionData alloc]initWithDic:dic];
            break;
        case dataTypeTogether:
            return [[TogetherData alloc]initWithDic:dic];
            break;
        default:
            break;
    }
    return nil;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    NSAssert(false, @"Must be over ride");
    return nil;
}

- (NSDictionary *)getDic{
    NSAssert(false, @"Must be over ride");
    return nil;
}


@end
