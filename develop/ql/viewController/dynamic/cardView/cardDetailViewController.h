//
//  cardDetailViewController.h
//  ql
//
//  Created by yunlai on 14-4-16.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DynamicCardView.h"

typedef enum{
    DynamicDetailTypeAll = 0,
    DynamicDetailTypeMine,
    DynamicDetailTypeWantHave,
    DynamicDetailTypeOther
}DynamicDetailType;

@interface cardDetailViewController : UIViewController<DynamicCardDelegate,UIActionSheetDelegate>

//卡片类型
@property(nonatomic,assign) CardType type;
//卡片数据
@property(nonatomic,retain) NSDictionary* dataDic;
//详情类型
@property(nonatomic,assign) DynamicDetailType detailType;

//不是从动态列表进入的
@property(nonatomic,assign) BOOL enterFromDYList;

@end
