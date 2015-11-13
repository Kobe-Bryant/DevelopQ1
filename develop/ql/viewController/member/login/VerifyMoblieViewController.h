//
//  VerifyMoblieViewController.h
//  ql
//
//  Created by yunlai on 14-2-24.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertView.h"

@interface VerifyMoblieViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSString *moblieStr;
    NSTimer *_timer;
    AlertView *_alertHud; //提示语
}
@property (nonatomic ,retain)NSString *moblieStr;

@end
