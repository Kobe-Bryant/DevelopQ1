//
//  MemberInfoViewController.h
//  ql
//
//  Created by LuoHui on 14-1-9.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequest.h"

#import "WatermarkCameraViewController.h"

@interface MemberInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HttpRequestDelegate,WatermarkCameraViewControllerDelegate>

//用户数据
@property (nonatomic, retain) NSArray *userInfoArry;

//1来自自己可修改，0来自他人不可点击
@property(nonatomic,assign) int accType;

@end
