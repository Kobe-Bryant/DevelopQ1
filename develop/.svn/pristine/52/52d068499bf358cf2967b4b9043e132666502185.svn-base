//
//  UserInfoModifyViewController.h
//  ql
//
//  Created by yunlai on 14-4-22.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequest.h"
#import "userInfoData.h"

typedef enum
{
    ModifyContentTypeName,      // 昵称
    ModifyContentTypeSign,      // 签名
    ModifyContentTypeCompany,   // 公司
    ModifyContentTypeMobile,    // 手机
    ModifyContentTypeEmail,     // 邮箱
    ModifyContentTypeHobby,     // 兴趣
    ModifyContentTypePost,      // 职位
}ModifyContentType;

@interface UserInfoModifyViewController : UIViewController<UITextFieldDelegate,HttpRequestDelegate>

//title
@property (nonatomic ,retain) NSString *titleCtl;
//内容
@property (nonatomic ,retain) NSString *content;
//编辑个人信息类型参数
@property (nonatomic ,assign) int modifyType;
//编辑类型
@property (nonatomic ,assign) ModifyContentType contentType;

@end
