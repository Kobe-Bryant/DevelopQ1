//
//  TempCircleDetailViewController.h
//  ql
//
//  Created by yunlai on 14-7-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CircleMemberList.h"
#import "ModifyCircleNameViewController.h"
#import "ModifyIntroduceViewController.h"
#import "choicelinkmanViewController.h"
#import "SessionViewController.h"
#import "CircleDetailCell.h"
#import "CRNavigationController.h"
#import "MemberMainViewController.h"

#import "CircleMemberList.h"

#import "UIImageView+WebCache.h"

#import "temporary_circle_list_model.h"

@protocol TempCircleDetailDelegate <NSObject>

-(void) addMemberReload;

@end

@interface TempCircleDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) UITableView* tableview;
//临时圈子ID
@property(nonatomic,assign) long long circleId;
//圈子详细信息
@property(nonatomic,retain) NSMutableDictionary* detailDic;
//圈子成员
@property(nonatomic,retain) NSArray* memberArr;

@property(nonatomic,assign) id<TempCircleDetailDelegate> delegate;
//获取临时圈子数据
-(void) getCircleDetailData;

@end
