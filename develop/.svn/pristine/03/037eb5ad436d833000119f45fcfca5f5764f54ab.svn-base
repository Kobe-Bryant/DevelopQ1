//
//  MajorTableViewCell.m
//  ql
//
//  Created by Dream on 14-8-22.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "MajorTableViewCell.h"

@implementation MajorTableViewCell
@synthesize arrowImage;
@synthesize titleLable;
@synthesize iconImage;
@synthesize nameLable;
@synthesize lineImage;
@synthesize countLable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(95.f, 17.f, 20.f, 20.f)];
        self.iconImage.image = [[ThemeManager shareInstance] getThemeImage:@"ico_group_add.png"];
        self.iconImage.hidden = YES;
        [self addSubview:self.iconImage];
        
        
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(120.f, 12.f, 110.f, 30.f)];
        self.titleLable.text = @"创建私人圈子";
        self.titleLable.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.titleLable.hidden = YES;
        [self addSubview:self.titleLable];
        
        
        self.bidButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bidButton.frame = CGRectMake(0, 0,KUIScreenWidth , 60.0);
        [self.bidButton setImage:nil forState:UIControlStateDisabled];
        [self addSubview:self.bidButton];
        
        //箭头
        UIImage *arrowImg = [UIImage imageNamed:@"ico_group_arrow.png"];
        self.arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(285,(53 - arrowImg.size.height)/2 , arrowImg.size.width, arrowImg.size.height)];
        self.arrowImage.image = arrowImg;
        self.arrowImage.hidden = YES;
        [self addSubview:self.arrowImage];
        
        //部门名称
        self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(20.f, 11.0, 250.f, 30.f)];
        self.nameLable.backgroundColor = [UIColor clearColor];
        self.nameLable.font = [UIFont systemFontOfSize:16.0];
        self.nameLable.textColor = [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1];
        [self addSubview:self.nameLable];
        
        //人员个数
        self.countLable = [[UILabel alloc]initWithFrame:CGRectMake(self.arrowImage.frame.origin.x - 5, 11.0, 50.f, 30.f)];
        self.countLable.backgroundColor = [UIColor clearColor];
        self.countLable.font = [UIFont systemFontOfSize:16.0];
        self.countLable.textColor = [UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1];
        [self addSubview:self.countLable];
        
        //直线
        UIImage *lineImg = [UIImage imageNamed:@"img_group_underline.png"];
        self.lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 320, 0.5)];
        self.lineImage.image = lineImg;
        [self addSubview:self.lineImage];

}
    return self;
}

- (void)dealloc
{
    self.arrowImage = nil;
    self.iconImage = nil;
    self.titleLable = nil;
    self.nameLable = nil;
    self.lineImage = nil;
    self.countLable = nil;
    self.bidButton = nil;
    [super dealloc];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
