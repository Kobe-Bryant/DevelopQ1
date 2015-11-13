//
//  AppDelegate.h
//  ql
//
//  Created by ChenFeng on 14-1-7.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRNavigationController.h"
#import <CoreLocation/CoreLocation.h>
#import "AsyncSocket.h"
#import "SFHFKeychainUtils.h"
#import "HttpRequest.h"

#import "LoginManager.h"
#import "MBProgressHUD.h"

@protocol APPlicationDelegate <NSObject>
@optional
- (BOOL)tencentHandleCallBack:(NSDictionary*)param;
- (BOOL)sinaHandleCallBack:(NSDictionary*)param;
-(BOOL)qqHandleCallBack:(NSDictionary *)param;
-(BOOL)weixinHandleCallBack:(NSDictionary *)param;

- (void)LoginConnectFail; //用于判断第一次网络不佳的提示语
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,AsyncSocketDelegate,HttpRequestDelegate,UIAlertViewDelegate,LoginManagerDelegate>
{
    int mapflag;                        // 判断
    NSMutableData *_heartBeatData;
    AsyncSocket *_listenSocket;
    AsyncSocket *_serverSocket;
    
    UIImageView *changeImage;//图片ImageView
    UIView *screenView;//图片的UIView
    
    MBProgressHUD* mbProgressHUD;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CRNavigationController *nav;
@property (retain, nonatomic) NSString *myDeviceToken;
@property (nonatomic, retain) NSString *province;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *area;
@property (nonatomic, assign) id<APPlicationDelegate> delegate;
@property (nonatomic, retain) UIImage *headerImage;


// 定位获取位置
- (void)getLocation;
@end
