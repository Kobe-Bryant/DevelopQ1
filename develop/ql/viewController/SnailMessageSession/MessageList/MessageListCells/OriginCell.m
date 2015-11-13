//
//  originCell.m
//  ql
//
//  Created by LazySnail on 14-4-27.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "SBJson.h"
#import "OriginCell.h"
#import "OriginData.h"
#import "TextData.h"
#import "CustomEmotionData.h"

#import "UIImageView+WebCache.h"
#import "PersonalMessageCell.h"
#import "CircleMessageCell.h"

@interface OriginCell ()
{
    
}

@property (nonatomic , retain) UIImageView *headView;
@property (nonatomic , retain) UILabel *markLabel;
@property (nonatomic , retain) UILabel *title;
@property (nonatomic , retain) UILabel *msgLabel;
@property (nonatomic , retain) UILabel *timeLabel;

@end

@implementation OriginCell
{
}
@synthesize headView = _headView;
@synthesize timeLabel = _timeLabel;
@synthesize markLabel = _markLabel;
@synthesize msgLabel = _msgLabel;

+ (OriginCell *)cellFromListDic:(NSDictionary *)dic andTableView:(UITableView *)tableView
{
    MessageListType talkType = [[dic objectForKey:@"talk_type"]intValue];
    NSString * reuseIdentifyStr = nil;
    OriginCell * cell = nil;
    switch (talkType) {
        case MessageListTypePerson:
        case MessageListTypeWant:
        case MessageListTypeHave:
        {
            reuseIdentifyStr = @"PersonalCellIdentify";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifyStr];
            if (cell == nil) {
                cell = [[[PersonalMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifyStr]autorelease];
            }
        }
            break;
        case MessageListTypeCircle:
        case MessageListTypeTempCircle:
        {
            reuseIdentifyStr = @"CircleCellIdentify";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifyStr];
            if (cell == nil) {
                cell = [[[CircleMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifyStr]autorelease];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(kpadding, kpadding, 50, 50)];
        _headView.userInteractionEnabled = YES;
        _headView.layer.cornerRadius = 25;
        _headView.clipsToBounds = YES;
        _headView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_headView];
        
        _markLabel = [[UILabel alloc]initWithFrame:CGRectMake(kpadding + 45.f, kpadding + 8, 16, 16)];
        _markLabel.backgroundColor = [UIColor redColor];
        _markLabel.textColor = [UIColor whiteColor];
        _markLabel.layer.cornerRadius = 8;
        _markLabel.clipsToBounds = YES;
        _markLabel.textAlignment = NSTextAlignmentCenter;
        _markLabel.hidden = YES;
        _markLabel.font = KQLSystemFont(14);
        
        [self.contentView addSubview:_markLabel];
        
        UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + kleftPadding, kpadding, 150, 30)];
        self.title = titleLable;
        self.title.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = KQLboldSystemFont(17);
        [self.contentView addSubview:self.title];
        RELEASE_SAFE(titleLable);
        
        _msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + kleftPadding, CGRectGetMaxY(self.title.frame) - 5, 200, 30)];
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
        _msgLabel.layer.opacity = 0.7;
        _msgLabel.font = KQLSystemFont(13);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_msgLabel];
        
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(KUIScreenWidth - 110.f, kpadding - 5, 105, 30)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = KQLboldSystemFont(13);
        _timeLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
        _timeLabel.layer.opacity = 0.7;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)freshWithInfoDic:(NSDictionary *)messageDic
{
    //获取消息数据类型 并刷新名称、时间、消息等类容
    NSString *contentJsonStr = [messageDic objectForKey:@"content"];
    NSArray *dataArr = [contentJsonStr JSONValue];
    NSDictionary *firstDataDic = [dataArr firstObject];
    
    OriginData * sessionData = [OriginData generateInstantDataWithDic:firstDataDic];
    
    //booky 8.28 name:[...]
    NSString* msgLabelStr = nil;
    
    switch (sessionData.objtype) {
        case dataTypeText:
        {
            TextData * textData = (TextData *)sessionData;
//            self.msgLabel.text = textData.txt;
            msgLabelStr = textData.txt;
        }
            break;
        case dataTypePicture:
        {
//            self.msgLabel.text = @"收到图片消息";
//            self.msgLabel.text = [NSString stringWithFormat:@"%@:%@",[messageDic objectForKey:@"speak_name"],@"图片"];
            msgLabelStr = @"[图片]";
        }
            break;
        case dataTypeVoice:
        {
//            self.msgLabel.text = @"收到语音消息";
//            self.msgLabel.text = [NSString stringWithFormat:@"%@:%@",[messageDic objectForKey:@"speak_name"],@"语音"];
            msgLabelStr = @"[语音]";
        }
            break;
        case dataTypeWantHave:
        {
//            self.msgLabel.text = @"收到我有我要消息";
            msgLabelStr = @"[我有我要消息]";
        }
            break;
        case dataTypeCustomEmotion:
        {
            CustomEmotionData * data = (CustomEmotionData *)sessionData;
            msgLabelStr = [NSString stringWithFormat:@"[%@]",data.title];
        }
            break;
        case dataTypeTogether:
        {
            msgLabelStr = @"[聚聚消息]";
        }
            break;
        default:
        {
            msgLabelStr = @"新消息";
        }
            break;
    }
    
    long long user_id = [[messageDic objectForKey:@"speak_id"] longLongValue];
    
    if (msgLabelStr.length != 0)
    {
        if (user_id == [[Global sharedGlobal].user_id longLongValue] || [[messageDic objectForKey:@"talk_type"]intValue] == MessageListTypePerson) {
            self.msgLabel.text = msgLabelStr;
        }else {
            NSString* speak_name = [messageDic objectForKey:@"speak_name"];
            if (speak_name.length == 0) {
                self.msgLabel.text = msgLabelStr;
            }else{
                self.msgLabel.text = [NSString stringWithFormat:@"%@:%@",[messageDic objectForKey:@"speak_name"],msgLabelStr];
            }
        }
    }
   
    self.title.text = [messageDic objectForKey:@"title"];
    NSNumber *sendTimeNum = [messageDic objectForKey:@"send_time"];
    self.timeLabel.text = [Common makeMessageListHumanizedTimeForWithTime:sendTimeNum.doubleValue];
    
    NSNumber *unreadNum = [messageDic objectForKey:@"unreaded"];
    if (unreadNum.intValue > 0) {
        self.markLabel.hidden = NO;
        self.markLabel.text = [NSString stringWithFormat:@"%d",unreadNum.intValue];
    } else {
        self.markLabel.hidden = YES;
        self.markLabel.text = nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
   return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (void)dealloc
{
    RELEASE_SAFE(_markLabel);
    RELEASE_SAFE(_headView);
    RELEASE_SAFE(_timeLabel);
    RELEASE_SAFE(_msgLabel);
    LOG_RELESE_SELF;
    [super dealloc];
}
@end
