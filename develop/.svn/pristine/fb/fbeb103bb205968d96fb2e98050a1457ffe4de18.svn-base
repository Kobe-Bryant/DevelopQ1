//
//  TopMenuBarView.m
//  ql
//
//  Created by yunlai on 14-3-3.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "TopMenuBarView.h"

#define ButHegiht       40.f    // 图标按钮的高度
#define LabelHeight     25.f    // 图标字体的高度

#define UpHeight        10.f    // 图标与上边距的高度
#define DownHeight      5.f     // 图标与下边距的高度
#define LeftWidth       20.f    // 图标与左边距的宽度

#define SpaceWidth      40.f    // 图标与图标的宽度
#define DownBtnHeight   40.f    // 取消按钮的高度

#define kMenuHeight     80.f    // 菜单高度

@implementation TopMenuBarView
@synthesize butArrayImage,butArrayText,delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        butArrayText = [NSArray arrayWithObjects:@"拍一拍",@"聚一聚",@"说一说",@"扫一扫", nil];
        butArrayImage = [NSArray arrayWithObjects:
                         @"facebook@2x.png",
                         @"googleplus@2x.png",
                         @"twitter@2x.png",
                         @"wechat@2x.png",
                         nil];
        
        
        int row = butArrayText.count%4 == 0 ? butArrayText.count/4 : butArrayText.count/4 + 1;
        int count = 0;
        int rowCount = 0;
        
        
        for (int i = 0; i < butArrayText.count; i++) {
            if (i%4 == 0) {
                count = 0;
                rowCount++;
            } else {
                count++;
            }
            
            // 图标按钮开始创建
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(count * 80.f, 0.f, 80.f, 80.f);
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            button.backgroundColor = [UIColor clearColor];
            
            
            UIImageView *iconView = [[UIImageView alloc]init];
            iconView.frame = CGRectMake(count*(ButHegiht+SpaceWidth) + LeftWidth,
                                      rowCount*UpHeight + (rowCount-1)*(ButHegiht + LabelHeight),
                                      ButHegiht, ButHegiht);
            [iconView setImage:[UIImage imageNamed:[butArrayImage objectAtIndex:i]]];
            iconView.backgroundColor = [UIColor clearColor];
            [self addSubview:iconView];
            RELEASE_SAFE(iconView);
            
            //分割线
            UILabel *slitLine = [[UILabel alloc]initWithFrame:CGRectMake(80 * (i + 1), 0.f, 1.5f, 80.f)];
//            slitLine.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LINE"];
            slitLine.backgroundColor = COLOR_LINE;
            [self addSubview:slitLine];
            RELEASE_SAFE(slitLine);
            
            // 图标字体开始创建
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 + 80 * i,
                                                                      50.f ,
                                                                      60.f , LabelHeight)];
            label.font = [UIFont systemFontOfSize:15.f];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [butArrayText objectAtIndex:i];
            label.tag = i + 100;
            label.textColor = COLOR_CONTROL;
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
            [label release], label = nil;
            
            [self addSubview:button];
        }
        
        CGFloat height = row * (ButHegiht + LabelHeight + UpHeight) + UpHeight;
        
        
        bgViewHeight = height;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/**
 *  上部菜单
 */
- (void)showInView:(UIView *)view delegate:(id)menuDelegate{

    _bgMenuBar = [[UIView alloc]initWithFrame:CGRectMake(0.f,kMenuHeight,KUIScreenWidth, KUIScreenHeight)];
    _bgMenuBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    
    self.delegate = menuDelegate;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToClose)];
    [view addGestureRecognizer:tapGesture];
    RELEASE_SAFE(tapGesture);
    
    self.hidden = YES;
    _bgMenuBar.hidden = YES;
    
    [view addSubview:_bgMenuBar];
    [view addSubview:self];
}

// 点击背景隐藏
-(void)tapToClose
{
    [self hideMenu];
}

// 下拉滑出
- (void)showMenu {
    self.hidden = NO;
    _bgMenuBar.hidden = NO;
    
    CGRect menuFrame = self.frame;
    if (IOS_VERSION_7) {
        menuFrame.origin.y = kMenuHeight - 16.f;
    }else{
        menuFrame.origin.y = 0.f;
    }
    
    [UIView animateWithDuration:0.23 animations:^{
        self.frame = menuFrame;
    
    } completion:^(BOOL finished) {
        [self addSubview:_bgMenuBar];
       
    }];
    
}

// 上拉隐藏
- (void)hideMenu {
    CGRect menuFrame = self.frame;
    menuFrame.origin.y = -kMenuHeight;
    
    [UIView animateWithDuration:0.23 animations:^{
        self.frame = menuFrame;
        [_bgMenuBar removeFromSuperview];
    } completion:^(BOOL finished) {
        self.hidden = YES;
        _bgMenuBar.hidden = YES;
    }];
}


- (void)buttonClick:(UIButton *)sender{
    if (self.delegate != nil && [delegate respondsToSelector:@selector(buttonClick:)]) {
        [self.delegate performSelector:@selector(buttonClick:) withObject:sender];
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
