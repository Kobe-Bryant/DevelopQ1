//
//  personalCell.m
//  ql
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "personalCell.h"
#import <QuartzCore/QuartzCore.h>
#define ktopPadding 15.f
#define kpadding 10.f


@implementation personalCell
@synthesize headView = _headView;
@synthesize userName = _userName;
@synthesize markLabel = _markLabel;
@synthesize positionLabel = _positionLabel;
@synthesize inviteBtn = _inviteBtn;
@synthesize companyLabel = _companyLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 头像
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(kpadding, 7.f, 45, 45)];
        _headView.userInteractionEnabled = YES;
        _headView.layer.cornerRadius = 23;
        _headView.clipsToBounds = YES;
        _headView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_headView];
        
        // 消息提示
        _markLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + 10, 25.f, 10, 10)];
        _markLabel.backgroundColor = [UIColor redColor];
        _markLabel.layer.cornerRadius = 5;
        _markLabel.clipsToBounds = YES;
        _markLabel.hidden = YES;
        [self.contentView addSubview:_markLabel];
        
        // 姓名
        _userName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + ktopPadding +kpadding, ktopPadding , 65, 30)];
        _userName.backgroundColor = [UIColor clearColor];
        _userName.font = KQLboldSystemFont(16);
//        _userName.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY"];
        _userName.textColor = COLOR_GRAY;
        _userName.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_userName];
        
        // 职称
        _positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_headView.frame) + CGRectGetWidth(_userName.frame) + ktopPadding , ktopPadding, 100, 30)];
        _positionLabel.backgroundColor = [UIColor clearColor];
//        _positionLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _positionLabel.textColor = COLOR_GRAY2;
        _positionLabel.font = KQLSystemFont(16);
        _positionLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_positionLabel];
        
        // 公司信息
        _companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + ktopPadding +kpadding, CGRectGetMaxY(_userName.frame) - 5, 180, 18)];
        _companyLabel.backgroundColor = [UIColor clearColor];
        _companyLabel.textColor = [UIColor grayColor];
        _companyLabel.font = KQLSystemFont(13);
        _companyLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_companyLabel];
        
        // 邀请
        _inviteBtn = [CircleCellEditButton buttonWithType:UIButtonTypeCustom];
        _inviteBtn.frame = CGRectMake(KUIScreenWidth - 80.f, ktopPadding, 60.f, 30.f);
        _inviteBtn.backgroundColor = COLOR_CONTROL;
        _inviteBtn.layer.cornerRadius = 5;
        _inviteBtn.titleLabel.font = KQLSystemFont(14);
        
        [self.contentView addSubview:_inviteBtn];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 59.5f, KUIScreenWidth, 0.5f)];
//        line.backgroundColor = RGBACOLOR(46, 50, 56, 0.9);
        line.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
        [self.contentView addSubview:line];
        RELEASE_SAFE(line);
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(_markLabel);
    RELEASE_SAFE(_headView);
    RELEASE_SAFE(_positionLabel);
    RELEASE_SAFE(_userName);
    RELEASE_SAFE(_companyLabel);
    [super dealloc];
}

- (void)inviteButtonIsHidden:(BOOL)hidden{
    if (hidden) {
        [_inviteBtn setHidden:YES];
    }else{
        [_inviteBtn setHidden:NO];
    }
}

- (void)setButtonTitleType:(MemberlistType)type isInvite:(BOOL)mark{
    switch (type) {
        case MemberlistTypeOrg:
        {
            if (mark == 0) {
                [_inviteBtn setTitle:@"邀请" forState:UIControlStateNormal];
                [_inviteBtn setBackgroundColor:COLOR_CONTROL];
                [_inviteBtn setEnabled:YES];
                [_inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                [_inviteBtn setTitle:@"已邀请" forState:UIControlStateNormal];
                [_inviteBtn setBackgroundColor:[UIColor clearColor]];
                [_inviteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [_inviteBtn setEnabled:NO];
            }
        }
            break;
        case MemberlistTypeCircle:
        {
            [_inviteBtn setTitle:@"编辑" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)setCellStyleShowMsg:(int)messages company:(NSString *)companys tips:(NSString *)markTitle{
    if (messages ==1) {
        if ([companys isEqualToString:@""]) {
            _markLabel.frame = CGRectMake(CGRectGetMaxY(_headView.frame) + 10, 25.f, 10, 10);
            _userName.frame = CGRectMake(CGRectGetMaxY(_headView.frame) + ktopPadding +kpadding, ktopPadding, 65, 30);
            _positionLabel.frame = CGRectMake(CGRectGetWidth(_headView.frame) + CGRectGetWidth(_userName.frame) + kpadding * 2 , ktopPadding, 100, 30);
            _companyLabel.frame = CGRectZero;
        }else{
            
            _markLabel.frame = CGRectMake(CGRectGetMaxY(_headView.frame) + 10, 15.f, 10, 10);
            _userName.frame = CGRectMake(CGRectGetMaxY(_headView.frame) + ktopPadding +kpadding, 5.f, 65, 30);
            _positionLabel.frame = CGRectMake(CGRectGetWidth(_headView.frame) + CGRectGetWidth(_userName.frame) + kpadding * 2 , 5.f, 100, 30);
            _companyLabel.frame = CGRectMake(CGRectGetMaxY(_headView.frame) + kpadding , CGRectGetMaxY(_userName.frame), 200, 18);
            
        }
    }else{
        if ([companys isEqualToString:@""]) {
            _markLabel.frame = CGRectZero;
            _userName.frame = CGRectMake(CGRectGetMaxY(_headView.frame) + ktopPadding, ktopPadding, 65, 30);
            _positionLabel.frame = CGRectMake(CGRectGetWidth(_headView.frame) + CGRectGetWidth(_userName.frame) + ktopPadding, ktopPadding, 100, 30);
            _companyLabel.frame = CGRectZero;
            
        }else{
            _markLabel.frame = CGRectZero;
            _userName.frame = CGRectMake(CGRectGetMaxY(_headView.frame) + ktopPadding, 5.f, 65, 30);
            _positionLabel.frame = CGRectMake(CGRectGetWidth(_headView.frame) + CGRectGetWidth(_userName.frame) +ktopPadding, 5.f, 100, 30);
            _companyLabel.frame = CGRectMake(CGRectGetMaxY(_headView.frame) + ktopPadding, CGRectGetMaxY(_userName.frame), 200, 18);
        }
    }
    _companyLabel.text = companys;
    _positionLabel.text = markTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
