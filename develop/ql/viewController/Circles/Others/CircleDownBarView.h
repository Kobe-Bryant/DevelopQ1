//
//  CircleDownBarView.h
//  ql
//
//  Created by yunlai on 14-3-20.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleDownBarView;

@protocol CircleDownBarViewDelegate <NSObject>

- (void)actionDownBar:(CircleDownBarView *)circleDownBarView clickedButtonAtIndex:(UIButton *)buttonIndex;

@end

@interface CircleDownBarView : UIView
{
    id<CircleDownBarViewDelegate>delegate;
}
- (id)initWithFrame:(CGRect)frame type:(int)types;

@property (nonatomic, assign) id<CircleDownBarViewDelegate>delegate;

@end

