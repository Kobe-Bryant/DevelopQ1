//
//  companyInfoCell.m
//  ql
//
//  Created by yunlai on 14-2-28.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "companyInfoCell.h"

@implementation companyInfoCell
@synthesize timeInfo= _timeInfo;
@synthesize companyInfo = _companyInfo;
@synthesize dredgeBtn = _dredgeBtn;

#define kleftPadding 20.f
#define kpadding 15.f

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 70.f)];
        bgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:bgView];
        
        _companyInfo = [[UILabel alloc]initWithFrame:CGRectMake(15.f, 5.f, 300, 40)];
        _companyInfo.backgroundColor = [UIColor clearColor];
        _companyInfo.font = KQLSystemFont(15);
//        _companyInfo.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _companyInfo.textColor = COLOR_GRAY2;
        [bgView addSubview:_companyInfo];
        
        
        _timeInfo = [[UILabel alloc]initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_companyInfo.frame), 200, 20)];
        _timeInfo.backgroundColor = [UIColor clearColor];
        _timeInfo.font = KQLSystemFont(13);
//        _timeInfo.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _timeInfo.textColor = COLOR_GRAY2;
        [bgView addSubview:_timeInfo];
        
        RELEASE_SAFE(bgView);
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(_timeInfo);
    RELEASE_SAFE(_companyInfo);
    [super dealloc];
}

//未开通公司轻APP
- (void)noDredgeCompanyLightApp:(int)type{
    _companyInfo.hidden = YES;
    _timeInfo.hidden = YES;
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(20, 20.f, 80.f, 30.f)];
    tip.text = @"未开通";
    tip.font = KQLSystemFont(16);
    tip.backgroundColor = [UIColor clearColor];
//    tip.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
    tip.textColor = COLOR_GRAY2;
    [self.contentView addSubview:tip];
    
    _dredgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dredgeBtn.hidden = YES;
    _dredgeBtn.titleLabel.font = KQLSystemFont(16);
    if (type == 1) {
        [_dredgeBtn setTitle:@"邀请开通" forState:UIControlStateNormal];
        _dredgeBtn.hidden = YES;
    }else{
        [_dredgeBtn setTitle:@"申请开通" forState:UIControlStateNormal];
    }
    
    [_dredgeBtn setTitleColor:COLOR_CONTROL forState:UIControlStateNormal];
    
    [_dredgeBtn setFrame:CGRectMake(CGRectGetMaxY(tip.frame) + 20.f, 20.f, 100.f, 30.f)];
    [self.contentView addSubview:_dredgeBtn];
    
    RELEASE_SAFE(tip);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
