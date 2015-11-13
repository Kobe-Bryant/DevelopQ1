//
//  LeftSideMainViewController.h
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define markTag 300
#define kselectMarkTag 301

@protocol SidebarSelectedDelegate ;

@interface LeftSideMainViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id<SidebarSelectedDelegate>delegate;

-(void)changeToFirst;

@end
