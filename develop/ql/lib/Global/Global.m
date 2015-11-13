//
//  Global.m
//  cw
//
//  Created by siphp on 12-8-13.
//  Copyright 2013 yunlai. All rights reserved.
//

#import "Global.h"
#import "config.h"


/* 线程安全的实现 */
@implementation Global

static id sharedGlobal = nil;

@synthesize locManager;
@synthesize myLocation;
@synthesize locationAddress;
@synthesize locationCity;
@synthesize currCity;
@synthesize province;
@synthesize netWorkQueue;
@synthesize netWorkQueueArray;
@synthesize user_id;
@synthesize isLogin;
@synthesize isChangedImage;
@synthesize isLoction = _isLoction;
@synthesize loctionFlag;
@synthesize countObj_id;
@synthesize push_id;
@synthesize userInfo;
@synthesize dyMe_unread_num;
@synthesize secretInfo;
@synthesize newDynamicNum;
@synthesize org_id;
@synthesize organizationInfo;

//add vincet
+ (CGFloat)judgementIOS7:(CGFloat)height{
    if(IOS_VERSION_7)
        height = height + 20.0f;
    return height;
}

+ (void)initialize
{
    if (self == [Global class])
    {
        sharedGlobal = [[self alloc] init];
    }
}

+ (Global *)sharedGlobal
{
    return sharedGlobal;
}

+ (NSString *)currentLanguage{
    NSArray *preferedLanguages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [preferedLanguages firstObject];
    return currentLanguage;
}

+ (NSLocale *) currentLocale{
    NSLocale *currentLocale = [NSLocale currentLocale];
    return currentLocale;
}

+ (NSString *)currentCountryCode
{
    NSString *code = [[Global currentLocale] objectForKey:NSLocaleCountryCode];
    return code;
}

+ (BOOL)isChinaLocaleCode
{
    NSRange range = [[Global currentCountryCode]rangeOfString:@"CN"];
    return range.length >0;
}

+ (BOOL)isChineseLanguage
{
    NSRange range = [[Global currentLanguage] rangeOfString:@"zh-"];
    return range.length >0;
}


- (void)dealloc
{
    self.locManager = nil;
    self.locationAddress = nil;
    self.locationCity = nil;
    self.currCity = nil;
    self.netWorkQueue = nil;
    self.netWorkQueueArray = nil;
    self.user_id = nil;
    self.countObj_id = nil;
    self.userInfo = nil;
    self.secretInfo = nil;
    self.province = nil;
    
    [super dealloc];
}



+ (BOOL) isPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
        //hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }
    
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    [hudView hide:YES afterDelay:showtime];
    return hudView;}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime LeftOffset:(NSInteger)leftOffset {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2 - leftOffset;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }
    
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDAnimationFade;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    [hudView hide:YES afterDelay:showtime];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - HUD_VIEW_WIDTH / 2;
        rect.origin.y = rect.size.height / 2 - HUD_VIEW_HEIGHT / 2;
        rect.size.width = HUD_VIEW_WIDTH;
        rect.size.height = HUD_VIEW_HEIGHT;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
        //hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }
    
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeCustomView;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg VisibleRect:(CGRect)vRect {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        hudView = [[MBProgressHUD alloc] initWithFrame:vRect];
        [superView addSubview:hudView];
    }else {
        hudView = [[MBProgressHUD alloc] initWithFrame:vRect];
        [superView addSubview:hudView];
    }
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    NSLog(@"%@", NSStringFromCGRect(hudView.frame));
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHud:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg LeftOffset:(NSInteger)leftOffset {
    MBProgressHUD *hudView;
    if ([self isPad]) {
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - 50 - leftOffset;
        rect.origin.y = rect.size.height / 2 - 50;
        rect.size.width = 100;
        rect.size.height = 100;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }else {
        //hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        CGRect rect = superView.bounds;
        rect.origin.x = rect.size.width / 2 - 50;
        rect.origin.y = rect.size.height / 2 - 50;
        rect.size.width = 100;
        rect.size.height = 100;
        hudView = [[MBProgressHUD alloc] initWithFrame:rect];
        hudView.userInteractionEnabled = NO;
        [superView addSubview:hudView];
    }
    
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView show:YES];
    return hudView;
}

+ (MBProgressHUD *) showMBProgressHudHint:(id)sender SuperView:(UIView *)superView Msg:(NSString *)msg ShowTime:(CGFloat)showtime {
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    hudView.delegate = sender;
    
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.labelText = msg;
    hudView.margin = 10.f;
    //hudView.yOffset = 150.f;
    
    [hudView hide:YES afterDelay:showtime];
    return hudView;
}


@end
