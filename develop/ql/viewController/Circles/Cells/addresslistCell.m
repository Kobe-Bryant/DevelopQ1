//
//  addresslistCell.m
//  ql
//
//  Created by yunlai on 14-3-8.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "addresslistCell.h"
#import "Global.h"

#define kMargin 10.f
#define kTopMargin 10.f

@implementation addresslistCell
@synthesize listName = _listName;
@synthesize iconView = _iconView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(kMargin, kTopMargin, 50, 50)];
        _iconView.layer.cornerRadius = 25;
        _iconView.clipsToBounds = YES;
        _iconView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_iconView];
        
        _listName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_iconView.frame) + kMargin * 2, kTopMargin + kMargin, 100, 30)];
        _listName.backgroundColor = [UIColor clearColor];
        _listName.font = KQLboldSystemFont(15);
//        _listName.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _listName.textColor = COLOR_GRAY2;
        [self.contentView addSubview:_listName];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 69.f, KUIScreenWidth, 1.f)];
        line.backgroundColor = RGBACOLOR(242, 244, 246, 1);
        [self.contentView addSubview:line];
        RELEASE_SAFE(line);
        
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(_iconView);
    RELEASE_SAFE(_listName);
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
