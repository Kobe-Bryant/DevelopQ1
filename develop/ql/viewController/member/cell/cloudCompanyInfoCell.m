//
//  cloudCompanyInfoCell.m
//  ql
//
//  Created by yunlai on 14-2-27.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "cloudCompanyInfoCell.h"
#import "config.h"

@implementation cloudCompanyInfoCell
@synthesize iconImage = _iconImage;
@synthesize orgLabel = _orgLabel;
@synthesize positionLabel = _positionLabel;
@synthesize bgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        bgView = [[UIView alloc]initWithFrame:CGRectMake(5.f, 5.f, KUIScreenWidth - 10.f, 90.f)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(5.f, 7.f, 100.f, 20)];
//        tips.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        tips.textColor = COLOR_GRAY2;
        tips.text = @"公司信息";
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
        
        _orgLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.f, 40.f, 200.f, 20.f)];
        _orgLabel.backgroundColor = [UIColor clearColor];
        _orgLabel.font = KQLSystemFont(15);
//        _orgLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _orgLabel.textColor = COLOR_GRAY2;
        [bgView addSubview:_orgLabel];
        
        _positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.f, 60.f, 200.f, 20.f)];
        _positionLabel.backgroundColor = [UIColor clearColor];
        _positionLabel.font = KQLSystemFont(14);
//        _positionLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY"];
        _positionLabel.textColor = COLOR_GRAY;
        [bgView addSubview:_positionLabel];
        
        [self addSubview:bgView];
    }
    return self;
}


- (void)dealloc
{
    RELEASE_SAFE(_positionLabel);
    RELEASE_SAFE(_orgLabel);
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
