//
//  TopMenuBarView.h
//  ql
//
//  Created by yunlai on 14-3-3.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopMenuBarViewDelegate <NSObject>

- (void)buttonClick:(UIButton *)index;

@end

@interface TopMenuBarView : UIView
{
    NSArray *butArrayText;
    NSArray *butArrayImage;
    CGFloat bgViewHeight;
    UIView *_bgMenuBar;
    id<TopMenuBarViewDelegate>delegate;
}

@property (retain, nonatomic) NSArray *butArrayText;
@property (retain, nonatomic) NSArray *butArrayImage;
@property (assign, nonatomic) id<TopMenuBarViewDelegate>delegate;

- (void)showInView:(UIView *)view delegate:(id)menuDelegate;
- (void)showMenu;
- (void)hideMenu;

@end
