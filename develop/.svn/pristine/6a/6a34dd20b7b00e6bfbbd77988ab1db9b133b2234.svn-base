//
//  MemberDetailViewController.h
//  ql
//
//  Created by yunlai on 14-2-26.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "cloudUserInfoCell.h"
#import "MemberTopView.h"

typedef enum
{
    PushTypeButtom,    // 淡出
    PushTypeLeft,   // 从左向右
}PushType;

@interface MemberDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MemberTopViewDelegate>
{
    HomePageType enterType;//进入云主页的类型
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    NSInteger _detailCellHight;
    MemberTopView *_topView;
    UITableView *_mainTableView;
}

@property (nonatomic,assign)PushType pushType;
@property (nonatomic ,assign) HomePageType enterType;
@end
