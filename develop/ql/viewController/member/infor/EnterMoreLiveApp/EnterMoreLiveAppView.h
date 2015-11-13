//
//  EnterMoreLiveAppView.h
//  ql
//
//  Created by yunlai on 14-8-11.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterMoreLiveAppView : UIView
{
    id lastViewController;//上一个界面的vc
}
- (id)initWithFrame:(CGRect)frame delegateController:(id)controller;
@end
