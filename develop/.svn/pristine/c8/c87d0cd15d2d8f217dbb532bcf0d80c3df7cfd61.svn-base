//
//  wantHaveInfoCell.m
//  ql
//
//  Created by yunlai on 14-6-18.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "wantHaveInfoCell.h"
#import "wantHaveData.h"
#import "MessageData.h"



@implementation wantHaveInfoCell

+ (float)caculateCellHeighFrom:(NSDictionary *)messageDic
{
    return 110.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

-(void) setup{
    _contentV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _contentV.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_contentV];
    
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(110.f, 5, timeLabelWidth, timeLabelHight)];
    _timeLab.font = KQLSystemFont(SessionViewTimeFront);
    _timeLab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    _timeLab.layer.opacity = 0.7;
    _timeLab.textAlignment = NSTextAlignmentCenter;
    [_contentV addSubview:_timeLab];
    
    UIImageView* bgImageV = [[UIImageView alloc] init];
    bgImageV.frame = CGRectMake(30, 30, self.bounds.size.width - 30*2, 80);
    bgImageV.image = [IMG(@"bg_common_dialog") stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [_contentV addSubview:bgImageV];
    
    whImageV = [[UIImageView alloc] init];
    whImageV.frame = CGRectMake(CGRectGetMinX(bgImageV.frame) + 10, CGRectGetMinY(bgImageV.frame) + 10, 60, 60);
    [_contentV addSubview:whImageV];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(whImageV.frame) + 10, CGRectGetMinY(whImageV.frame) + 5, 160, 15);
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = KQLboldSystemFont(16);
    [_contentV addSubview:self.titleLabel];
    
    _contentLab = [[UILabel alloc] init];
    _contentLab.frame = CGRectMake(CGRectGetMaxX(whImageV.frame) + 10, CGRectGetMaxY(self.titleLabel.frame), 160, 40);
    _contentLab.backgroundColor = [UIColor clearColor];
    _contentLab.textAlignment = NSTextAlignmentLeft;
    _contentLab.textColor = [UIColor darkGrayColor];
    _contentLab.font = KQLboldSystemFont(14);
    _contentLab.numberOfLines = 2;
    _contentLab.lineBreakMode = UILineBreakModeWordWrap;
    [_contentV addSubview:_contentLab];
    
    [bgImageV release];
}

- (void)freshWithInfoDic:(NSDictionary *)messageDic
{
    self.contentLab.text = [messageDic objectForKey:@"wantHaveMessage"];
    NSNumber * timeNum = [messageDic objectForKey:@"time"];
    NSString * timeStr = [Common makeSessionViewHumanizedTimeForWithTime:timeNum.doubleValue];
    self.timeLab.text = timeStr;
    MessageData * message = [messageDic objectForKey:@"msgObject"];
    wantHaveData * wantHave = (wantHaveData *) message.msgData;
    
    switch (wantHave.type) {
        case PersonMessageHave:
        {
            self.titleLabel.text = @"我有";
            whImageV.image = IMGREADFILE(@"ico_feed_have.png");
        }
            break;
        case PersonMessageWant:
        {
            self.titleLabel.text = @"我要";
            whImageV.image = IMGREADFILE(@"ico_feed_want.png");
        }
            break;
            default:
            break;
    }

}

-(void) dealloc{
    RELEASE_SAFE(_contentV);
    RELEASE_SAFE(_contentLab);
    RELEASE_SAFE(whImageV);
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
