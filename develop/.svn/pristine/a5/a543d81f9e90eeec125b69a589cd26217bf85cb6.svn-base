//
//  cloudIhaveCell.m
//  ql
//
//  Created by yunlai on 14-2-27.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "cloudIhaveCell.h"

@implementation cloudIhaveCell
@synthesize iconImage = _iconImage;
@synthesize supplyLabel = _supplyLabel;
@synthesize infoLabel = _infoLabel;
@synthesize bgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bgView = [[UIView alloc]initWithFrame:CGRectMake(5.f, 5.f, KUIScreenWidth - 10.f, 120.f)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(5.f, 7.f, 100.f, 20)];
//        tips.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        tips.textColor = COLOR_GRAY2;
        tips.text = @"我有我要";
        tips.font = KQLSystemFont(14);
        [bgView addSubview:tips];
        RELEASE_SAFE(tips);
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 30.f, bgView.frame.size.width, 1.f)];
//        line.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LINE"];
        line.backgroundColor = COLOR_LINE;
        [bgView addSubview:line];
        RELEASE_SAFE(line);
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 40.f, 40.f, 40.f)];
        _iconImage.backgroundColor = [UIColor grayColor];
        [bgView addSubview:_iconImage];
        
        _supplyLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.f, 40.f, 200.f, 20.f)];
        _supplyLabel.backgroundColor = [UIColor clearColor];
//        _supplyLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _supplyLabel.textColor = COLOR_GRAY2;
        _supplyLabel.font = KQLSystemFont(15);
        [bgView addSubview:_supplyLabel];
        
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.f, 55.f, 240.f, 60.f)];
        _infoLabel.backgroundColor = [UIColor clearColor];
//        _infoLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _infoLabel.textColor = COLOR_GRAY2;
        _infoLabel.numberOfLines = 2;
        _infoLabel.font = KQLSystemFont(13);
        [bgView addSubview:_infoLabel];
        
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(_infoLabel);
    RELEASE_SAFE(_supplyLabel);
    RELEASE_SAFE(_iconImage);
    RELEASE_SAFE(bgView);
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
