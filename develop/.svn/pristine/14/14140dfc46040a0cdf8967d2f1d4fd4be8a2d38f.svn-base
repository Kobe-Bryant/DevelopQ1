//
//  TogetherCell.m
//  ql
//
//  Created by yunlai on 14-8-20.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TogetherCell.h"
#import "TogetherData.h"
#import "MessageData.h"

@implementation TogetherCell

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
    UIView* contentV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    contentV.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:contentV];
    
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, timeLabelWidth, timeLabelHight)];
    _timeLab.font = KQLSystemFont(SessionViewTimeFront);
    _timeLab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    _timeLab.layer.opacity = 0.7;
    _timeLab.textAlignment = NSTextAlignmentCenter;
    [contentV addSubview:_timeLab];
    
    UIImageView* bgImageV = [[UIImageView alloc] init];
    bgImageV.frame = CGRectMake(30, 30, self.bounds.size.width - 30*2, 80);
    bgImageV.image = [IMG(@"bg_common_dialog") stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [contentV addSubview:bgImageV];
    
    UIImageView* whImageV = [[UIImageView alloc] init];
    whImageV.frame = CGRectMake(CGRectGetMinX(bgImageV.frame) + 10, CGRectGetMinY(bgImageV.frame) + 10, 60, 60);
    whImageV.image = IMG(@"ico_common_party");
    [contentV addSubview:whImageV];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(CGRectGetMaxX(whImageV.frame) + 10, CGRectGetMinY(whImageV.frame) + 5, 160, 15);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = KQLboldSystemFont(16);
    titleLabel.text = @"聚聚";
    [contentV addSubview:titleLabel];
    
    _contentLab = [[UILabel alloc] init];
    _contentLab.frame = CGRectMake(CGRectGetMaxX(whImageV.frame) + 10, CGRectGetMaxY(titleLabel.frame), 160, 40);
    _contentLab.backgroundColor = [UIColor clearColor];
    _contentLab.textAlignment = NSTextAlignmentLeft;
    _contentLab.textColor = [UIColor darkGrayColor];
    _contentLab.font = KQLboldSystemFont(14);
    _contentLab.numberOfLines = 2;
    _contentLab.lineBreakMode = UILineBreakModeWordWrap;
    [contentV addSubview:_contentLab];
    
    [bgImageV release];
    [whImageV release];
    [titleLabel release];
    [contentV release];
}

- (void)freshWithInfoDic:(NSDictionary *)messageDic
{
    NSNumber * timeNum = [messageDic objectForKey:@"time"];
    NSString * timeStr = [Common makeSessionViewHumanizedTimeForWithTime:timeNum.doubleValue];
    self.timeLab.text = timeStr;
    
    self.contentLab.text = [messageDic objectForKey:@"togetherMessage"];
    self.timeLab.text = timeStr;
    
}

-(void) dealloc{
    RELEASE_SAFE(_timeLab);
    RELEASE_SAFE(_contentLab);
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
