//
//  choiceCircleViewController.h
//  ql
//
//  Created by yunlai on 14-4-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol choiceCircleDelegate <NSObject>

@optional
-(void) sureCircleClick:(NSDictionary*) selectCircles;
-(void) cancelCLClick;

@end

@interface choiceCircleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) id<choiceCircleDelegate> delegate;

@end
