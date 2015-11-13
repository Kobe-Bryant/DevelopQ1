//
//  userInfoCell.m
//  ql
//
//  Created by yunlai on 14-2-26.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "userInfoCell.h"

#define kleftPadding 20.f
#define kpadding 15.f

@implementation userInfoCell
@synthesize usernameLabel = _usernameLabel;
@synthesize userPosition = _userPosition;
@synthesize headView = _headView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(kpadding, kpadding - 3, 60, 60)];
        _headView.userInteractionEnabled = YES;
        _headView.layer.cornerRadius = 30;
        _headView.clipsToBounds = YES;
        _headView.layer.borderColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"].CGColor;
        _headView.layer.borderWidth = 1.5;
        _headView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_headView];
        
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + kleftPadding, kpadding, 200, 30)];
        _usernameLabel.backgroundColor = [UIColor clearColor];
        _usernameLabel.font = KQLboldSystemFont(20);
        [self.contentView addSubview:_usernameLabel];
        
        
        _userPosition = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + kleftPadding, CGRectGetMaxY(_usernameLabel.frame) + 5, 200, 30)];
        _userPosition.backgroundColor = [UIColor clearColor];
//        _userPosition.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY"];
        _userPosition.textColor = COLOR_GRAY;
        _userPosition.font = KQLSystemFont(16);
        _userPosition.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_userPosition];
        
        
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(_userPosition);
    RELEASE_SAFE(_headView);
    RELEASE_SAFE(_usernameLabel);
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
