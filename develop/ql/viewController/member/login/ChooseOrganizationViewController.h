//
//  ChooseOrganizationViewController.h
//  ql
//
//  Created by yunlai on 14-5-22.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "HttpRequest.h"
#import "AsyncSocket.h"
#import "ZipArchive.h"
#import "SFHFKeychainUtils.h"

@interface ChooseOrganizationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HttpRequestDelegate,ZipArchiveDelegate>
{
    UIProgressView *proView;
    double proValue;
    MBProgressHUD *HUD;
    NSTimer *timer;
}

//1表示注册登陆，0表示正常登陆
@property(nonatomic) int LoginType;

@end
