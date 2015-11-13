//
//  SidebarViewController.m
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "SidebarViewController.h"
#import "LeftSideMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "CRNavigationController.h"
#import "GuidePageViewController.h"
#import "UIImageScale.h"
#import "MessageListViewController.h"
#import "DynamicMainViewController.h"
#import "Global.h"
#import "Common.h"

@interface SidebarViewController ()
{
    UIViewController  *_currentMainController;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureReconginzer;
    
    CGFloat currentTranslate;
}

@property (strong, nonatomic) LeftSideMainViewController *leftSideBarViewController;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *navBackView;
@property (strong, nonatomic) NSDictionary *guideDic;

@end

@implementation SidebarViewController
@synthesize leftSideBarViewController,contentView,navBackView,sideBarShowing,guideDic;

static SidebarViewController *rootViewCon;
const int ContentOffset = 240;
const int ContentMinOffset = 60;
const float MoveAnimationDuration = 0.15;

+ (id)share
{
    return rootViewCon;
}

-(void) backToFirstLoginState{
    [self.leftSideBarViewController changeToFirst];
    
    [self makeLoginView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	if (rootViewCon) {
        rootViewCon = nil;
    }
    //进入主界面判断是否自动登录
    BOOL autoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoLogin"];
	if ([Global sharedGlobal].isLogin == YES  || autoLogin == YES ) {
        NSLog(@"====登录了===");
        
    } else {
        [self makeLoginView];
    }
    //获取所以联系人列表
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7){
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
	rootViewCon = self;
    sideBarShowing = NO;
    currentTranslate = 0;
    
    navBackView = [[UIView  alloc] initWithFrame:self.view.frame];
    navBackView.backgroundColor = [UIColor redColor];
    [self.view  addSubview:navBackView];
    contentView = [[UIView  alloc] initWithFrame:self.view.frame];
    [self.view  addSubview:contentView];
    
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
//    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_HEAVY"].CGColor;
    self.contentView.layer.shadowOpacity = 1;
    
    //i6适配切换实现方式
//    DynamicMainViewController* dynamicMainVC = [[DynamicMainViewController alloc] init];
//    NSLog(@"%@",dynamicMainVC.view)
//    CRNavigationController * nav = [[CRNavigationController alloc] initWithRootViewController:dynamicMainVC];
//    dynamicMainVC.accessTypes = AccessPageTypeDefault;
//    RELEASE_SAFE(dynamicMainVC);
//    
//    _currentMainController = nav;
//    [self addChildViewController:_currentMainController];
//    [self.contentView addSubview:_currentMainController.view];
//    [_currentMainController didMoveToParentViewController:self];
    
    LeftSideMainViewController *_leftCon = [[LeftSideMainViewController alloc] init];
    _leftCon.delegate = self;
    self.leftSideBarViewController = _leftCon;
    RELEASE_SAFE(_leftCon);
    
    [self addChildViewController:self.leftSideBarViewController];
    self.leftSideBarViewController.view.frame = self.navBackView.bounds;
    [self.navBackView addSubview:self.leftSideBarViewController.view];
    
    _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
    //snail 0429
    _panGestureReconginzer.delegate = self;
    [self.contentView addGestureRecognizer:_panGestureReconginzer];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    RELEASE_SAFE(leftSideBarViewController);
    RELEASE_SAFE(guideDic);
    RELEASE_SAFE(navBackView);
    RELEASE_SAFE(_tapGestureRecognizer);
    RELEASE_SAFE(_panGestureReconginzer);
    RELEASE_SAFE(_currentMainController);
    RELEASE_SAFE(contentView);
    [super dealloc];
}

#pragma mark --- methods

- (void)contentViewAddTapGestures
{
    if (_tapGestureRecognizer) {
        [self.contentView   removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = nil;
    }
    
    _tapGestureRecognizer = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapOnContentView:)];

    [self.contentView addGestureRecognizer:_tapGestureRecognizer];
}

- (void)tapOnContentView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    //    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
}

- (void)panInContentView:(UIPanGestureRecognizer *)panGestureReconginzer
{
    panGestureReconginzer.delegate = self;
//    CGPoint gesturePoint =  [panGestureReconginzer translationInView:self.contentView];
//    panGestureReconginzer.cancelsTouchesInView = NO;
    
	if (panGestureReconginzer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat translation = [panGestureReconginzer translationInView:self.contentView].x;
        if (translation+currentTranslate <= 0) {
            return;
        }
        self.contentView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
        UIView *view ;
        view = self.leftSideBarViewController.view;
        [self.navBackView bringSubviewToFront:view];
        
	} else if (panGestureReconginzer.state == UIGestureRecognizerStateEnded)
    {
		currentTranslate = self.contentView.transform.tx;
        if (!sideBarShowing) {
            if (fabs(currentTranslate)<ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
                
            }else if(currentTranslate>ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            }else
            {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }else
        {
            if (fabs(currentTranslate)<ContentOffset-ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
                
            }else if(currentTranslate>ContentOffset-ContentMinOffset)
            {
                
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
                
            }else
            {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }
        
        
	}
}

#pragma mark --- UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController.viewControllers count]>1) {
        [self removepanGestureReconginzerWhileNavConPushed:YES];
    }else
    {
        [self removepanGestureReconginzerWhileNavConPushed:NO];
    }
}

- (void)removepanGestureReconginzerWhileNavConPushed:(BOOL)push
{
    if (push) {
        if (_panGestureReconginzer) {
            [self.contentView removeGestureRecognizer:_panGestureReconginzer];
            _panGestureReconginzer = nil;
        }
    }else
    {
        if (!_panGestureReconginzer) {
            _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
            [self.contentView addGestureRecognizer:_panGestureReconginzer];
        }
    }
}

#pragma mark --- SidebarSelectedDelegate
- (void)leftSideBarSelectWithController:(UIViewController *)controller
{
    if ([controller isKindOfClass:[CRNavigationController class]]) {
        
        [(CRNavigationController *)controller setDelegate:self];
    }
    if (_currentMainController == nil) {
        if (IOS_VERSION_7) {
            
        } else {
            //为了防止status bar变色 临时解决方案
            controller.view.frame = CGRectMake(0, -19, controller.view.frame.size.width, controller.view.frame.size.height);
        }
        _currentMainController = controller;
        
		[self addChildViewController:_currentMainController];
		[self.contentView addSubview:_currentMainController.view];
		[_currentMainController didMoveToParentViewController:self];
	} else if (_currentMainController != controller && controller !=nil) {
        
		controller.view.frame = self.contentView.bounds;
		[_currentMainController willMoveToParentViewController:nil];
		[self addChildViewController:controller];
        
		[self transitionFromViewController:_currentMainController
						  toViewController:controller
								  duration:0.0
								   options:UIViewAnimationOptionTransitionCrossDissolve
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
                                    [_currentMainController removeFromParentViewController];
                                    [controller didMoveToParentViewController:self];
                                    _currentMainController = controller;
								}
         ];
	}
    
    [self showSideBarControllerWithDirection:SideBarShowDirectionNone];
}

- (void)showSideBarControllerWithDirection:(SideBarShowDirection)direction
{
    
    if (direction!=SideBarShowDirectionNone) {
        UIView *view ;
        view = self.leftSideBarViewController.view;
        [self.navBackView bringSubviewToFront:view];
    }
    [self moveAnimationWithDirection:direction duration:MoveAnimationDuration];
}

#pragma animation

- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(0, 0);
            }
                break;
            case SideBarShowDirectionLeft:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(ContentOffset, 0);
            }
                break;
            case SideBarShowDirectionRight:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(-ContentOffset, 0);
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        
        self.contentView.userInteractionEnabled = YES;
        self.navBackView.userInteractionEnabled = YES;
        
        if (direction == SideBarShowDirectionNone) {
            
            if (_tapGestureRecognizer) {
                [self.contentView removeGestureRecognizer:_tapGestureRecognizer];
                _tapGestureRecognizer = nil;
            }
            sideBarShowing = NO;
        }else
        {
            [self contentViewAddTapGestures];
            sideBarShowing = YES;
        }
        currentTranslate = self.contentView.transform.tx;
	};
    self.contentView.userInteractionEnabled = NO;
    self.navBackView.userInteractionEnabled = NO;

    [UIView animateWithDuration:duration animations:animations completion:complete];
}

-(void)makeLoginView{
    GuidePageViewController *guideCtl = [[GuidePageViewController alloc]init];
    CRNavigationController *nav= [[CRNavigationController alloc] initWithRootViewController:guideCtl];
    
    nav.modalPresentationStyle = UIModalPresentationCurrentContext;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [nav.navigationBar setBarStyle:UIBarStyleBlack];
    
    [self.navigationController presentViewController:nav animated:NO completion:nil];
    
    RELEASE_SAFE(nav);
    RELEASE_SAFE(guideCtl);
}


- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        
        switch (commandid) {
            case GUIDE_COMMAND_ID:
            {
                self.guideDic = [resultArray objectAtIndex:0];
                
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

// snail 0429 add the delegate
#pragma mark- UIGestureRecognizerDelegete

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView * touchView = [touch view];
    if ([touchView isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    NSLog(@"%@",gestureRecognizer.view.subviews);
    return YES;
}


//解决TableViewCell编辑冲突。 通过该代理找到手势识别器中和需要删除的相关tableViewCell的手势识别器让他们和本view的手势识别器可以被同时触发
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UITableViewCellScrollView")]) {
        return YES;
    }
    return NO;
}

@end
