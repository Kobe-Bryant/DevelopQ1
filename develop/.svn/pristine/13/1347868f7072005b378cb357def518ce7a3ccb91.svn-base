//
//  AlertView.m
//  lable
//
//  Created by Dream on 14-7-9.
//  Copyright (c) 2014年 Yunlai-mac02. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView
@synthesize image = _image;
@synthesize lable = _lable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *iconView = [UIImage imageNamed:@"bg_landing_warning.png"];
        _image = [[UIImageView alloc]initWithImage:iconView];
        _image.frame = CGRectMake(0,3,iconView.size.width, iconView.size.height);
        [self addSubview:_image];
        [_image release];
        
        _lable = [[UILabel alloc]initWithFrame:CGRectMake(_image.frame.size.width+5,0,40, 20)];
        _lable.backgroundColor = [UIColor clearColor];
        _lable.textColor = [UIColor colorWithRed:231/255.0 green:98/255.0 blue:98/255.0 alpha:1];
        _lable.font = [UIFont boldSystemFontOfSize:14.0];
        [self addSubview:_lable];
        [_lable release];
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
