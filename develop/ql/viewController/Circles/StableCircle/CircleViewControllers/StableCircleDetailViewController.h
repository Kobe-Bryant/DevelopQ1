//
//  CircleDetailViewController.h
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

#import "UIImageView+WebCache.h"

#import "CircleMemberList.h"

#import "SessionViewController.h"

#import "chatmsg_list_model.h"
#import "circle_member_list_model.h"
#import "TextData.h"
#import "SBJson.h"
#import "NSString+MessageDataExtension.h"

#import "circle_list_model.h"

@interface StableCircleDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
}
//创建该viewController的时候需传值
@property(nonatomic,assign) long long circleId;

//以下成员变量供子类使用
@property(nonatomic,retain) UITableView* tableview;
//圈子详细信息
@property(nonatomic,retain) NSMutableDictionary* detailDic;
//圈子成员
@property(nonatomic,retain) NSArray* memberArr;

@end
