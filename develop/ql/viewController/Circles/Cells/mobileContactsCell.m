//
//  mobileContactsCell.m
//  ql
//
//  Created by yunlai on 14-3-19.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "mobileContactsCell.h"

#define kMargin 10.f
#define kControlWH 40.f

@implementation mobileContactsCell
@synthesize checkIcon = _checkIcon;
@synthesize headImage = _headImage;
@synthesize nameLabel = _nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(kMargin, kMargin, kControlWH, kControlWH)];
        _headImage.layer.cornerRadius = 20;
        _headImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImage];
        
        _checkIcon = [[UIImageView alloc]initWithFrame:CGRectMake(KUIScreenWidth - kMargin * 5, kMargin * 2, kControlWH, kControlWH)];
        [self.contentView addSubview:_checkIcon];
        
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+CGRectGetMaxX(_headImage.frame), 15, 200, 30)];
        _nameLabel.backgroundColor = [UIColor clearColor];
//        _nameLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _nameLabel.textColor = COLOR_GRAY2;
        [self.contentView addSubview:_nameLabel];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
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
