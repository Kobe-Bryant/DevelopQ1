//
//  GuidePageViewController.m
//  ql
//
//  Created by yunlai on 14-2-24.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "GuidePageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "InvitationCodeViewController.h"
#import "JCTopic.h"
#import "config.h"

@interface GuidePageViewController ()
{
    UIScrollView *guideScrollView;
    NSDictionary *dataDic;
    UIImageView *mainPageView;
    UIPageControl *pc;
    int numPages;
    NSTimer *_timer;
    
    CGSize pageSize;//add vincent
    
    UIImageView* placeHolderImgV;
}
@property (nonatomic ,retain)NSDictionary *dataDic;
@property (nonatomic ,retain) JCTopic *topic; //add vincent
@property (nonatomic ,retain) UIPageControl *page; //add vincent
@end

@implementation GuidePageViewController
@synthesize dataDic,topic;
@synthesize page = _page;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (id)initNibView:(NSDictionary *)dic{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //add vinvent
    [topic setupTimer];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = RGBACOLOR(38, 41, 45, 1);
    
    [self addPlaceHolderPic];
    
    [self accessGuidePageService];
    
    [self loadAdsScrollView]; //广告视图 add vincent
     
    CGFloat kCtlHeight;
    if (IOS_VERSION_7) {
        kCtlHeight = KUIScreenHeight - 120.f;
    }else{
        kCtlHeight = KUIScreenHeight - 140.f;
    }
    
    UIView *buttomView = [[UIView alloc]init];
    if (isIPhone5) {
        buttomView.frame = CGRectMake(0.0,kCtlHeight , KUIScreenWidth, 140.f);
    }else{
        buttomView.frame = CGRectMake(0.0,kCtlHeight + 10 , KUIScreenWidth, 130.f);
    }
    buttomView.backgroundColor = [UIColor colorWithRed:54/255.0 green:58/255.f blue:62/255.0 alpha:1];
    [self.view addSubview:buttomView];
    
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeBtn setFrame:CGRectMake(15.f, 16.f, KUIScreenWidth - 30.0, 50)];
    if (isIPhone5) {
        [codeBtn setFrame:CGRectMake(15.f, 16.f, KUIScreenWidth - 30.0, 50)];
    }else{
        [codeBtn setFrame:CGRectMake(15.f, 16.f, KUIScreenWidth - 30.0, 44)];
    }
    [codeBtn setTitle:@"我有邀请码" forState:UIControlStateNormal];
//    [codeBtn setBackgroundColor:[UIColor whiteColor]];
    [codeBtn setBackgroundColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"]];
    [codeBtn addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
    codeBtn.layer.cornerRadius = 5;
//    [codeBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeBtn.titleLabel.font = KQLSystemFont(15);
    [buttomView addSubview:codeBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setFrame:CGRectMake(15.f,CGRectGetMaxY(codeBtn.frame) + 15.f, KUIScreenWidth - 30.0, 50)];
    if (isIPhone5) {
        [loginBtn setFrame:CGRectMake(15.f,CGRectGetMaxY(codeBtn.frame) + 15.f, KUIScreenWidth - 30.0, 50)];
    }else{
        [loginBtn setFrame:CGRectMake(15.f,CGRectGetMaxY(codeBtn.frame) + 15.f, KUIScreenWidth - 30.0, 44)];
    }
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:[UIColor clearColor]];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.borderColor = [UIColor grayColor].CGColor;
    loginBtn.layer.borderWidth = 1;
    loginBtn.titleLabel.font = KQLSystemFont(15);
    [buttomView addSubview:loginBtn];
    
    RELEASE_SAFE(buttomView);
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//    add vincent
    _page = [[UIPageControl alloc]init];
    if (isIPhone5) {
        _page.frame = CGRectMake((KUIScreenWidth - pageSize.width)/2,KUIScreenHeight - 170.f, pageSize.width,20.f);
    }else{
        _page.frame = CGRectMake((KUIScreenWidth - pageSize.width)/2,KUIScreenHeight - 150.f+[Global judgementIOS7:0], pageSize.width,20.f);
    }
    _page.pageIndicatorTintColor = RGBACOLOR(255, 255, 255, 1);//其他点的颜色
    _page.currentPageIndicatorTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];//当前点的颜色
    _page.currentPageIndicatorTintColor = COLOR_FONT;//当前点的颜色
    [self.view addSubview:_page];
    [_page release];
}

-(void) addPlaceHolderPic{
    if (isIPhone5) {
        placeHolderImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15.f, 70.f, KUIScreenWidth - 30, 300.f)];
    }else{
        placeHolderImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15.f, 20+[Global judgementIOS7:0], KUIScreenWidth - 30, 280.f)];
    }
    placeHolderImgV.layer.masksToBounds = YES;
    placeHolderImgV.layer.cornerRadius = 5;
    placeHolderImgV.contentMode = UIViewContentModeTop;
    placeHolderImgV.image = IMGREADFILE(@"default_600.png");
    [self.view addSubview:placeHolderImgV];
}

// 邀请码事件
- (void)codeAction{
    InvitationCodeViewController *invCtl = [[InvitationCodeViewController alloc]init];
    [self.navigationController pushViewController:invCtl animated:YES];
    
    RELEASE_SAFE(invCtl);
}


// 登录
- (void)loginAction{
    
    LoginViewController *lgoinCtl = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:lgoinCtl animated:YES];
    RELEASE_SAFE(lgoinCtl);
}

/**
 *  广告视图
 */
-(void)loadAdsScrollView{
    if (isIPhone5) {
        topic = [[JCTopic alloc]initWithFrame:CGRectMake(15.f, 70.f, KUIScreenWidth - 30, 300.f)];
    }else{
        topic = [[JCTopic alloc]initWithFrame:CGRectMake(15.f, 20+[Global judgementIOS7:0], KUIScreenWidth - 30, 280.f)];
    }

    topic.JCdelegate = self;
    
    [self.view addSubview:topic];
    [topic release];
}

/**
 *  刷新广告
 */
- (void)refreshAds{
    //移除站位图 booky
    [placeHolderImgV removeFromSuperview];
    
    topic.pics = [self.dataDic objectForKey:@"pics"];
    //更新
    NSLog(@"pics %@",[self.dataDic objectForKey:@"pics"]);
    [topic upDate];
}

-(void)currentPage:(int)page total:(NSUInteger)total{
    _page.numberOfPages = total;
    _page.currentPage = page;
    pageSize = [_page sizeForNumberOfPages:total];
}

- (void)dealloc
{
    RELEASE_SAFE(guideScrollView);
    RELEASE_SAFE(pc);
    [_timer invalidate];
    _timer = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessService

- (void)accessGuidePageService{
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:GUIDE_COMMAND_ID accessAdress:@"index/hotwrite.do?param=" delegate:self withParam:nil];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    if (resultArray == nil) {
        return;
    }
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        
        switch (commandid) {
            case GUIDE_COMMAND_ID:
            {
                NSLog(@"self===%@",self.dataDic);
                self.dataDic = [resultArray objectAtIndex:0];
                [self refreshAds];
                
            }break;
                
            default:
                break;
        }
        
    }else{
        
        UIImage *img = [UIImage imageCwNamed:@"icon_tip_normal.png"];
        
        if ([Common connectedToNetwork]) {
            // 网络繁忙，请重新再试
            [Common checkProgressHUD:@"当前网络不可用，请检查你的网络设置" andImage:img showInView:self.view];
        } else {
            // 当前网络不可用，请重新再试
            
            [Common checkProgressHUD:KCWNetNOPrompt andImage:img showInView:self.view];
        }
        
    }
}

- (void)dataError{
    
}


- (void)success{
    
}


@end
