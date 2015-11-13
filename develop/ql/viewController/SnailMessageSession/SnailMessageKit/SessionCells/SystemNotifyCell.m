//
//  SystemNotifyCell.m
//  ql
//
//  Created by LazySnail on 14-7-8.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "SystemNotifyCell.h"
#import "MessageData.h"

#define LRMargin            10
#define timeUpMargin        5
#define MessageFront        14
#define MessageStrMaxWidth  220.f

@interface SystemNotifyCell ()
{
    
}

@property (nonatomic, retain) UILabel * timeLabel;

@property (nonatomic, retain) UITextView * systemMsgTextView;

@end

@implementation SystemNotifyCell

+ (float)caculateCellHightWithMessageDic:(NSDictionary *)messageDic
{
    MessageData * msg = [messageDic objectForKey:@"msgObject"];
    CGSize strSize = [SystemNotifyCell caculateMessageSizeFromDic:messageDic andMaxWith:MessageStrMaxWidth];

    float appendHeight = 10 ;
    if ([[UIDevice currentDevice]systemVersion].intValue < 7.0) {
        appendHeight += appendHeight *0.9;
    }
    
    if (msg.showTimeSign){
        
        return timeLabelHight + strSize.height + appendHeight;
    } else {
        return strSize.height + appendHeight;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
                
        self.systemMsgTextView = [[UITextView alloc]initWithFrame:CGRectZero];
        self.systemMsgTextView.backgroundColor = [UIColor colorWithRed:201.f/255.f green:201.f/255.f blue:201.f/255.f alpha:1.0f];
        
        self.systemMsgTextView.textColor = [UIColor colorWithRed:255.0f/255.f green:255.f/255.f blue:255.f/255.f alpha:1.0f];
        self.systemMsgTextView.textAlignment = NSTextAlignmentCenter;
        self.systemMsgTextView.font = KQLSystemFont(MessageFront);
        self.systemMsgTextView.layer.cornerRadius = 5.f;
        self.systemMsgTextView.layer.masksToBounds = YES;
        self.systemMsgTextView.textColor = [UIColor whiteColor];
        self.systemMsgTextView.userInteractionEnabled = NO;
        self.systemMsgTextView.contentInset = UIEdgeInsetsMake(-4, 0, 0, 0);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.systemMsgTextView];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

+ (CGSize)caculateMessageSizeFromDic:(NSDictionary *)messageDic andMaxWith:(float)maxWidth
{
    MessageData * msgData = [messageDic objectForKey:@"msgObject"];
    NSString * systemMessageStr = [msgData.msgData valueForKey:@"txt"];
    
    
    CGSize strSize = [systemMessageStr sizeWithFont:KQLSystemFont(15) constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return strSize;
}

- (void)freshWithInfoDic:(NSDictionary *)messageDic
{
    MessageData * msgData = [messageDic objectForKey:@"msgObject"];
    
    self.systemMsgTextView.text = [msgData.msgData valueForKey:@"txt"];

    CGSize strSize = [SystemNotifyCell caculateMessageSizeFromDic:messageDic andMaxWith:MessageStrMaxWidth];
    
    float appendHeight = 10;
    if ([[UIDevice currentDevice]systemVersion].intValue < 7.0) {
        appendHeight = strSize.height * 0.3;
    }
    if (msgData.showTimeSign) {
        NSTimeInterval timeInterval = [[messageDic objectForKey:@"time"]doubleValue];
        NSString * timeStr = [Common makeSessionViewHumanizedTimeForWithTime:timeInterval];
        
        //发送时间
        self.timeLabel.frame = CGRectMake(KUIScreenWidth/2 - timeLabelWidth/2, - timeUpMargin, timeLabelWidth, timeLabelHight);
        self.timeLabel.hidden = NO;
        
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor colorWithRed:136.0f/225.0f green:136.0f/225.0f blue:136.0f/225.0f alpha:1.0f];
        _timeLabel.font = KQLSystemFont(SessionViewTimeFront);
        _timeLabel.text = timeStr;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.numberOfLines = 0;
        
        self.systemMsgTextView.frame = CGRectMake(KUIScreenWidth/2 - strSize.width/2 -5, CGRectGetMaxY(_timeLabel.frame), strSize.width + 10, strSize.height + appendHeight);
    } else {
        self.timeLabel.frame = CGRectZero;
        self.timeLabel.hidden = YES;
        
        self.systemMsgTextView.frame = CGRectMake(KUIScreenWidth/2 - strSize.width/2 - 5, 0, strSize.width + 10, strSize.height +appendHeight);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)dealloc
{
    RELEASE_SAFE(_timeLabel);
    LOG_RELESE_SELF;
    [super dealloc];
}
@end
