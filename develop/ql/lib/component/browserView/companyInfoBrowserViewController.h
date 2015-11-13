//
//  companyInfoBrowserViewController.h
//  ql
//
//  Created by Dream on 14-8-16.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface companyInfoBrowserViewController : UIViewController <UIWebViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIActivityIndicatorView *spinner;
    UIWebView *_myWebView;
}

@property (nonatomic, retain) MBProgressHUD *mbProgressHUD;
@property (nonatomic, retain) NSString *webTitle;
@property (nonatomic, retain) NSString *url;
    
@end
