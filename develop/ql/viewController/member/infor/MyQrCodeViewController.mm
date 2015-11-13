//
//  MyQrCodeViewController.m
//  ql
//
//  Created by yunlai on 14-2-26.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "MyQrCodeViewController.h"
#import "myQRCodeGenerator.h"
#import "alertView.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "SGActionView.h"

@interface MyQrCodeViewController ()
{
    UIImageView *_bgImageView;
    UIImageView *_zbarImageView;
}
@end

#define kleftPadding 20.f
#define kpadding 15.f

@implementation MyQrCodeViewController
@synthesize infoStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    self.navigationItem.title = @"我的二维码";
    
    self.infoStr = [NSString stringWithFormat:@"MECARD:N:%@;TEL:%@;EMAIL:%@;URL:%@;TITLE:%@;ORG:%@;ADR:%@;NOTE:%@;;",@"张德华",@"13800000000",@"",@"www.baidu.com",@"",@"",@"",@""];
    
    [self rightBarButton];

    [self createBgImage];
    
}

/**
 *  分享
 */
- (void)rightBarButton{
    
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor grayColor];
    
    [backButton addTarget:self action:@selector(shareTo) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImage *image = [[UIImage alloc ]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return" ofType:@"png"]];
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 30.f, 30.f);
//    RELEASE_SAFE(image);
    
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = backItem;
    RELEASE_SAFE(backItem);
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
}

/**
 *  分享
 */

- (void)shareTo{
    
//    PopShareView *shareView = [PopShareView defaultExample];
//    [shareView showPopupView:self.navigationController delegate:self shareType:ShareTypeAll];
}

/**
 *  截屏
 *
 *  @param view 截取的视图
 *
 *  @return 截取后的图片
 */
- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  保存二维码
 */
-(void)saveAndShare
{

    if (_isSaved == NO) {
        UIImage *codeImage = [self imageWithView:_bgImageView];
        
        if (codeImage == nil)
        {
            [alertView showAlert:@"无法保存,二维码不存在"];
        }
        else
        {
            UIImageWriteToSavedPhotosAlbum(codeImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
        }
    }
}

/**
 *  保存图片到本地的回调
 *
 *  @param image       要保存的图片
 *  @param error       错误描述
 *  @param contextInfo 文本信息描述
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
	if (!error)
    {
		NSLog(@"codeImage written success");
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
        progressHUDTmp.center=CGPointMake(self.view.center.x, self.view.center.y+120);
        progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_ok_normal.png"]] autorelease];
        progressHUDTmp.mode = MBProgressHUDModeCustomView;
        [app.window addSubview:progressHUDTmp];
        [progressHUDTmp show:YES];
        [progressHUDTmp hide:YES afterDelay:1.5];
        progressHUDTmp.labelText = @"已保存到本地相册";
        RELEASE_SAFE(progressHUDTmp);
        
        _isSaved = YES;
    }
	else
    {
		NSLog(@"Error writing to photo album: %@", [error localizedDescription]);
       
    }
}

/**
 *  布局
 */
- (void)createBgImage{
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 20.f, KUIScreenWidth, 400.f )];
    _bgImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgImageView];
    
    UIImageView *_headView = [[UIImageView alloc]initWithFrame:CGRectMake(kpadding, kpadding - 3, 60, 60)];
    _headView.userInteractionEnabled = YES;
    _headView.layer.cornerRadius = 30;
    _headView.clipsToBounds = YES;
    _headView.image = [UIImage imageNamed:@"qr_card_bg"];
    _headView.backgroundColor = [UIColor grayColor];
    [_bgImageView addSubview:_headView];
    
    UILabel *_usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + kleftPadding, kpadding, 100, 30)];
    _usernameLabel.backgroundColor = [UIColor clearColor];
    _usernameLabel.font = KQLboldSystemFont(17);
    _usernameLabel.text = @"张德华";
    [_bgImageView addSubview:_usernameLabel];
    
    UILabel *_userPosition = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + kleftPadding, CGRectGetMaxY(_usernameLabel.frame) - 5, 150, 30)];
    _userPosition.backgroundColor = [UIColor clearColor];
//    _userPosition.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
    _userPosition.textColor = COLOR_GRAY2;
    _userPosition.font = KQLSystemFont(15);
    _userPosition.text = @"EMBA2007届 | 班长";
    _userPosition.textAlignment = NSTextAlignmentLeft;
    [_bgImageView addSubview:_userPosition];
    RELEASE_SAFE(_headView);
    RELEASE_SAFE(_usernameLabel);
    RELEASE_SAFE(_userPosition);
    
    UILabel *sepeLine = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 90.f, KUIScreenWidth, 1.5)];
//    sepeLine.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LINE"];
    sepeLine.backgroundColor = COLOR_LINE;
    [_bgImageView addSubview:sepeLine];
    RELEASE_SAFE(sepeLine);
    
    
    _zbarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60.0f,120.0f,200.f,210.f)];
    _zbarImageView.backgroundColor = [UIColor clearColor];
    NSLog(@"infoStr==%@",self.infoStr);
    _zbarImageView.image = [myQRCodeGenerator qrImageForString:self.infoStr imageSize:_zbarImageView.bounds.size.width withPositionType:QRPositionRound];
    [_bgImageView addSubview:_zbarImageView];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:_zbarImageView.frame];
    [_bgImageView insertSubview:headImageView belowSubview:_zbarImageView];
    headImageView.image = [UIImage imageNamed:@"qr_card_bg"];
    headImageView.backgroundColor = [UIColor clearColor];
    RELEASE_SAFE(headImageView);
    
    UILabel *strLabel = [[UILabel alloc] init];
    strLabel.frame = CGRectMake(60, _bgImageView.frame.size.height - 50, 200.f, 30.f);
    strLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
    strLabel.text = @"扫一扫二维码，开启我的云主页";
    strLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    strLabel.textAlignment = NSTextAlignmentLeft;
    strLabel.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:strLabel];
    RELEASE_SAFE(strLabel);
    
    _isSaved = NO;
}

- (void)dealloc
{
    RELEASE_SAFE(_bgImageView);
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
