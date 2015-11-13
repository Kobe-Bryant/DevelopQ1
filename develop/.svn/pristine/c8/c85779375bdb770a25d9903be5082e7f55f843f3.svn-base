//
//  relevancyMobileCell.m
//  ql
//
//  Created by yunlai on 14-3-19.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "relevancyMobileCell.h"

#define kMargin 10.f
#define kControlWH 40.f

@implementation relevancyMobileCell
@synthesize detailLabel = _detailLabel;
@synthesize tipsLabel = _tipsLabel;
@synthesize iconView = _iconView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(kMargin, kMargin,kControlWH, kControlWH)];
        _iconView.layer.cornerRadius = 20;
        _iconView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconView];
        
        _tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_iconView.frame) + 15, 10.f,200.f, 25.f)];
        _tipsLabel.font = KQLSystemFont(15);
        [self.contentView addSubview:_tipsLabel];
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_iconView.frame) + 15, 30.f,200.f, 25.f)];
        _detailLabel.font = KQLSystemFont(13);
//        _detailLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY"];
        _detailLabel.textColor = COLOR_GRAY;
        [self.contentView addSubview:_detailLabel];
        
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(_iconView);
    RELEASE_SAFE(_tipsLabel);
    RELEASE_SAFE(_detailLabel);
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
