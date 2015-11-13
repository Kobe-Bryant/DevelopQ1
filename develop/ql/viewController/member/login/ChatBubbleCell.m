//
//  ChatBubbleCell.m
//  ql
//
//  Created by yunlai on 14-4-15.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "ChatBubbleCell.h"

@implementation ChatBubbleCell
@synthesize contentL = _contentL;
@synthesize headerImageView = _headerImageView;
@synthesize timeLabel = _timeLabel;
@synthesize imageBgView = _imageBgView;
@synthesize bgView = _bgView;

@synthesize type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _bgView = [[UIView alloc] init];
        _bgView.tag = 'v';
        
        _imageBgView = [[UIImageView alloc] init];
        _imageBgView.tag = 'i';
        [_bgView addSubview:_imageBgView];
        
        
        _contentL = [[UILabel alloc] init];
        _contentL.frame = CGRectZero;
        _contentL.numberOfLines = 0;
        _contentL.font = [UIFont systemFontOfSize:16];
        _contentL.backgroundColor = [UIColor clearColor];
        _contentL.tag = 'l';
//        _contentL.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _contentL.textColor = COLOR_GRAY2;
        _contentL.textAlignment = NSTextAlignmentLeft;
        [_bgView addSubview:_contentL];
        
        
        [self.contentView addSubview:_bgView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        _timeLabel.text = @"";
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.tag = 1;
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
       
        
//        TalkStatusView *talkView = [[TalkStatusView alloc] initWithFrame:CGRectMake(400, 0, 20, 20)];
//        talkView.tag = 't';
//        [self.contentView addSubview:talkView];
//        [talkView release];
        
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.tag = 'a';
        [self.contentView addSubview:_headerImageView];
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.cornerRadius = 25;
      
    
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)dealloc
{
    RELEASE_SAFE(_imageBgView);
    RELEASE_SAFE(_contentL);
    RELEASE_SAFE(_headerImageView);
    RELEASE_SAFE(_timeLabel);
    RELEASE_SAFE(_bgView);
    [super dealloc];
}

- (void)setupInternalData{
    
//    float x = (type == BubbleTypeSomeoneElse) ? 20 : self.frame.size.width - 20 - self.dataInternal.labelSize.width;
//    float y = 5 + (self.dataInternal.header ? 30 : 0);
//    
//    contentLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
//    contentLabel.frame = CGRectMake(x, y, self.dataInternal.labelSize.width, self.dataInternal.labelSize.height);
//    contentLabel.text = self.dataInternal.data.text;
//    
//    if (type == BubbleTypeSomeoneElse)
//    {
//        bubbleImage.image = [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
//        bubbleImage.frame = CGRectMake(x - 18, y - 4, self.dataInternal.labelSize.width + 30, self.dataInternal.labelSize.height + 15);
//    }
//    else {
//        bubbleImage.image = [[UIImage imageNamed:@"bubbleMine.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:14];
//        bubbleImage.frame = CGRectMake(x - 9, y - 4, self.dataInternal.labelSize.width + 26, self.dataInternal.labelSize.height + 15);
//    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
