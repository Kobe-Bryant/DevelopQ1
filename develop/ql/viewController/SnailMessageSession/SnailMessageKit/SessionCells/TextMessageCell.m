//
//  sessionInfoCell.m
//  ql
//
//  Created by LazySnail on 14-4-28.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TextMessageCell.h"
#import "TQRichTextView.h"
#import "RegexKitLite.h"
#import "TQRichTextEmojiRun.h"


@interface TextMessageCell ()
{
    TQRichTextView *_msgTextView;
}
@end

@implementation TextMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //文本消息内容框
    _msgTextView = [[TQRichTextView alloc]initWithFrame:CGRectZero];
    _msgTextView.backgroundColor = [UIColor clearColor];
    _msgTextView.font = KQLSystemFont(16);
    _msgTextView.textColor = [UIColor colorWithRed:68.0f/255.0f green:68.0f/255.0f blue:68.0f/255.0f alpha:1.0f];
    
    return self;
}

+ (float)caculateCellHeighFrom:(NSDictionary *)messageDic
{
    float textHeight = 0.0f;
    CGSize textSize = [TextMessageCell getTextContentSizeFrom:messageDic];
    textHeight +=  textSize.height + 45 + [MessageCell caculateCellHeighFrom:messageDic];
    return textHeight;
}

+ (CGSize)getTextContentSizeFrom:(NSDictionary *)messageDic
{
    //获取文本内容并且计算本文长度
    NSString * messageStr =[messageDic objectForKey:@"textMessage"];
    
    //转换表情字符的长度
    NSString *lengStr = [TextMessageCell translateLengthStringFromEmoj:messageStr];
    
    
    CGSize textSize = [lengStr sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(DailogueWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    float textHeight = [TQRichTextView getRechTextViewHeightWithText:messageStr viewWidth:textSize.width font:KQLSystemFont(16) lineSpacing:1.0f];
    //width需要稍微加大点，不然单个表情时会导致绘制长度计算错误
    textSize = CGSizeMake(textSize.width + 5,textHeight);
    return textSize;
}

- (void)freshWithInfoDic:(NSDictionary *)messageDic
{
    _msgTextView.text = [messageDic objectForKey:@"textMessage"];
    _msgTextView.lineSpacing = 1.0f;
    
    // 获取消息类容的Size大小
    CGSize textSize = [TextMessageCell getTextContentSizeFrom:messageDic];
    
    _msgTextView.frame = CGRectMake(10,10,textSize.width,textSize.height);
    
    //赋值messageContentView 背景sessionBackView 的大小将会根据这个view的大小来作调整
    _messageContentView = _msgTextView;
    
    //获取Cell的类型 用于判断自己发送还是别人发送从而确定消息框位置
    kSessionCellStyle freshSessionStyle = [[messageDic objectForKey:@"sessionStyle"]intValue];
    
    [super freshWithInfoDic:messageDic];
    
    if (freshSessionStyle == kSessionCellStyleSelf && _indicatorView != nil) {
        _indicatorView.frame = CGRectMake(_sessionBackView.frame.origin.x - _indicatorView.frame.size.width, CGRectGetMidY(_sessionBackView.frame) - _indicatorView.frame.size.width/2, _indicatorView.frame.size.width, _indicatorView.frame.size.height);
    } else if (freshSessionStyle == kSessionCellStyleOther) {
        _indicatorView.frame = CGRectMake(CGRectGetMaxX(_sessionBackView.frame) + _indicatorView.frame.size.width, CGRectGetMidY(_sessionBackView.frame) - _indicatorView.frame.size.width/2, _indicatorView.frame.size.width, _indicatorView.frame.size.height);
    }
}

// 将表情字符转换为正常字符长度
+ (NSString *)translateLengthStringFromEmoj:(NSString *)emojStr
{
//    NSString * markL = @"[";
//    NSString * markR = @"]";
//    NSRange leftRange;
//    NSRange rightRange;
//    NSMutableArray *needChangeRanges = [[NSMutableArray alloc]init];
//    
//    for (int i = 0; i < emojStr.length; i++) {
//        NSRange currentRange = NSMakeRange(i, 1);
//        NSString *subStr = [emojStr substringWithRange:currentRange];
//        
//        if ([subStr isEqualToString:markL]) {
//            leftRange = currentRange;
//        }
//        
//        if (leftRange.location != 0 && [subStr isEqualToString:markR]) {
//            rightRange = currentRange;
//            [needChangeRanges addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:leftRange.location],@"location",[NSNumber numberWithInt:rightRange.location - leftRange.location +1],@"length", nil]];
//        }
//    }
//    NSMutableString * finalString = nil;
//    if (emojStr != nil) {
//      finalString = [NSMutableString stringWithString:emojStr];
//    }
//    
//    for (int j = needChangeRanges.count-1;j>=0;j--) {
//        NSDictionary *tempDic = [needChangeRanges objectAtIndex:j];
//        NSRange changeRange = NSMakeRange([[tempDic objectForKey:@"location"]intValue] , [[tempDic objectForKey:@"length"]intValue]);
//        [finalString replaceCharactersInRange:changeRange withString:@"aaa"];
//    }
//    
//    RELEASE_SAFE(needChangeRanges);
//    return finalString;
    NSMutableArray * changeRangeArr = [NSMutableArray arrayWithCapacity:3];
    NSMutableString * resultStr = [NSMutableString stringWithString:emojStr];
    
    [TQRichTextEmojiRun analyzeText:emojStr runsArray:&changeRangeArr];
    for (TQRichTextEmojiRun * textEmojiRunObj in changeRangeArr) {
        [resultStr replaceOccurrencesOfString:textEmojiRunObj.originalText
                                   withString:@"aa]"
                                      options:NSLiteralSearch
                                        range:NSMakeRange(0, [resultStr length])];
    }
    return resultStr;
}

- (void)dealloc
{
    RELEASE_SAFE(_userName);
    RELEASE_SAFE(_timeLabel);
    RELEASE_SAFE(_headImgView);
    RELEASE_SAFE(_sessionBackView);
    RELEASE_SAFE(_sessionImageSelf);
    RELEASE_SAFE(_sessionImageOther);
    LOG_RELESE_SELF;
    [super dealloc];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
