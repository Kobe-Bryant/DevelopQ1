//
//  CustomEmoticonCell.m
//  ql
//
//  Created by LazySnail on 14-9-2.
//  Copyright (c) 2014年 Snail. All rights reserved.
//

#import "CustomEmoticonCell.h"
#import "CustomEmotionData.h"
#import "UIImageView+WebCache.h"

@interface CustomEmoticonCell () <CustomEmotionDataDelegate>
{
    
}

@property (nonatomic, retain) UIImageView * emoticonView;

@end

@implementation CustomEmoticonCell

+ (float)caculateCellHeighFrom:(NSDictionary *)messageDic
{
    return 150;
}

- (void)freshWithInfoDic:(NSDictionary *)messageDic
{
    MessageData * messageObject = [messageDic objectForKey:@"msgObject"];
    CustomEmotionData *customData = (CustomEmotionData *)messageObject.msgData;
    customData.delegate = self;

    CGRect emoticonRect = CGRectMake(0, 0, 100, 100);
    UIImageView * emoticonView = [[UIImageView alloc]initWithFrame:emoticonRect];
//    [emoticonView setImageWithURL:[NSURL URLWithString:customData.emotionUrl] placeholderImage:nil];
    
    self.emoticonView = emoticonView;
    
    //复用时移除老的View
    if (self.messageContentView != nil) {
        [self.messageContentView removeFromSuperview];
        self.messageContentView = nil;
    }
    self.messageContentView = emoticonView;
    [super freshWithInfoDic:messageDic];
    _sessionBackView.image = nil;
    
    RELEASE_SAFE(emoticonView);
    
    //加载发送loading
    if (_indicatorView != nil) {
        _indicatorView.frame = CGRectMake(CGRectGetMinX(_sessionBackView.frame) + CGRectGetWidth(_sessionBackView.frame)/2 - CGRectGetWidth(_indicatorView.frame)/2, CGRectGetMaxY(_sessionBackView.frame) - CGRectGetWidth(_sessionBackView.frame)/2 - CGRectGetWidth(_indicatorView.frame)/2, _indicatorView.frame.size.width, _indicatorView.frame.size.height);
    }
    [customData getGifImg];
}

#pragma mark - CustomEmoticonDataDelegate

- (void)getGifUIImageSuccessWithUIImage:(UIImage *)gifImg
{
    self.emoticonView.image = gifImg;
}

- (void)dealloc
{
    LOG_RELESE_SELF;
    self.emoticonView = nil;
    [super dealloc];
}

@end
