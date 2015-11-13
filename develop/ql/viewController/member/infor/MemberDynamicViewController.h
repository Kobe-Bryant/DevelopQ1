//
//  MemberDynamicViewController.h
//  ql
//
//  Created by yunlai on 14-8-5.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"
#import "LoadMoreTableFooterView.h"

#import "WatermarkCameraViewController.h"

@interface MemberDynamicViewController : UIViewController<UIScrollViewDelegate,LoadMoreTableFooterDelegate,UITableViewDataSource,UITableViewDelegate,WatermarkCameraViewControllerDelegate>{
    
    //下拉刷新和下拉加载更多
    LoadMoreTableFooterView* footerVew;
    BOOL isLoading;
    
    //指示框
    MBProgressHUD* progress;
    
    //选中的列表行
    int selectedIndex;
    
    //有新动态时的提示框
    UILabel *progressHUDTmp;
    
    //动态列表
    UITableView* dytableview;
    
}

//查看他人动态时才有的
@property(nonatomic,assign) long long lookId;

@end
