//
//  SettingMainViewController.h
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@interface SettingMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
//    指示器
    MBProgressHUD* progress;
}

@end
