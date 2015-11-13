//
//  aboutCompanyCell.m
//  ql
//
//  Created by yunlai on 14-2-28.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "aboutCompanyCell.h"

@implementation aboutCompanyCell
@synthesize textView = _textView;
@synthesize contentLabel = _contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(10.f, 10.f, 300.f, 340.f)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(10.f, 0.f, 290.f, 340.f)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.editable = NO;
//        _textView.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _textView.textColor = COLOR_GRAY2;
        _textView.font = KQLSystemFont(15);
        [_bgView addSubview:_textView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, 300.f, 40.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = KQLSystemFont(22);
        titleLabel.text = @"关于我们";
        titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_bgView addSubview:titleLabel];
        
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(6.f, CGRectGetMaxY(titleLabel.frame), 280.f, _textView.frame.size.height - 40.f)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = KQLSystemFont(15);
//        _contentLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _contentLabel.textColor = COLOR_GRAY2;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_textView addSubview:_contentLabel];
        
        RELEASE_SAFE(titleLabel);
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(_contentLabel);
    RELEASE_SAFE(_bgView);
    RELEASE_SAFE(_textView);
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
