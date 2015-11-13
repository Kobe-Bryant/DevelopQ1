//
//  YLNameCardCell.m
//  CardHolderDemo
//
//  Created by yunlai on 14-1-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "YLNameCardCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation YLNameCardCell
@synthesize checkIcon = _checkIcon;
@synthesize headImage = _headImage;
@synthesize nameLabel = _nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _checkIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 15, 15)];
        _checkIcon.image = [UIImage imageNamed:@"input_未选中"];
        [self.contentView addSubview:_checkIcon];
        
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10+CGRectGetMaxX(_checkIcon.frame), 10, 40, 40)];
        _headImage.layer.cornerRadius = 20;
        _headImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+CGRectGetMaxX(_headImage.frame), 15, 200, 30)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLabel];
        
        // 分割线
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 59.f, KUIScreenWidth, 1.5f)];
        line.backgroundColor = RGBACOLOR(46, 50, 56, 0.9);
        [self.contentView addSubview:line];
        RELEASE_SAFE(line);
    }
    return self;
}

- (void)dealloc
{
    [_checkIcon release];
    [_headImage release];
    [_nameLabel release];
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
