//
//  UIViewController+NavigationBar.m
//  CommunityAPP
//
//  Created by Stone on 14-5-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "UIImage+extra.h"
#import "ThemeManager.h"
#import "Global.h"
#import "config.h"

@implementation UIViewController (NavigationBar)


- (BOOL)isIOS7
{
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending);
}

- (UIBarButtonItem *)spacer:(CGFloat)margin
{
    UIBarButtonItem *space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    space.width = -margin;
    return space;
}

- (UIBarButtonItem *)spacer
{
    UIBarButtonItem *space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    space.width = -20;
    return space;
}

- (void)adjustiOS7NaviagtionBar
{
    
    if ( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) )
    {        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"];
    }
    else{
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)setNavigationTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.font = [UIFont boldSystemFontOfSize:18.0f];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = label;
    [label release];
}


- (void)setBackBarButtonItem:(UIView *)view{
    
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
//    if ([self isIOS7]) {
//        self.navigationItem.leftBarButtonItem = nil;
//        self.navigationItem.leftBarButtonItems = @[[self spacer], backButtonItem];
//    }else{
//        self.navigationItem.leftBarButtonItem = backButtonItem;
//    }
//    
//    [backButtonItem release];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = barBtnItem;
    RELEASE_SAFE(barBtnItem);
    
}


- (UIButton *)setBackBarButton:(NSString *)titleString{
    UIButton *barbutton = [[[UIButton alloc] init] autorelease];
    if (titleString) {
        [barbutton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
        [barbutton setTitle:titleString forState:UIControlStateNormal];
        barbutton.titleLabel.font = KQLboldSystemFont(14);
        barbutton.frame = CGRectMake(0.0f, 0.0f, 40.f, 30.f);
    }else{
        UIImage* btnImage = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
        [barbutton setImage:btnImage forState:UIControlStateNormal];
        barbutton.frame = CGRectMake(0, 0,btnImage.size.width, btnImage.size.height);
    }
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        barbutton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    return barbutton;
}


- (void)setRightBarButtonItem:(UIView *)view{
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    if ([self isIOS7]) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = @[[self spacer], rightButtonItem];
    }else{
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    [rightButtonItem release];
}

- (void)setRightBarButtonItem:(UIView *)view offset:(CGFloat)offset{
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    if ([self isIOS7]) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = @[[self spacer:offset], rightButtonItem];
    }else{
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
    
    [rightButtonItem release];
}




@end
