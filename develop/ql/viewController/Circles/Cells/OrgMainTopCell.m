//
//  OrgMainTopCell.m
//  ql
//
//  Created by yunlai on 14-3-13.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "OrgMainTopCell.h"

#define kMarginTop 40.f
#define kIconWH 80.f


@implementation OrgMainTopCell
@synthesize iconImage = _iconImage;
@synthesize orgName = _orgName;
@synthesize bgView = _bgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 190.f)];
        _bgView.backgroundColor = RGBACOLOR(121, 128, 119, 1);
        [self.contentView addSubview:_bgView];
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake((KUIScreenWidth - kIconWH)/2, kMarginTop, kIconWH, kIconWH)];
        _iconImage.layer.cornerRadius = 40;
        _iconImage.clipsToBounds = YES;
        [_bgView addSubview:_iconImage];
        
        _orgName = [[UILabel alloc]initWithFrame:CGRectMake((KUIScreenWidth - kIconWH)/2, CGRectGetMaxY(_iconImage.frame)+3, kIconWH, 30.f)];
        _orgName.textColor = [UIColor whiteColor];
        _orgName.font = KQLboldSystemFont(16);
        _orgName.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:_orgName];
        
        
        
        
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(_bgView);
    RELEASE_SAFE(_iconImage);
    RELEASE_SAFE(_orgName);
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
