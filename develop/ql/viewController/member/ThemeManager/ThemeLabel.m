//
//  ThemeLabel.m
//  WXWeibo
//
//  Created by chenfeng on 13-5-15.
//  Copyright (c) 2014年 yunlai.cn. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [_colorName release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
        
        [self setColor];

    }
    return self;
}

- (id)initWithColorName:(NSString *)colorName {
    self = [super initWithFrame:CGRectZero];
    if (self != nil) {
        self.colorName = colorName;
        
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
        
        [self setColor];
    }
    
    return self;
}


- (void)awakeFromNib {
    //监听主题切换的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    
    [self setColor];
}

- (void)setColor {
    UIColor *textColor = [[ThemeManager shareInstance] getColorWithName:self.colorName];
    self.textColor = textColor;
}

- (void)themeNotification:(NSNotification *)notification {
    [self setColor];
}

@end
