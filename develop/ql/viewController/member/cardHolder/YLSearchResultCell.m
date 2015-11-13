//
//  YLSearchResultCell.m
//  ql
//
//  Created by yunlai on 14-5-10.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "YLSearchResultCell.h"

@implementation YLSearchResultCell

@synthesize userHearV = _userHearV;
@synthesize userNameLab = _userNameLab;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        UIView* v = [[UIView alloc] initWithFrame:self.frame];
//        v.backgroundColor = [UIColor clearColor];
//        [self setSelectedBackgroundView:v];
//        RELEASE_SAFE(v);
        [self setup];
    }
    return self;
}

-(void) setup{

    _userHearV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    _userHearV.layer.cornerRadius = _userHearV.bounds.size.height/2;
    [_userHearV.layer setMasksToBounds:YES];
    [self.contentView addSubview:_userHearV];
    
    _userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHearV.frame) + 10, CGRectGetMinY(_userHearV.frame), 200, 30)];
    _userNameLab.font = [UIFont systemFontOfSize:15];
    _userNameLab.textAlignment = NSTextAlignmentLeft;
    _userNameLab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
//    _userNameLab.textColor = COLOR_GRAY2;
    _userNameLab.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:_userNameLab];
    
    _company_nameLab = [[UILabel alloc] init];
    _company_nameLab.frame = CGRectMake(CGRectGetMinX(_userNameLab.frame), CGRectGetMaxY(_userNameLab.frame), 200, 20);
    _company_nameLab.textAlignment = NSTextAlignmentLeft;
//    _company_nameLab.textColor = [UIColor darkGrayColor];
    _company_nameLab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    _company_nameLab.layer.opacity = 0.7;
    _company_nameLab.font = KQLboldSystemFont(12);
    _company_nameLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_company_nameLab];
    
//    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 59.f, KUIScreenWidth, 1.5f)];
//    line.backgroundColor = RGBACOLOR(46, 50, 56, 0.9);
//    [self.contentView addSubview:line];
//    RELEASE_SAFE(line);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) dealloc{
    RELEASE_SAFE(_company_nameLab);
    RELEASE_SAFE(_userNameLab);
    RELEASE_SAFE(_userHearV);
    [super dealloc];
}
@end
