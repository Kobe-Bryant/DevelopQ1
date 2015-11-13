//
//  CustomInsetTextView.m
//  ql
//
//  Created by LazySnail on 14-7-17.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "CustomInsetTextView.h"

@implementation CustomInsetTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (IOS_VERSION_7) {
            self.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
        }
    }
    return self;
}

- (void)paste:(id)sender
{
    [super paste:sender];
    NSLog(@"%@",sender);
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
