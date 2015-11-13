//
//  browserViewController.h
//  Profession
//
//  Created by siphp on 12-8-25.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface browserViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
	UIWebView *myWebView;
    UIActivityIndicatorView *spinner;
	NSString *url;
    NSString *webTitle;
    UIImage *shareImage;
    
}
@property(nonatomic,retain) MBProgressHUD *mbProgressHUD;
@property(nonatomic,retain) NSString *url;
@property(nonatomic,retain) NSString *webTitle;
@property(nonatomic,retain) UIImage *shareImage;

//工具栏
-(void)showToolBar;

//功能按钮
-(void)buttonClick:(id)sender;

//关闭
-(void)close;

//分享
-(void)share;

//刷新
-(void)reload;

//后退
-(void)back;

//前进
-(void)forward;


@end
