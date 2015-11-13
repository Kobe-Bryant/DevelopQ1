//
//  CircleQrCodeViewController.m
//  ql
//
//  Created by yunlai on 14-3-20.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "CircleQrCodeViewController.h"
#import "CircleDownBarView.h"
#import "myQRCodeGenerator.h"
#import "alertView.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "SGActionView.h"
#import "UIImageView+WebCache.h"

@interface CircleQrCodeViewController ()
{
    UIImageView *_bgImageView;
    UIImageView *_zbarImageView;
}
@end

#define kleftPadding 20.f
#define kpadding 15.f

@implementation CircleQrCodeViewController
@synthesize qrCodeType,infoStr;
@synthesize userInfo = _userInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.view.backgroundColor = RGBACOLOR(38, 41, 45, 1);
        self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
        self.title = @"二维码";
       
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CircleDownBarView *downBar = [[CircleDownBarView alloc]initWithFrame:CGRectMake(0.f, KUIScreenHeight - 49.f-44.0, KUIScreenWidth, 49.f)type:0];
    downBar.delegate = self;
    [self.view addSubview:downBar];
    RELEASE_SAFE(downBar);
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.infoStr = [NSString stringWithFormat:@"MECARD:N:%@;TEL:%@;EMAIL:%@;URL:%@;TITLE:%@;ORG:%@;ADR:%@;NOTE:%@;;",@"二维码",@"13800000000",@"",@"www.baidu.com",@"",@"",@"",@""];
    
    [self createBgImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  布局
 */
- (void)createBgImage{
    
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30.f, 80.f, KUIScreenWidth - 60.f, 320.f )];
    _bgImageView.backgroundColor = [UIColor whiteColor];
    _bgImageView.layer.cornerRadius = 5;
    [self.view addSubview:_bgImageView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth - 60.f, 90.f )];
    topView.backgroundColor = COLOR_CONTROL;
    [_bgImageView addSubview:topView];
    
    
    UIImageView *_headView = [[UIImageView alloc]initWithFrame:CGRectMake(kleftPadding, kleftPadding, 50, 50)];
    _headView.userInteractionEnabled = YES;
    _headView.layer.cornerRadius = 25;
    _headView.clipsToBounds = YES;
   
    _headView.backgroundColor = [UIColor grayColor];
    [topView addSubview:_headView];
    
    UILabel *_usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + kleftPadding, kpadding * 2, 100, 30)];
    _usernameLabel.backgroundColor = [UIColor clearColor];
    _usernameLabel.textColor = [UIColor whiteColor];
    _usernameLabel.font = KQLboldSystemFont(18);
    
    [topView addSubview:_usernameLabel];

    
    UILabel *sepeLine = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 90.f, KUIScreenWidth - 60.f, 1.5)];
//    sepeLine.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LINE"];
    sepeLine.backgroundColor = COLOR_LINE;
    [_bgImageView addSubview:sepeLine];
    RELEASE_SAFE(sepeLine);
    
    
    _zbarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60.0f,120.0f,140.f,140.f)];
    _zbarImageView.backgroundColor = [UIColor clearColor];
    NSLog(@"infoStr==%@",self.infoStr);
    _zbarImageView.image = [myQRCodeGenerator qrImageForString:self.infoStr imageSize:_zbarImageView.bounds.size.width withPositionType:QRPositionRound];
    [_bgImageView addSubview:_zbarImageView];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:_zbarImageView.frame];
    [_bgImageView insertSubview:headImageView belowSubview:_zbarImageView];
   
    headImageView.backgroundColor = [UIColor clearColor];
    
    if (self.qrCodeType == QrCodeViewTypePerson) {
     
        _headView.image = [UIImage imageNamed:@"qr_card_bg"];
        _usernameLabel.text = @"信息";
        headImageView.image = [UIImage imageNamed:@"qr_card_bg"];
        
    }else{
         _headView.image = [UIImage imageNamed:@"qr_card_bg"];
         _usernameLabel.text = @"圈子";
         headImageView.image = [UIImage imageNamed:@"qr_card_bg"];
    }
    
    
    RELEASE_SAFE(headImageView);
    
    UILabel *strLabel = [[UILabel alloc] init];
    strLabel.frame = CGRectMake(50, _bgImageView.frame.size.height - 50, 200.f, 30.f);
    strLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
    strLabel.text = @"扫一扫二维码，加入圈子";
    strLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    strLabel.textAlignment = NSTextAlignmentLeft;
    strLabel.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:strLabel];
    RELEASE_SAFE(strLabel);
    
    RELEASE_SAFE(_headView);
    RELEASE_SAFE(_usernameLabel);
    RELEASE_SAFE(topView);
    _isSaved = NO;
}

#pragma mark - CircleDownBarViewDelegate

- (void)actionDownBar:(CircleDownBarView *)circleDownBarView clickedButtonAtIndex:(UIButton *)buttonIndex{

    switch (buttonIndex.tag) {
        case 0:// 分享
        {
//            PopShareView *shareView = [PopShareView defaultExample];
//            
//            [shareView showPopupView:self.navigationController delegate:self shareType:ShareTypeAll];
        }
            break;
            
        case 1:// 下载
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
            break;
        default:
            break;
    }
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
