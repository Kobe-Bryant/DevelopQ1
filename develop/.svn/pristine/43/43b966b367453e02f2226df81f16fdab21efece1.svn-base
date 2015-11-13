//
//  myCompanyCell.m
//  ql
//
//  Created by yunlai on 14-4-16.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "myCompanyCell.h"

@implementation myCompanyCell
@synthesize iconV = _iconV;
@synthesize companyT = _companyT;
@synthesize browseCount = _browseCount;
@synthesize dredgeBtn = _dredgeBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconV = [[UIImageView alloc]initWithFrame:CGRectMake(10., 12.f, 45.f, 45.f)];
        _iconV.layer.cornerRadius = 5;
        _iconV.clipsToBounds = YES;
        [self.contentView addSubview:_iconV];
        
        _companyT = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_iconV.frame) + 10, 10.f, 200.f, 30.f)];
        _companyT.font = KQLSystemFont(16);
        _companyT.backgroundColor = [UIColor clearColor];
//        _companyT.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _companyT.textColor = COLOR_GRAY2;
        [self.contentView addSubview:_companyT];
        
        _browseCount = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_iconV.frame) + 10, 34.f, 200.f, 30.f)];
//        _browseCount.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY"];
        _browseCount.textColor = COLOR_GRAY;
        _browseCount.font = KQLSystemFont(13);
        _browseCount.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_browseCount];
        
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(_iconV);
    RELEASE_SAFE(_companyT);
    RELEASE_SAFE(_browseCount);
    [super dealloc];
}

//未开通公司轻APP
- (void)noDredgeCompanyLightApp:(int)type{
    _iconV.hidden = YES;
    _companyT.hidden = YES;
    _browseCount.hidden = YES;
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(20, 20.f, 80.f, 30.f)];
    tip.text = @"未开通";
    tip.tag = 100;
    tip.font = KQLSystemFont(16);
//    tip.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
    tip.textColor = COLOR_GRAY2;
    tip.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:tip];
    
    _dredgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dredgeBtn.titleLabel.font = KQLSystemFont(16);
    if (type == 1) {
        _dredgeBtn.hidden = YES;
        [_dredgeBtn setTitle:@"邀请开通" forState:UIControlStateNormal];
        _dredgeBtn.hidden = YES;
    }else{
        _dredgeBtn.hidden = NO;
        [_dredgeBtn setTitle:@"申请开通" forState:UIControlStateNormal];
    }
    
    [_dredgeBtn setTitleColor:COLOR_CONTROL forState:UIControlStateNormal];
    
    [_dredgeBtn setFrame:CGRectMake(CGRectGetMaxY(tip.frame) + 20.f, 20.f, 100.f, 30.f)];
    [self.contentView addSubview:_dredgeBtn];
    
    RELEASE_SAFE(tip);
    
}

- (void)hiddenNoDredgeCompanyLightApp {
    _dredgeBtn.hidden = YES;
    UILabel *tipLable = (UILabel *)[self.contentView viewWithTag:100];
    tipLable.hidden = YES;
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
