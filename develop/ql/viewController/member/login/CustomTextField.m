//
//  CustomTextField.m
//  ql
//
//  Created by yunlai on 14-4-12.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return self;
}

- (void)paste:(id)sender
{
    [super paste:sender];
    [self.customDelegate customTextFieldPaste];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect
{
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
//    [[[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"] setFill];
    [COLOR_GRAY2 setFill];
    
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:16]];
}

//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self caculateCustomInsetRect:bounds];
}

- (CGRect)caculateCustomInsetRect:(CGRect)bounds
{
    CGRect inset;
    //return CGRectInset(bounds, 20, 0);
    if (IOS_VERSION_7) {
        inset = CGRectMake(bounds.origin.x+2, bounds.origin.y + 12, bounds.size.width -5, bounds.size.height);//更好理解些
    }else{
        inset = CGRectMake(bounds.origin.x+2, bounds.origin.y + 2, bounds.size.width -5, bounds.size.height);//更好理解些
    }
    return inset;
}

@end
