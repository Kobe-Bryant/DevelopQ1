//
//  Global.h
//  cw
//
//  Created by siphp on 12-8-13.
//  Copyright 2012 yunlai. All rights reserved.
//

#include <netdb.h>
#import <CoreLocation/CoreLocation.h>
#import "Common.h"

//MBProgressHud
#define HUD_VIEW_WIDTH 200
#define HUD_VIEW_HEIGHT 100

typedef enum _statusType {
    StatusTypeNormal                = 0,
	StatusTypeMember                = 1,        // 云主页
} CwStatusType;

/* ========================================全局变量=============================================== */

@interface Global : NSObject
{
    //定位
    CLLocationManager *locManager;
    CLLocationCoordinate2D myLocation;
    NSString *locationAddress;
    NSString *locationCity;
    // 当前城市
    NSString *currCity;
    //网络线程
    NSOperationQueue *netWorkQueue;
    NSMutableArray *netWorkQueueArray;
    
    // 用户ID
    NSNumber *user_id;

    //是否登陆
    BOOL _isLogin;
    BOOL _isChangedImage;
    
    // 定位是否开启失败
    BOOL _isLoction;

    // TabBar判断定位
    BOOL loctionFlag;
    
    NSString *countObj_id;
    
    NSString *push_id; //推送id
    
    //用户信息
    NSDictionary* userInfo;
    
    //@我，未读数
    int dyMe_unread_num;
    
    //小秘书
    NSDictionary* secretInfo;
    
    //新动态
    int newDynamicNum;
}

@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, assign) CLLocationCoordinate2D myLocation;
@property (nonatomic, retain) NSString *locationAddress;
@property (nonatomic, retain) NSString *locationCity;
@property (nonatomic, retain) NSString *currCity;
@property(nonatomic,retain) NSString* province;
@property (nonatomic, retain) NSOperationQueue *netWorkQueue;
@property (nonatomic, retain) NSMutableArray *netWorkQueueArray;
@property (nonatomic, retain) NSNumber *user_id;//用户ID
@property (nonatomic, retain) NSNumber *org_id; //组织方ID
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isChangedImage;
@property (nonatomic, assign) BOOL isLoction;
@property (nonatomic, assign) BOOL loctionFlag;
@property (nonatomic, retain) NSString *countObj_id;
@property (nonatomic, retain) NSString *push_id;
@property(nonatomic,retain) NSDictionary* userInfo;
@property(nonatomic) int dyMe_unread_num;
@property(nonatomic, assign) BOOL isFirstInstall;

@property(nonatomic,retain) NSDictionary* secretInfo;       //小秘书信息
@property(nonatomic,retain) NSDictionary* organizationInfo; //组织方信息

@property(nonatomic,assign) int newDynamicNum;

//当前语言环境
+ (NSString *)currentLanguage;
//当前区域格式
+ (NSString *)currentCountryCode;
//当前地理对象
+ (NSLocale *) currentLocale;
//中文区域名判断
+ (BOOL)isChinaLocaleCode;
//中文语言环境判断
+ (BOOL)isChineseLanguage;


//全球对象Singleton
@property(nonatomic) BOOL isBackGround;

+ (Global *)sharedGlobal;

- (void)registerWXApi;

- (BOOL)handleOpenURL:(NSURL *)url delegate:(id)delegate;

//add vincet
+ (CGFloat)judgementIOS7:(CGFloat)height;

//show HudView
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime LeftOffset:(NSInteger)leftOffset;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg VisibleRect:(CGRect)vRect;
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg LeftOffset:(NSInteger)leftOffset;
+ (MBProgressHUD *) showMBProgressHudHint:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime;
@end