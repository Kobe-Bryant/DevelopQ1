//
//  dyListView.h
//  ql
//
//  Created by yunlai on 14-4-10.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol dyListDelegate <NSObject>

-(void) dyButtonClick:(UIButton*) btn;
-(void) touchOn;

@end

@interface dyListView : UIView<dyListDelegate>

@property(assign,nonatomic) id<dyListDelegate> delegate;

@end
