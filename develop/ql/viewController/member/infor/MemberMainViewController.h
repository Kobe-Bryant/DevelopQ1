//
//  MemberMainViewController.h
//  ql
//
//  Created by yunlai on 14-4-14.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberTopView.h"
#import "HttpRequest.h"

typedef enum
{
    PushTypesButtom,    // 淡出
    PushTypesLeft,   // 从左向右
}PushsType;

typedef enum
{
    AccessTypeSelf,         // 进自己的主页
    AccessTypeLookOther,    // 看别人的主页
    AccessTypeSearchLook,   // 圈子搜索查看主页
    AccessTypeCircleLook,   // 圈子查看主页
}AccessType;

typedef enum{
   NavigationBarHidden,     //导航栏隐藏
   NavigationBarAppear,     //导航条出现
} NavigationBarType;

@interface MemberMainViewController : UIViewController<MemberTopViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,HttpRequestDelegate>

@property (nonatomic,assign)long long lookId;
//push主页方式
@property (nonatomic,assign)PushsType pushType;
//访问主页类型
@property (nonatomic,assign)AccessType accessType;
//判断是否在聊天界面进入
@property (nonatomic,assign) BOOL isSessionInter;

//邀请开通他人的Id
@property (nonatomic,assign)int destinationId;
//聊天使用
@property (nonatomic,retain)NSDictionary *userInfoDic;

@property (nonatomic,assign) NavigationBarType navigationBarType;


//进入更多的liveApp add vincent
-(void)enterMemberLiveBtnAction;
@end
