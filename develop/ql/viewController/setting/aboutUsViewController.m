//
//  aboutUsViewController.m
//  ql
//
//  Created by yunlai on 14-4-8.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "aboutUsViewController.h"

#import "upgrade_model.h"
#import "UIImageView+WebCache.h"
#import "set_aboutUs_model.h"

@interface aboutUsViewController (){
//    版本数据
    NSDictionary* gradeDic;
//    关于我们数据
    NSDictionary* aboutDic;
}

@property(nonatomic,retain) UIImageView* aboutUsImgV;//关于我们图片
@property(nonatomic,retain) NSDictionary* aboutDic;
@end

@implementation aboutUsViewController
@synthesize aboutDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.aboutDic = [[NSDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    
    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    //    初始化返回
    [self backBar];
 
    [self initMainImageView];

}

//初始化有图片时关于我们UI
-(void) initMainImageView{
    _aboutUsImgV = [[UIImageView alloc] init];
    _aboutUsImgV.frame = self.view.bounds;
    if (isIPhone5) {
        [_aboutUsImgV setImage:[UIImage imageNamed:@"bg_aboutUs_iphone5.png"]];
    }else{
        [_aboutUsImgV setImage:[UIImage imageNamed:@"bg_aboutUs_iphone4.png"]];
    }
    _aboutUsImgV.frame = CGRectMake(0, 0, _aboutUsImgV.image.size.width, _aboutUsImgV.image.size.height);
    _aboutUsImgV.userInteractionEnabled = YES;
    [self.view addSubview:_aboutUsImgV];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor blackColor];
    versionLabel.font = [UIFont boldSystemFontOfSize:15];
    if (isIPhone5) {
        versionLabel.frame = CGRectMake(0, 180, 320, 60);
    }else{
        versionLabel.frame = CGRectMake(0, 105, 320, 60);
    }
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.text = [NSString stringWithFormat:@"云圈 V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
    [_aboutUsImgV addSubview:versionLabel];
    [versionLabel release];
    
    
    UIView *tapView = [[UIView alloc] init];
    if (isIPhone5) {
        tapView.frame = CGRectMake(30, self.view.frame.size.height - 210, 260, 45);
    }else{
        tapView.frame = CGRectMake(30, self.view.frame.size.height - 210, 260, 45);
    }
    tapView.backgroundColor = [UIColor clearColor];
    [_aboutUsImgV addSubview:tapView];
    [tapView release];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhone)];
    [tapView addGestureRecognizer:tap];
    RELEASE_SAFE(tap);
}

#pragma mark - 点击打电话
//使用webview加载的方式 有弹框效果
-(void)tapPhone{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4000-168-906"]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    [self.view addSubview:callWebview];
    [callWebview release];
}

/**
 *  返回按钮
 */
- (void)backBar{
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    RELEASE_SAFE(backItem);
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }
}

//返回响应
-(void) backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [self.aboutDic release];
    [_aboutUsImgV removeFromSuperview];
    [super dealloc];
}

@end
