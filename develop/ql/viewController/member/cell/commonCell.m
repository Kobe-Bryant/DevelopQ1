//
//  commonCell.m
//  ql
//
//  Created by yunlai on 14-2-26.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "commonCell.h"

@implementation commonCell
@synthesize iconView = _iconView;
@synthesize textLabel = _textLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(5.f, 5.f, 30, 30)];
        _iconView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconView];
        
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_iconView.frame) + 10, 10.0f, 200.f, 20)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor colorWithRed:66/255.0 green:67/255.0 blue:78/255.0 alpha:1.f];
        _textLabel.font = KQLSystemFont(15);
        [self.contentView addSubview:_textLabel];
        
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(_iconView);
    RELEASE_SAFE(_textLabel);
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
