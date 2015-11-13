//
//  UserSignModifyViewController.h
//  ql
//
//  Created by yunlai on 14-5-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequest.h"

@interface UserSignModifyViewController : UIViewController<UITextViewDelegate,HttpRequestDelegate>

//title
@property (nonatomic ,retain) NSString *titleCtl;
//内容文本
@property (nonatomic ,retain) NSString *content;
//参数类型
@property (nonatomic ,assign) int modifyType;
//个人信息详情数据
@property (nonatomic, retain) NSDictionary *detailDictionary;

@end
