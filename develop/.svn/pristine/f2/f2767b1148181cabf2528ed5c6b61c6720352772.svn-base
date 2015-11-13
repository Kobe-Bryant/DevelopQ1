//
//  CircleDownBarView.m
//  ql
//
//  Created by yunlai on 14-3-20.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "CircleDownBarView.h"

@implementation CircleDownBarView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame type:(int)types
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (types == 1) {
            [leftButton setTitle:@"加入圈子" forState:UIControlStateNormal];
            
        }else{
            [leftButton setTitle:@"分享" forState:UIControlStateNormal];
        }
       
        [leftButton setTag:0];
        [leftButton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(buttonIndex:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.frame = CGRectMake(0.f, 0.f, KUIScreenWidth / 2, self.frame.size.height);
        [self addSubview:leftButton];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(leftButton.frame) - 1 , 6.f, 1.2f, self.frame.size.height - 10.f)];
        line.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
        [self addSubview:line];
        RELEASE_SAFE(line);
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (types == 1) {
            [rightButton setTitle:@"忽略" forState:UIControlStateNormal];
        }else{
            [rightButton setTitle:@"下载" forState:UIControlStateNormal];
        }
        
        [rightButton setTag:1];
        [rightButton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(buttonIndex:) forControlEvents:UIControlEventTouchUpInside];
        rightButton.frame = CGRectMake(CGRectGetWidth(leftButton.frame), 0.f, KUIScreenWidth / 2, self.frame.size.height);
        [self addSubview:rightButton];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)buttonIndex:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(actionDownBar:clickedButtonAtIndex:)] && self.delegate !=nil) {
        [self.delegate performSelector:@selector(actionDownBar:clickedButtonAtIndex:) withObject:sender];
        
        UIButton* btn1 = (UIButton*)[self viewWithTag:0];
        btn1.enabled = NO;
        
        UIButton* btn2 = (UIButton*)[self viewWithTag:1];
        btn2.enabled = NO;
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

@end
