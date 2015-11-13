//
//  memberInfoCell.m
//  ql
//
//  Created by yunlai on 14-4-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "memberInfoCell.h"

#define kPadding 10.f

@implementation memberInfoCell
@synthesize txtLabel = _txtLabel;
@synthesize signLabel = _signLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _signLabel = [[UILabel alloc]initWithFrame:CGRectMake(kPadding, 5.f, 60.f, 30.f)];
        
        [self.contentView addSubview:_signLabel];
        
        _txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(kPadding + 65.f, 5.f, 240.f, 30.f)];
        
        [self.contentView addSubview:_txtLabel];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)dealloc
{
    RELEASE_SAFE(_signLabel);
    RELEASE_SAFE(_txtLabel);
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
