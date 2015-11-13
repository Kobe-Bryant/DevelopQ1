//
//  EnterMoreLiveAppView.m
//  ql
//
//  Created by yunlai on 14-8-11.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "EnterMoreLiveAppView.h"
#import "config.h"
#import "MemberMainViewController.h"

@implementation EnterMoreLiveAppView

- (id)initWithFrame:(CGRect)frame delegateController:(id)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lastViewController = controller;
        
        UIButton *enterLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [enterLiveBtn setTitle:@"更多模板请访问www.liveapp.cn" forState:UIControlStateNormal];
        enterLiveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [enterLiveBtn setTitleColor:RGB(17, 140, 224) forState:UIControlStateNormal];
        [enterLiveBtn setBackgroundColor:[UIColor whiteColor]];
        [enterLiveBtn setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [enterLiveBtn addTarget:self action:@selector(enterLiveBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:enterLiveBtn];
    }
    return self;
}

//
-(void)enterLiveBtnAction{
    [lastViewController enterMemberLiveBtnAction];
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
