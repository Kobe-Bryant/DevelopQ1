//
//  responsePopView.h
//  ql
//
//  Created by yunlai on 14-4-29.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol responsePopDelegate <NSObject>

-(void) sureButtonClick:(NSString*) msg;

@end

@interface responsePopView : UIView<UITextViewDelegate>

@property(nonatomic,retain,readonly) UIView* containtView;
@property(nonatomic,retain) UILabel* resLab;
@property(nonatomic,retain) UITextView* textview;
@property(nonatomic,assign) id<responsePopDelegate> delegate;

-(void) showResPop;

-(void) hideResPop;

@end
