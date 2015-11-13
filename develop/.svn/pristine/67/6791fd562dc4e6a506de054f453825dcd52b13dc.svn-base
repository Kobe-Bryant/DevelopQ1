//
//  responsePopView.m
//  ql
//
//  Created by yunlai on 14-4-29.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "responsePopView.h"

#define RESPOPTAG 9998

@implementation responsePopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
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

-(void) dealloc{
    [_textview release];
    [_resLab release];
    [_containtView release];
    [super dealloc];
}

-(void) setup{
    self.backgroundColor = [UIColor clearColor];
    
    self.tag = RESPOPTAG;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    self.frame = CGRectMake(0, 20, size.width, size.height - 20);
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height - 20)];
    v.backgroundColor = [UIColor blackColor];
    v.alpha = 0.7;
    [self addSubview:v];
    RELEASE_SAFE(v);
    
    _containtView = [[UIView alloc] initWithFrame:CGRectMake(10, 70, 300, 200)];
    _containtView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
    _containtView.layer.cornerRadius = 5.0;
    [self addSubview:_containtView];
    
    _resLab = [[UILabel alloc] init];
    _resLab.frame = CGRectMake(50, 0, 200, 45);
    _resLab.font = KQLboldSystemFont(17);
    _resLab.textAlignment = UITextAlignmentCenter;
    _resLab.textColor = [UIColor darkGrayColor];
    [_containtView addSubview:_resLab];
    
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
//    UIImage *image = [[UIImage alloc ]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_group_shut" ofType:@"png"]];
    UIImage* image = IMG(@"btn_group_shut");
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(_containtView.bounds.size.width-image.size.width-10, (_resLab.bounds.size.height - image.size.width)/2,image.size.width, image.size.height);
    [_containtView addSubview:backButton];
//    [image release];
    
    _textview = [[UITextView alloc] init];
    _textview.backgroundColor = [UIColor whiteColor];
    _textview.delegate = self;
    _textview.returnKeyType = UIReturnKeySend;
    _textview.frame = CGRectMake(0, CGRectGetMaxY(_resLab.frame), 300, 100);
    _textview.font = KQLboldSystemFont(14);
    _textview.textColor = [UIColor darkGrayColor];
    _textview.showsVerticalScrollIndicator = NO;
    [_containtView addSubview:_textview];
    
    UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake((300 - 100)/2, 15/2 + CGRectGetMaxY(_textview.frame), 100, 40);
    sureBtn.titleLabel.font = KQLboldSystemFont(17);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.backgroundColor = [UIColor colorWithRed:0.12 green:0.55 blue:0.89 alpha:1.0];
    sureBtn.layer.cornerRadius = 5.0;
    [_containtView addSubview:sureBtn];
    
    [_textview becomeFirstResponder];
}

-(void) backTo{
    [self hideResPop];
}

-(void) sureClick{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(sureButtonClick:)]) {
        NSString* msg = [[NSString alloc] initWithString:_textview.text];
        [_delegate sureButtonClick:msg];
        [self hideResPop];
    }
}

-(void) showResPop{
    UIViewController *appRootViewController;
    UIWindow *window;
    
    window = [UIApplication sharedApplication].keyWindow;
    
    appRootViewController = window.rootViewController;
    
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController.view viewWithTag:RESPOPTAG]) {
        [[topViewController.view viewWithTag:RESPOPTAG] removeFromSuperview];
    }
    
    //    self.frame = topViewController.view.bounds;
    [topViewController.view addSubview:self];
}

-(void) hideResPop{
    [_textview resignFirstResponder];
    [self removeFromSuperview];
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        NSString* msg = [[NSString alloc] initWithString:textView.text];
        [_delegate sureButtonClick:msg];
        
        [self hideResPop];
        return YES;
    }
    
    return YES;
}

@end
