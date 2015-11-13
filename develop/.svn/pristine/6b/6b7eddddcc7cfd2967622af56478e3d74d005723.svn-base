//
//  LoginWarningTipsView.m
//  ql
//
//  Created by yunlai on 14-7-7.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "LoginWarningTipsView.h"
#import "Global.h"
#import "config.h"

@implementation LoginWarningTipsView
@synthesize warningView;
@synthesize warningString;
@synthesize warningImageView;
@synthesize warningLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupUIimageAndLabel];
    }
    return self;
}

//初始化图片和内容
-(void)setupUIimageAndLabel{
    warningView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:warningView];
    
    //    感叹号的图片
    UIImage *warningImage = [UIImage imageNamed:@"bg_landing_warning.png"];
    warningImageView = [[UIImageView alloc] init];
    warningImageView.image = warningImage;
    [warningView addSubview:warningImageView];
    
    //  提示内容
    warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(warningImage.size.width,0, self.frame.size.width-warningImage.size.width, warningImage.size.height)];
    warningLabel.backgroundColor = [UIColor clearColor];
    warningLabel.font = KQLSystemFont(14);
    warningLabel.text = self.warningString;
    warningLabel.textColor = RGBACOLOR(229, 99, 101, 1);
    warningLabel.textAlignment = NSTextAlignmentCenter;
    [warningView addSubview:warningLabel];
    
    warningImageView.frame = CGRectMake(warningLabel.frame.origin.x-warningImage.size.width, 0, warningImage.size.width, warningImage.size.height);
}

//隐藏当前的内容
-(void)hide{
    if (warningView) {
        warningView.hidden = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
    [warningView release]; warningView = nil;
    [warningLabel release]; warningLabel = nil;
    [warningImageView release]; warningImageView = nil;
    [super dealloc];
}
@end
