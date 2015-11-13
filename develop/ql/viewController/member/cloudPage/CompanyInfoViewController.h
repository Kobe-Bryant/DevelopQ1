//
//  CompanyInfoViewController.h
//  ql
//
//  Created by yunlai on 14-2-27.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "companyInfoCell.h"

@interface CompanyInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_mainTableView;
}

@end
