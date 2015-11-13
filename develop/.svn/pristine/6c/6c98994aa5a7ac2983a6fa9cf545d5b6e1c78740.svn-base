//
//  dyListView.m
//  ql
//
//  Created by yunlai on 14-4-10.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "dyListView.h"
#import "ThemeManager.h"
#import "config.h"

@implementation dyListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
        self.alpha = 0.8;
        [self setup];
    }
    return self;
}

-(void) setup{
    UIButton* imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [imageBtn setFrame:CGRectMake(70, self.bounds.size.height/2 - 120, 80, 80)];
    imageBtn.tag = 100;
    imageBtn.backgroundColor = [UIColor redColor];
    [imageBtn setTitle:@"图文" forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imageBtn];
    imageBtn.layer.cornerRadius = imageBtn.bounds.size.width/2;
    
    UILabel* imageLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageBtn.frame), CGRectGetMaxY(imageBtn.frame), imageBtn.bounds.size.width, 20)];
    imageLab.text = @"图文";
    imageLab.textColor = [UIColor whiteColor];
    imageLab.textAlignment = NSTextAlignmentCenter;
    imageLab.font = KQLboldSystemFont(14);
    [self addSubview:imageLab];
    
    UIButton* OOXXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [OOXXBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [OOXXBtn setFrame:CGRectMake(CGRectGetMaxX(imageBtn.frame) + 20, CGRectGetMinY(imageBtn.frame), 80, 80)];
    OOXXBtn.tag = 101;
    OOXXBtn.backgroundColor = [UIColor greenColor];
    [OOXXBtn setTitle:@"OOXX" forState:UIControlStateNormal];
    [OOXXBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:OOXXBtn];
    OOXXBtn.layer.cornerRadius = imageBtn.bounds.size.width/2;
    
    UILabel* OOXXLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(OOXXBtn.frame), CGRectGetMaxY(OOXXBtn.frame), OOXXBtn.bounds.size.width, 20)];
    OOXXLab.text = @"OOXX";
    OOXXLab.textColor = [UIColor whiteColor];
    OOXXLab.textAlignment = NSTextAlignmentCenter;
    OOXXLab.font = KQLboldSystemFont(14);
    [self addSubview:OOXXLab];
    
    UIButton* publicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [publicBtn setFrame:CGRectMake(CGRectGetMinX(imageBtn.frame), CGRectGetMaxY(imageBtn.frame) + 40, 80, 80)];
    publicBtn.tag = 102;
    publicBtn.backgroundColor = [UIColor blueColor];
    [publicBtn setTitle:@"开放时间" forState:UIControlStateNormal];
    [publicBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:publicBtn];
    publicBtn.layer.cornerRadius = publicBtn.bounds.size.width/2;
    
    UILabel* publicLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(publicBtn.frame), CGRectGetMaxY(publicBtn.frame), publicBtn.bounds.size.width, 20)];
    publicLab.text = @"开放时间";
    publicLab.textColor = [UIColor whiteColor];
    publicLab.textAlignment = NSTextAlignmentCenter;
    publicLab.font = KQLboldSystemFont(14);
    [self addSubview:publicLab];
    
    UIButton* wantBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wantBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [wantBtn setFrame:CGRectMake(CGRectGetMaxX(imageBtn.frame) + 20, CGRectGetMaxY(imageBtn.frame) + 40, 80, 80)];
    wantBtn.tag = 103;
    wantBtn.backgroundColor = [UIColor yellowColor];
    [wantBtn setTitle:@"我有我要" forState:UIControlStateNormal];
    [wantBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:wantBtn];
    wantBtn.layer.cornerRadius = wantBtn.bounds.size.width/2;
    
    UILabel* wantLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(wantBtn.frame), CGRectGetMaxY(wantBtn.frame), wantBtn.bounds.size.width, 20)];
    wantLab.text = @"我有我要";
    wantLab.textColor = [UIColor whiteColor];
    wantLab.textAlignment = NSTextAlignmentCenter;
    wantLab.font = KQLboldSystemFont(14);
    [self addSubview:wantLab];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnview)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    RELEASE_SAFE(tap);
    
    RELEASE_SAFE(imageLab);
    RELEASE_SAFE(OOXXLab);
    RELEASE_SAFE(publicLab);
    RELEASE_SAFE(wantLab);
}

-(void) btnClick:(UIButton*) btn{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(dyButtonClick:)]) {
        [_delegate dyButtonClick:btn];
    }
}

-(void) tapOnview{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(touchOn)]) {
        [_delegate touchOn];
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
