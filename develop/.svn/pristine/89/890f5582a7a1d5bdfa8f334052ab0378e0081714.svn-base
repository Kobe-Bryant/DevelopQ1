//
//  choiceLMCell.m
//  ql
//
//  Created by yunlai on 14-4-3.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "choiceLMCell.h"

@implementation choiceLMCell

@synthesize selectImgV = _selectImgV;
@synthesize userHearV = _userHearV;
@synthesize userNameLab = _userNameLab;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //盖掉选中
        UIView* v = [[UIView alloc] initWithFrame:CGRectZero];
        v.backgroundColor = [UIColor clearColor];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 59.5f, KUIScreenWidth, 0.5)];
        line.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
        [v addSubview:line];
        RELEASE_SAFE(line);
        
        [self setSelectedBackgroundView:v];
        RELEASE_SAFE(v);
        
        [self setup];
    }
    return self;
}

//配置视图
-(void) setup{
    _selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, (60-20)/2, 20, 20)];
    _selectImgV.image = [[ThemeManager shareInstance] getThemeImage:@"btn_group_select.png"];
    _selectImgV.highlightedImage = [[ThemeManager shareInstance] getThemeImage:@"btn_group_select_blue.png"];
    [self.contentView addSubview:_selectImgV];
    
    _userHearV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectImgV.frame) + 15, 10, 40, 40)];
    _userHearV.layer.cornerRadius = _userHearV.bounds.size.height/2;
    [_userHearV.layer setMasksToBounds:YES];
    [self.contentView addSubview:_userHearV];
    
    _userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHearV.frame) + 10, CGRectGetMinY(_userHearV.frame), 200, 20)];
    _userNameLab.font = [UIFont systemFontOfSize:15];
    _userNameLab.textAlignment = NSTextAlignmentLeft;
    _userNameLab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    _userNameLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_userNameLab];
    
    _company_nameLab = [[UILabel alloc] init];
    _company_nameLab.frame = CGRectMake(CGRectGetMinX(_userNameLab.frame), CGRectGetMaxY(_userNameLab.frame), 200, 20);
    _company_nameLab.textAlignment = NSTextAlignmentLeft;
    _company_nameLab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    _company_nameLab.layer.opacity = 0.7;
    _company_nameLab.font = KQLboldSystemFont(12);
    _company_nameLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_company_nameLab];
    
}
// chenfeng 5.9 add 隐藏选择图标
- (void)hiddenSelectImgv{
    _selectImgV.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) dealloc{
    RELEASE_SAFE(_company_nameLab);
    RELEASE_SAFE(_selectImgV);
    RELEASE_SAFE(_userNameLab);
    RELEASE_SAFE(_userHearV);
    [super dealloc];
}

@end
